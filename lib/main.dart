import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/Screens/Cart_screen.dart';
import 'package:shop/Screens/auth_screen.dart';
import 'package:shop/Screens/edit_Product_screen.dart';
import 'package:shop/Screens/orders_screen.dart';
import 'package:shop/Screens/user_product_screen.dart';

import 'Models/Providers/Products_provider.dart';
import 'Models/Providers/auth.dart';
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
            value: Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            create: (BuildContext context)=>Products(),
            update: (BuildContext context, auth, previousProducts)=> previousProducts..update(auth.token),
          ),
          ChangeNotifierProvider.value(
            value: Cart(),
          ),
          ChangeNotifierProxyProvider<Auth,Order>(
            create: (context)=>Order(),
            update: (context,auth,previousOrder)=>previousOrder..update(auth.token),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato',
            ),
            home: auth.isAuth ? ProductOverviewScreen() : AuthScreen(),
            routes: {
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrdersScreen.routename: (ctx) => OrdersScreen(),
              UserProductScreen.routeName: (ctx) => UserProductScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen(),
              //AuthScreen.routeName:(ctx)=>AuthScreen(),
            },
          ),
        ));
  }
}
