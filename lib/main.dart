import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/Screens/Cart_screen.dart';
import 'package:shop/Screens/orders_screen.dart';

import 'Models/Providers/Products_provider.dart';
import 'Models/Providers/cart.dart';
import 'Models/Providers/orders.dart';
import 'Screens/Product_Detail_screen.dart';
import 'Screens/Product_overview_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Products(),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProvider.value(
          value: Order(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: ProductOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrdersScreen.routename:(ctx)=>OrdersScreen(),
        },
      ),
    );
  }
}
