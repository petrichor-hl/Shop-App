import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/cart_element.dart';
import '../models/order_element.dart';

class Orders with ChangeNotifier {
  // ignore: prefer_final_fields
  List<OrderElement> _orders = [];

  List<OrderElement> get orders {
    return _orders;
  }

  Future<void> fetchOrdersData() async {
    final url = Uri.parse(
        "https://flutter-shop-app-7406e-default-rtdb.asia-southeast1.firebasedatabase.app/orders.json");
    final response = await http.get(url);
    if (json.decode(response.body) == null) {
      return;
    }
    _orders.clear();
    final Map<String, dynamic> extractedData = json.decode(response.body);
    extractedData.forEach((key, value) {
      _orders.insert(
        0,
        OrderElement(
          id: key,
          amount: value["amount"] as double,
          products: (value["products"] as List<dynamic>)
              .map((e) => CartElement(
                    // productID: e["productID"],
                    // id: e["id"],
                    productID: "",
                    id: "",
                    title: e["title"],
                    price: e["price"],
                    quantity: e["quantity"],
                  ))
              .toList(),
          dateTime: DateTime.parse(value["dateTime"]),
        ),
      );
    });
    notifyListeners();
  }

  Future<void> addOrder(List<CartElement> cart, double total) async {
    final url = Uri.parse(
        "https://flutter-shop-app-7406e-default-rtdb.asia-southeast1.firebasedatabase.app/orders.json");
    final timestamp = DateTime.now();
    await http.post(
      url,
      body: json.encode(
        {
          "amount": total,
          "products": cart
              .map((e) => {
                    // "productID": e.productID,
                    // "id": e.id,
                    "title": e.title,
                    "price": e.price,
                    "quantity": e.quantity,
                  })
              .toList(),
          "dateTime": timestamp.toIso8601String(),
        },
      ),
    );
  }
}
