import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../providers/orders.dart';

class OrderNowButton extends StatefulWidget {
  final Cart cart;
  const OrderNowButton(
    this.cart, {
    Key? key,
  }) : super(key: key);

  @override
  State<OrderNowButton> createState() => _OrderNowButtonState();
}

class _OrderNowButtonState extends State<OrderNowButton> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: SizedBox(
        height: 62,
        width: 130,
        child: ElevatedButton(
          onPressed: (widget.cart.totalAmount == 0)
              ? null
              : () async {
                  setState(() {
                    isLoading = true;
                  });
                  try {
                    await Provider.of<Orders>(context, listen: false).addOrder(
                      widget.cart.items,
                      widget.cart.totalAmount,
                    );
                    widget.cart.clear();
                  } catch (error) {
                    await showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text("An error occurred"),
                        content: const Text("Something went wrong"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text("OK"),
                          ),
                        ],
                      ),
                    );
                  }
                  setState(() {
                    isLoading = false;
                  });
                },
          child: isLoading
              ? const CircularProgressIndicator(
                  backgroundColor: Colors.white,
                )
              : const Text(
                  "ORDER NOW",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
        ),
      ),
    );
  }
}
