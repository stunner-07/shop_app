import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/Models/Providers/orders.dart';
import 'package:shop/Widgets/app_drawer.dart';
import 'package:shop/Widgets/order_item.dart' as or;

class OrdersScreen extends StatelessWidget {
  static const   routename='/orders';
  @override
  Widget build(BuildContext context) {
    final order = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders"),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemBuilder: (ctx, i) =>or.OrderItem(order.orders[i]),
        itemCount: order.orders.length,
      ),
    );
  }
}
