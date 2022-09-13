import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/order_element.dart';

class OrderItem extends StatefulWidget {
  final OrderElement order;

  const OrderItem(this.order, {Key? key}) : super(key: key);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() {
              expanded = !expanded;
            }),
            child: ListTile(
              title: Text("\$${widget.order.amount.toStringAsFixed(2)}"),
              subtitle: Text(
                  "Date: ${DateFormat("dd/MM/yyyy").format(widget.order.dateTime)} at ${DateFormat("hh:mm").format(widget.order.dateTime)}"),
              trailing: Icon(expanded ? Icons.expand_less : Icons.expand_more),
            ),
          ),
          if (expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: Column(
                children: [
                  const Divider(
                    height: 0,
                  ),
                  const SizedBox(height: 10),
                  ...widget.order.products.map(
                    (e) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 6,
                          child: Text(
                            e.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 30,
                          child: Text(
                            "${e.quantity}",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        const Text(
                          "x",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.end,
                        ),
                        SizedBox(
                          width: 70,
                          child: Text(
                            "\$${e.price}",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
