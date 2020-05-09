import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/Models/Providers/cart.dart';
import 'package:shop/Models/Providers/orders.dart';
import 'package:shop/Widgets/cart_item.dart' as ci;

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("My Cart"),
      ),
      body: Column(children: <Widget>[
        Card(
          margin: EdgeInsets.all(15),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Total",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  // SizedBox(
                  //   width: 10,
                  // ),
                  Chip(
                    label: Text(
                      "Rs${cart.totalAmount.toStringAsFixed(2)}",
                      style: Theme.of(context).primaryTextTheme.headline6,
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart: cart)
                ]),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: ListView.builder(
            itemBuilder: (ctx, i) => ci.CartItem(
              price: cart.items.values.toList()[i].price,
              id: cart.items.values.toList()[i].id,
              title: cart.items.values.toList()[i].title,
              quantity: cart.items.values.toList()[i].quantity,
              productId: cart.items.keys.toList()[i],
            ),
            itemCount: cart.count,
          ),
        )
      ]),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: widget.cart.totalAmount <= 0 || _isLoading
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Order>(context, listen: false).addOrder(
                  widget.cart.items.values.toList(), widget.cart.totalAmount);
              widget.cart.clearCart();
              setState(() {
                _isLoading = false;
              });
            },
      child: _isLoading? CircularProgressIndicator():Text(
        "Order Now",
        style: TextStyle(
          color: widget.cart.totalAmount <= 0 || _isLoading?Colors.grey: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
