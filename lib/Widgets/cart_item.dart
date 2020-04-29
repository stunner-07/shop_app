import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/Models/Providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String title;
  final double price;
  final String productId;
  final int quantity;
  CartItem({this.id, this.productId, this.title, this.price, this.quantity});
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Colors.redAccent,
        child: Icon(
          Icons.delete,
          size: 40,
          color: Colors.white,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction){
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Are You sure?'),
                  content: Text(
                    "Your want to remove this item from cart?",
                  ),
                  actions: <Widget>[
                    FlatButton(onPressed: (){
                      Navigator.of(ctx).pop(true);
                    },child:Text("Yes"),),
                    FlatButton(onPressed: (){
                      Navigator.of(ctx).pop(false);
                    },child: Text("No"),),
                  ],
                ));
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: FittedBox(
                  child: Text("Rs $price"),
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text("Total: ${price * quantity}"),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
