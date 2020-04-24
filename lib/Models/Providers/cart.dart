import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final int quantity;
  CartItem({this.id, this.title, this.price, this.quantity});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items={};
  Map<String, CartItem> get items {
    return {..._items};
  }
  int get count{
    return _items.length;
  }
  
  double get totalAmount{
    double total=0;
    _items.forEach((key,cartItem){
      total+=cartItem.price*cartItem.quantity ;
    });
    return total;
  }
  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (exisiting) => CartItem(
              id: exisiting.id,
              title: exisiting.title,
              price: exisiting.price,
              quantity: exisiting.quantity + 1));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              price: price,
              quantity: 1));
    }
    notifyListeners();
  }
}
