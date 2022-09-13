import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

import '../widgets/order_now_button.dart';
import '../widgets/total_amount_bart.dart';
import '../widgets/cart_item.dart';

class ShoppingCartScreen extends StatelessWidget {
  static const routeName = "/shopping-cart";

  const ShoppingCartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                const TotalAmountBart(),
                const SizedBox(width: 5),
                Consumer<Cart>(
                  builder: (context, value, child) => OrderNowButton(value),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<Cart>(
              builder: (_, value, child) => ListView.builder(
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 14,
                ),
                itemBuilder: (ctx, index) => CartItem(
                  value.items[index].productID,
                  value.items[index].id,
                  value.items[index].title,
                  value.items[index].price,
                  value.items[index].quantity,
                ),
                itemCount: value.itemCount,
              ),
            ),
          )
        ],
      ),
    );
  }
}
