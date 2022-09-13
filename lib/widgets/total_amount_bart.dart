import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class TotalAmountBart extends StatelessWidget {
  const TotalAmountBart({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 8,
        child: SizedBox(
          height: 62,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total:",
                  style: TextStyle(fontSize: 20),
                ),
                // Spacer(),
                SizedBox(
                  width: 95,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Chip(
                      label: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 8,
                        ),
                        child: FittedBox(
                          child: Consumer<Cart>(
                            builder: (_, value, child) => Text(
                              "\$${value.totalAmount.toStringAsFixed(2)}",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
