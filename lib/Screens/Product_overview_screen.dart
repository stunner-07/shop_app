import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/Models/Providers/Products_provider.dart';
import 'package:shop/Models/Providers/cart.dart';
import 'package:shop/Widgets/app_drawer.dart';
import 'package:shop/Widgets/badge.dart';
import 'package:shop/Widgets/product_item.dart';

import 'Cart_screen.dart';

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var init = true;
  bool _isLoading = false;
  @override
  void initState() {
    //Provider.of<Products>(context).fetchAndGetProducts();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (init) {
      _isLoading = true;
      Provider.of<Products>(context).fetchAndGetProducts().then((onValue) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    init = false;
    super.didChangeDependencies();
  }

  bool _showFav = false;
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context, listen: false);
    final loadedProducts = _showFav ? productData.favItems : productData.item;
    return Scaffold(
      appBar: AppBar(
        title: Text("MY SHOP"),
        actions: <Widget>[
          PopupMenuButton(
              onSelected: (int selectedValue) {
                setState(() {
                  if (selectedValue == 0) {
                    _showFav = true;
                  } else {
                    _showFav = false;
                  }
                });
              },
              icon: Icon(
                Icons.more_vert,
              ),
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text("Show Fav"),
                      value: 0,
                    ),
                    PopupMenuItem(
                      child: Text("Show All"),
                      value: 1,
                    )
                  ]),
          Consumer<Cart>(
            builder: (_, cartData, ch) => Badge(
              child: ch,
              value: cartData.count.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                value: loadedProducts[i],
                child: ProductItem(
                    // loadedProducts[i].id, loadedProducts[i].title,
                    //   loadedProducts[i].imageUrl
                    ),
                //create: (BuildContext context) => loadedProducts[i],
              ),
              itemCount: loadedProducts.length,
              padding: const EdgeInsets.all(10),
            ),
    );
  }
}
