import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {@required this.id, @required this.amount, @required this.products, @required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;


  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders => [..._orders];

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = 'https://shop-app-cc4e8-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    final timeStamp = DateTime.now();
    try {
      final response = await http.post(url, body: json.encode({
        'amount': total,
        'products': cartProducts
            .map((cp) =>
        {
          'id': cp.id,
          'title': cp.title,
          'quantity': cp.quantity,
          'price': cp.price,
        })
            .toList(),
        'dateTime': timeStamp.toIso8601String(),
      }));
      _orders.insert(0, OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartProducts,
        dateTime: timeStamp,
      ));
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> fetchAndSetOrders() async {
    final url = 'https://shop-app-cc4e8-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<OrderItem> loadedProducts = [];
      if (extractedData != null) {
        extractedData.forEach((id, data) {
                loadedProducts.add(
                  OrderItem(
                      id: id,
                      amount: data['amount'],
                      products: (data['products'] as List<dynamic>).map((item) =>
                          CartItem(
                              id: item['id'],
                              title: item['title'],
                              quantity: item['quantity'],
                              price: item['price'])).toList(),
                      dateTime: DateTime.parse(data['dateTime'])),
                );
                _orders = loadedProducts.reversed.toList();
                notifyListeners();
              });
      }
    } catch (e) {
      throw e;
    }
  }


}
