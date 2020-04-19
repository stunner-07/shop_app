import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop/Models/Providers/Products_provider.dart';
import 'package:shop/Widgets/product_item.dart';
class ProductGrid extends StatelessWidget {
   final bool showFav;
    ProductGrid(this.showFav);
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final loadedProducts = showFav ? productData.favItems : productData.item;
   
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (ctx, i) => ChangeNotifierProvider(
          child: ProductItem(
              // loadedProducts[i].id, loadedProducts[i].title,
              //   loadedProducts[i].imageUrl
              ),
          create: (BuildContext context) => loadedProducts[i],
        ),
        itemCount: loadedProducts.length,
        padding: const EdgeInsets.all(10),
      );
  }
}