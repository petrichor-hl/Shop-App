import 'package:flutter/material.dart';
import '../models/cart_element.dart';

class Cart with ChangeNotifier {
  // ignore: prefer_final_fields
  List<CartElement> _items = [];

  List<CartElement> get items {
    return _items;
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0.0;
    for (int i = 0; i < _items.length; ++i) {
      total += _items[i].price * _items[i].quantity;
    }
    return total;
  }

  void addElement(String productID, String title, double price) {
    final existingIndex =
        _items.indexWhere((element) => element.productID == productID);
    if (existingIndex >= 0) {
      _items[existingIndex].quantity += 1;
    } else {
      _items.add(
        CartElement(
          productID: productID,
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeElement(String id) {
    _items.removeWhere((element) => element.productID == id);
    notifyListeners();
  }

  void undoAddElement(String id) {
    final existingIndex =
        _items.indexWhere((element) => element.productID == id);
    if (_items[existingIndex].quantity > 1) {
      _items[existingIndex].quantity -= 1;
    } else {
      _items.removeAt(existingIndex);
    }
    notifyListeners();
  }

  void clear() {
    _items = [];
    notifyListeners();
  }
}
