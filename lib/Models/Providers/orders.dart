import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shop/Models/Providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  OrderItem({this.id, this.amount, this.dateTime, this.products});
}

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];
  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndGetOrders() async {
    const url = 'https://shop-app-e2be0.firebaseio.com/orders.json';
    final reponse = await http.get(url);
    List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(reponse.body) as Map<String, dynamic>;
    if(extractedData==null){
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(OrderItem(
        id: orderId,
        amount: orderData['amount'],
        dateTime: DateTime.parse(
          orderData['dateTime'],
        ),
        products: (orderData['products'] as List<dynamic>).map((items) {
          CartItem(
            id: items['id'],
            price: items['price'],
            title: items['title'],
            quantity: items['quantity'],
          );
        }).toList(),
      ));
    });
    _orders=loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    const url = 'https://shop-app-e2be0.firebaseio.com/orders.json';
    final timeStamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'amount': total.toString(),
          'dateTime': timeStamp.toIso8601String(),
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price,
                  })
              .toList(),
        }));
    _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          dateTime: timeStamp,
          products: cartProducts,
        ));
    notifyListeners();
  }
}
