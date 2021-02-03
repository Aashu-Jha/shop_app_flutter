import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({@required this.id,@required this.title,@required this.description,@required this.price,@required this.imageUrl,
      this.isFavorite = false});

  Future<void> toggleFavorite() async {
    final url = 'https://shop-app-cc4e8-default-rtdb.firebaseio.com/products/$id.json';
    final oldState = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final response = await http.patch(url, body: json.encode({
        'isFavorite' : isFavorite,
      }));
      if(response.statusCode >= 400) {
        _setValue(oldState);
      }
    } catch (e) {
      _setValue(oldState);
    }

  }

  void _setValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }
}