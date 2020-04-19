import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/Models/Providers/Products_provider.dart';


class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProducts = Provider.of<Products>(context,listen: false)
        .findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          loadedProducts.title,
        ),
      ),
    );
  }
}
