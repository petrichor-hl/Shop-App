import './cart_element.dart';

class OrderElement {
  final String id;
  final double amount;
  final List<CartElement> products;
  final DateTime dateTime;

  const OrderElement({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}
