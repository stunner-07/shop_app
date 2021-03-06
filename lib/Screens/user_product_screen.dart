import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/Models/Providers/Products_provider.dart';
import 'package:shop/Screens/edit_Product_screen.dart';
import 'package:shop/Widgets/app_drawer.dart';
import 'package:shop/Widgets/user_product_item.dart';

class UserProductScreen extends StatelessWidget {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  static const routeName = '/userProduct';
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context, listen: false);
   // print("y");
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
      body: FutureBuilder(
        future: productData.fetchAndGetProducts(true),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    key: _refreshIndicatorKey,
                    child: Consumer<Products>(
                      builder: (ctx, productsData, _) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemBuilder: (_, i) {
                            return Column(
                              children: <Widget>[
                                UserProductItem(
                                    productsData.item[i].id,
                                    productsData.item[i].title,
                                    productsData.item[i].imageUrl),
                                Divider(),
                              ],
                            );
                          },
                          itemCount: productsData.item.length,
                        ),
                      ),
                    ),
                    onRefresh: () async {
                      await productData.fetchAndGetProducts(true);
                    },
                  ),
      ),
    );
  }
}
