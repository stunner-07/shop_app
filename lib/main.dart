import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Models/Providers/Products_provider.dart';
import 'Screens/Product_Detail_screen.dart';
import 'Screens/Product_overview_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
       create: (BuildContext context)=>Products(),
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
          ProductDetailScreen.routeName:(ctx)=>ProductDetailScreen(),
        },
      ),
    );
  }
}