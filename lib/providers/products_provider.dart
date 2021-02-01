import 'package:flutter/material.dart';
import 'package:shop_app/providers/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
      'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
        id: 'p2',
        title: 'Trousers',
        description: 'A nice pair of trousers.',
        price: 59.99,
        imageUrl:
        "https://www.rei.com/media/82e49785-ebcb-425e-9d37-c23ca3197baa"
    ),
    Product(
      id: 'p3',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
      'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
        id: 'p4',
        title: 'Trousers',
        description: 'A nice pair of trousers.',
        price: 59.99,
        imageUrl:
        "https://www.rei.com/media/82e49785-ebcb-425e-9d37-c23ca3197baa"
    ),

  ];

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  List<Product> get items {
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  //implementation of Future class and it's methods
  //.then() and .catchError()
  //These are alternatives of async and await
  Future<void> addProducts(Product product) {
    const url = 'https://shop-app-cc4e8-default-rtdb.firebaseio.com/products.json';
    return http.post(url, body: json.encode(
        {'title': product.title,
          'description' : product.description,
          'price' : product.price,
          'imageUrl' : product.imageUrl,
        }
    )).then((response) {
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl
      );
      _items.add(newProduct);
      notifyListeners();
    }).catchError((error) {
      throw error;
    });
  }

  void updateProducts(String id, Product updatedProduct) {
    final idx = _items.indexWhere((element) => element.id == id);
    if(idx >= 0) {
      _items[idx] = updatedProduct;
      notifyListeners();
    }else{
      print('Can\'t find index!!');
    }
  }

  void deleteProducts(String id) {
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
