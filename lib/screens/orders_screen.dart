import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/order_element.dart';
import '../providers/orders.dart';
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = "/orders";
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Orders"),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchOrdersData(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.error == null) {
              return Consumer<Orders>(
                builder: (ctx, value, child) {
                  List<OrderElement> ordersData = value.orders;
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 4),
                    itemBuilder: (ctx, index) => OrderItem(ordersData[index]),
                    itemCount: ordersData.length,
                  );
                },
              );
            } else {
              return const Center(
                child: Text("An error occurred"),
              );
            }
          }
        },
      ),
    );
  }
}
