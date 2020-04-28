import 'package:flutter/material.dart';
import 'package:shop/Screens/orders_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Hello'),
            automaticallyImplyLeading: false,
          ),
          //Divider(),
          ListTile(
            leading: Icon(
              Icons.shop,
            ),
            title: Text('My Shop'),
            onTap: (){
              Navigator.of(context).pushNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.payment,
            ),
            title: Text('My Orders'),
            onTap: (){
              Navigator.of(context).pushNamed(OrdersScreen.routename);
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}
