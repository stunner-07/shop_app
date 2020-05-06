import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/Models/Providers/orders.dart';
import 'package:shop/Widgets/app_drawer.dart';
import 'package:shop/Widgets/order_item.dart' as or;

class OrdersScreen extends StatefulWidget {
  static const routename = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _isLoading = false;
  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Order>(context, listen: false).fetchAndGetOrders();
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final order = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders"),
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemBuilder: (ctx, i) {
                //print(order.orders[i].products);
                return or.OrderItem(order.orders[i]);
              },
              itemCount: order.orders.length,
            ),
    );
  }
}
