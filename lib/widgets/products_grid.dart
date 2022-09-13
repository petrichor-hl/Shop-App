import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import './product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;

  const ProductsGrid(this.showFavs, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context, listen: false);
    final productsData = showFavs ? products.favoritesItems : products.allItems;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 3 / 2,
      ),
      itemBuilder: (ctx, index) {
        return ChangeNotifierProvider.value(
          value: productsData[index],
          // ignore: prefer_const_constructors
          child: ProductItem(),
          // Note for myself: "const ProductItem()" will wrong
          // when switch to "Show Favorites".
        );
      },
      itemCount: productsData.length,
    );
  }
}
