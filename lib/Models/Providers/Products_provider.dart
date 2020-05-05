import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/Models/Providers/http_exception.dart';
import 'dart:convert';

import 'Product.dart';

class Products with ChangeNotifier {
  List<Product> _item = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  List<Product> get item {
    return [..._item];
  }

  List<Product> get favItems {
    return _item.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return item.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndGetProducts() async {
    try {
      const url = 'https://shop-app-e2be0.firebaseio.com/products.json';
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if(extractedData==null){
      return;
    }
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
          isFavorite: prodData['isFavourite'],
        ));
        _item = loadedProducts;
        notifyListeners();
      });
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    const url = 'https://shop-app-e2be0.firebaseio.com/products.json';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavourite': product.isFavorite,
        }),
      );
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          imageUrl: product.imageUrl,
          price: product.price);
      _item.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final index = _item.indexWhere((prod) => prod.id == id);
    final url = 'https://shop-app-e2be0.firebaseio.com/products/$id.json';
    http.patch(url,
        body: json.encode({
          'title': newProduct.title,
          'description': newProduct.description,
          'imageUrl': newProduct.imageUrl,
          'price': newProduct.price,
        }));
    _item[index] = newProduct;
    notifyListeners();
  }

  Future<void> deleteproduct(String id) async{
    final url = 'https://shop-app-e2be0.firebaseio.com/products/$id.json';
    final existingProductIndex = _item.indexWhere((prod) => prod.id == id);
    var _existingProduct = _item[existingProductIndex];
    _item.removeWhere((prod) => prod.id == id);
    notifyListeners();
    final response= await http.delete(url);
      if(response.statusCode>=400){
        _item.insert(existingProductIndex, _existingProduct);
      notifyListeners();
        throw HttpExecption("Could not delete");
      }
      _existingProduct = null;
      
  }
}
