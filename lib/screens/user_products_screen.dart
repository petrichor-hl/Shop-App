import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';
import '../screens/edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = "/user-products-screen";
  const UserProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Products"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, EditProductScreen.routeName);
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: Consumer<Products>(
        builder: (_, value, child) {
          final productsData = value.allItems;
          return ListView.separated(
            padding: const EdgeInsets.all(14),
            itemBuilder: (ctx, index) => UserProductItem(
              productsData[index].id,
              productsData[index].title,
              productsData[index].imageUrl,
            ),
            itemCount: productsData.length,
            separatorBuilder: (ctx, index) => const Divider(),
          );
        },
      ),
    );
  }
}
