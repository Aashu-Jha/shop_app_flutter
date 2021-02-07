import 'package:flutter/material.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/providers/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //   'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //     id: 'p2',
    //     title: 'Trousers',
    //     description: 'A nice pair of trousers.',
    //     price: 59.99,
    //     imageUrl:
    //     "https://www.rei.com/media/82e49785-ebcb-425e-9d37-c23ca3197baa"
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //   'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //     id: 'p4',
    //     title: 'Trousers',
    //     description: 'A nice pair of trousers.',
    //     price: 59.99,
    //     imageUrl:
    //     "https://www.rei.com/media/82e49785-ebcb-425e-9d37-c23ca3197baa"
    // ),

  ];

  final String authToken;
  final String userId;


  Products(this.authToken, this.userId, this._items);

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  List<Product> get items {
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  //it will request the web and then decode it with json as Map and then for each id it will re-write the entire list of items.
  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    String filterString = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url = 'https://shop-app-cc4e8-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if(extractedData == null){
        return;
      }
      url = 'https://shop-app-cc4e8-default-rtdb.firebaseio.com/userFavroites/$userId/products.json?auth=$authToken';
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((id, data) {
        loadedProducts.add(
          Product(
            id: id,
            title: data['title'],
            description: data['description'],
            price: data['price'],
            imageUrl: data['imageUrl'],
            isFavorite: favoriteData == null ? false: favoriteData[id] ?? false,
          ),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      //error will be resolve in callback method.
      throw error;
    }
  }

  //implementation of Future class and it's methods
  //.then() and .catchError()
  //These are alternatives of async and await
  Future<void> addProducts(Product product) {
    final url = 'https://shop-app-cc4e8-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    return http.post(url, body: json.encode(
        {'title': product.title,
          'description' : product.description,
          'price' : product.price,
          'imageUrl' : product.imageUrl,
          'creatorId' : userId,
        }
    )).then((response) {
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    }).catchError((error) {
      throw error;
    });
  }

  Future<void> updateProducts(String id, Product updatedProduct) async {
    final idx = _items.indexWhere((element) => element.id == id);
    if(idx >= 0) {
      final url = 'https://shop-app-cc4e8-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
      try {
        await http.patch(url, body: json.encode({
                'title' : updatedProduct.title,
                'description' : updatedProduct.description,
                'price' : updatedProduct.price,
                'imageUrl' : updatedProduct.imageUrl,
              }));
        _items[idx] = updatedProduct;
        notifyListeners();
      } catch (e) {
        throw e;
      }
    }else{
      print('Can\'t find index!!');
    }
  }


  Future<void> deleteProducts(String id) async {
    final url = 'https://shop-app-cc4e8-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
    final index = _items.indexWhere((element) => element.id == id);
    var existingProduct = _items[index];
    _items.removeAt(index);
    notifyListeners();
    final response = await http.delete(url);
    if(response.statusCode >= 400) {
      _items.insert(index, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }
}
