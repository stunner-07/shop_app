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

  String authToken;
  String userId;
  void update(String auth,String id) {
    authToken = auth;
    userId=id;
  }
  //Order(this.authToken,this.userId,this._orders);
  Future<void> fetchAndGetOrders() async {
    //print(userId);
    final url =
        'https://shop-app-e2be0.firebaseio.com/orders/$userId.json?auth=$authToken';
    final reponse = await http.get(url);
    //print(reponse.body);
    List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(reponse.body) as Map<String, dynamic>;
    if (extractedData == null) {
      //_orders=[];
      return;
    }
    //print(extractedData);
    extractedData.forEach((orderId, orderData) {
      //print(orderData);
      loadedOrders.add(
        OrderItem(
          id: orderId,
          products: (orderData['products'] as List<dynamic>).map((items) {
            //print(items['title']);
            return CartItem(
              id: items['id'],
              price: items['price'],
              title: items['title'],
              quantity: items['quantity'],
            );
            //print(items['id']);
          }).toList(),
          dateTime: DateTime.parse(
            orderData['dateTime'],
          ),
          amount: double.parse(orderData['amount'].toString()),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    //print(_orders.length);
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url =
        'https://shop-app-e2be0.firebaseio.com/orders/$userId.json?auth=$authToken';
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
        //print(_orders.length);
    notifyListeners();
  }
}
