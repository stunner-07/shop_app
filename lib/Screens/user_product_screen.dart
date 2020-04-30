import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/Models/Providers/Products_provider.dart';
import 'package:shop/Screens/edit_Product_screen.dart';
import 'package:shop/Widgets/app_drawer.dart';
import 'package:shop/Widgets/user_product_item.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName='/userProduct';
  @override
  Widget build(BuildContext context) {
    final productData=Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Products"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(itemBuilder:(_,i){
          return Column(
            children: <Widget>[
              UserProductItem(productData.item[i].id, productData.item[i].title, productData.item[i].imageUrl),
              Divider(),
            ],
          );
        } ,itemCount:productData.item.length ,),
      ),
    );
  }
}
