import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = "/edit-product-screen";
  const EditProductScreen({Key? key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  String? productID;
  String productTitle = "";
  String productDescription = "";
  String productPrice = "";
  String productImageUrl = "";
  late bool productIsFavorite = false;

  bool _isInit = true;
  late bool _isEdit;
  // _isEdit = true <=> productID != null;

  bool _isLoading = false;

  late NavigatorState nav;

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImageUrl);
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      productID = ModalRoute.of(context)!.settings.arguments as String?;
      if (productID != null) {
        // It means that user tap into Edit IconButton in user_product_item
        _isEdit = true;
        final product = Provider.of<Products>(context, listen: false)
            .findById(productID as String);
        productTitle = product.title;
        productDescription = product.description;
        productPrice = product.price.toString();
        _imageUrlController.text = product.imageUrl;
        productIsFavorite = product.isFavorite;
      } else {
        // It means that user tap into Add IconButton in the AppBar
        _isEdit = false;
      }
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      final enteredText = _imageUrlController.text;
      if (enteredText.isEmpty ||
          (!enteredText.startsWith("http") &&
              !enteredText.startsWith("https")) ||
          (!enteredText.endsWith(".png") &&
              !enteredText.endsWith(".jpg") &&
              !enteredText.endsWith(".jpeg"))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _form.currentState!.save();
    final newProduct = Product(
      id: productID ?? "It will get id from database",
      title: productTitle,
      description: productDescription,
      price: double.parse(productPrice),
      imageUrl: productImageUrl,
      isFavorite: productIsFavorite,
    );
    if (_isEdit) {
      try {
        await Provider.of<Products>(context, listen: false)
            .updateProduct(productID as String, newProduct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("An error occurred"),
            content: const Text("Could not update product"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(newProduct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("An error occurred"),
            content: const Text("Could not add product"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    nav.pop();
  }

  @override
  Widget build(BuildContext context) {
    nav = Navigator.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Configurate Product"),
        actions: [
          IconButton(
            onPressed: () {
              FocusManager.instance.primaryFocus?.unfocus();
              _saveForm();
            },
            icon: _isEdit ? const Icon(Icons.save) : const Icon(Icons.done),
          )
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: productTitle,
                        decoration: const InputDecoration(
                          labelText: "Title",
                          // errorText: ,
                        ),
                        textInputAction: TextInputAction.next,
                        onSaved: (newValue) =>
                            productTitle = newValue as String,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter a title.";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: productPrice,
                        decoration: const InputDecoration(
                          labelText: "Price",
                        ),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        onSaved: (newValue) =>
                            productPrice = newValue as String,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter a price.";
                          }
                          if (double.tryParse(value) == null) {
                            return "Please enter a valid number.";
                          }
                          if (double.parse(value) <= 0) {
                            return "Please enter a positive number";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: productDescription,
                        decoration: const InputDecoration(
                          labelText: "Description",
                        ),
                        maxLines: 3,
                        onSaved: (newValue) =>
                            productDescription = newValue as String,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter a description.";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        // crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            height: 120,
                            width: 120,
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: _imageUrlController.text.isEmpty
                                ? const Center(child: Text("Enter a URL"))
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(13),
                                    child: Image.network(
                                      _imageUrlController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _imageUrlController,
                              focusNode: _imageUrlFocusNode,
                              decoration:
                                  const InputDecoration(labelText: "Image URL"),
                              keyboardType: TextInputType.url,
                              minLines: 1,
                              maxLines: 4,
                              onSaved: (newValue) =>
                                  productImageUrl = newValue as String,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter an image URL.";
                                }
                                if (!value.startsWith("http") &&
                                    !value.startsWith("https")) {
                                  return "Please enter a valid URL.";
                                }
                                if (!value.endsWith(".png") &&
                                    !value.endsWith(".jpg") &&
                                    !value.endsWith(".jpeg")) {
                                  return "Please enter a valid image URL.";
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              _saveForm();
                            },
                            child: _isEdit
                                ? const Text("Save")
                                : const Text("Done"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
