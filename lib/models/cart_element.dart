class CartElement {
  final String productID;
  final String id;
  final String title;
  final double price;
  int quantity;

  CartElement({
    required this.productID,
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
  });
}
