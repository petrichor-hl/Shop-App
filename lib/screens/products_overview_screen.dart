import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../providers/cart.dart';

import '../screens/shopping_cart_screen.dart';
import '../widgets/badge.dart';
import '../widgets/products_grid.dart';
import '../widgets/app_drawer.dart';

enum FilterOptions {
  favorite,
  all,
}

// ignore: must_be_immutable
class ProductsOverviewScreen extends StatefulWidget {
  ProductsOverviewScreen({Key? key}) : super(key: key);
  bool firstInit = true;
  bool showOnlyFavorites = false;

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool isError = false;

  @override
  void initState() {
    super.initState();
    if (widget.firstInit) {
      Provider.of<Products>(context, listen: false)
          .fetchProductsData()
          .then(
            (_) => setState(() {
              widget.firstInit = false;
            }),
          )
          .catchError((error) async {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            // title: const Text("An error occurred"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.error,
                  size: 40,
                  color: Colors.red,
                ),
                SizedBox(height: 20),
                Text(
                  "Please check your internet connection!",
                  style: TextStyle(fontSize: 17),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("OK"),
              ),
            ],
            contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0),
          ),
        );
        setState(() {
          isError = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.showOnlyFavorites
            ? const Text("My Favorite")
            : const Text("My Shop"),
        actions: [
          PopupMenuButton(
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                value: FilterOptions.favorite, // 0
                child: Text("Only Favorites"),
              ),
              const PopupMenuItem(
                value: FilterOptions.all, // 1
                child: Text("Show All"),
              ),
            ],
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.favorite) {
                  widget.showOnlyFavorites = true;
                } else {
                  widget.showOnlyFavorites = false;
                }
              });
            },
            icon: const Icon(Icons.more_vert),
          ),
          Consumer<Cart>(
            builder: (_, value, ch) => Badge(
              value: value.itemCount,
              child: ch as Widget,
            ),
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, ShoppingCartScreen.routeName);
              },
              icon: const Icon(Icons.shopping_cart),
            ),
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: isError
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                Icon(
                  Icons.error,
                  size: 40,
                ),
                SizedBox(height: 10),
                Text(
                  "Did you connect Internet?",
                  style: TextStyle(fontSize: 17),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 5),
                Text(
                  "Please restart your app",
                  style: TextStyle(fontSize: 17),
                  textAlign: TextAlign.center,
                ),
              ],
            )
          : widget.firstInit
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ProductsGrid(widget.showOnlyFavorites),
    );
  }
}
