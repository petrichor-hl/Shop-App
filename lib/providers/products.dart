import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import './product.dart';

class Products with ChangeNotifier {
  // ignore: prefer_final_fields
  List<Product> _items = [];

  Future<void> fetchProductsData() async {
    final url = Uri.parse(
        "https://flutter-shop-app-7406e-default-rtdb.asia-southeast1.firebasedatabase.app/products.json");

    final response = await http.get(url);
    _items.clear();
    final Map<String, dynamic> extractedData = json.decode(response.body);
    extractedData.forEach((key, value) {
      _items.add(
        Product(
          id: key,
          title: value["title"] as String,
          description: value["description"] as String,
          price: value["price"] as double,
          imageUrl: value["imageUrl"] as String,
          isFavorite: value["isFavorite"] as bool,
        ),
      );
    });
  }

  List<Product> get allItems {
    return _items;
  }

  List<Product> get favoritesItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere(
      (element) => element.id == id,
    );
  }

  Future<void> addProduct(Product newProduct) async {
    final url = Uri.parse(
        "https://flutter-shop-app-7406e-default-rtdb.asia-southeast1.firebasedatabase.app/products.json");
    final response = await http.post(
      url,
      body: json.encode(
        {
          "title": newProduct.title,
          "description": newProduct.description,
          "price": newProduct.price,
          "imageUrl": newProduct.imageUrl,
          "isFavorite": newProduct.isFavorite,
        },
      ),
    );

    newProduct.id = json.decode(response.body)["name"];
    _items.add(newProduct);
    notifyListeners();
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final existingIndex = _items.indexWhere((element) => element.id == id);
    final oldProuduct = _items[existingIndex];
    _items[existingIndex] = newProduct;
    notifyListeners();

    final url = Uri.parse(
        "https://flutter-shop-app-7406e-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json");
    final response = await http.patch(
      url,
      body: json.encode(
        {
          "title": newProduct.title,
          "description": newProduct.description,
          "price": newProduct.price,
          "imageUrl": newProduct.imageUrl,
        },
      ),
    );
    if (response.statusCode >= 400) {
      _items[existingIndex] = oldProuduct;
      notifyListeners();
      throw HttpException("Could not update product");
    }
  }

  Future<void> deleteProduct(String id) async {
    final existingProuductIndex =
        _items.indexWhere((element) => element.id == id);
    final existingProuduct = _items[existingProuductIndex];
    _items.removeWhere((element) => element.id == id);
    notifyListeners();

    final url = Uri.parse(
        "https://flutter-shop-app-7406e-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json");
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProuductIndex, existingProuduct);
      notifyListeners();
      throw HttpException("Could not delete product");
    }
  }
}
