import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import './product.dart';

class Products with ChangeNotifier {
  final _baseUrl =
      'https://flutter-cod3r-6cd74-default-rtdb.firebaseio.com/products';
  List<Product> _items = [];

  List<Product> get items => [..._items];

  int get itensCount {
    return _items.length;
  }

  List<Product> get favoriteItems {
    return [..._items].where((prod) => prod.isFavorite).toList();
  }

  Future<void> loadProducts() async {
    final response = await http.get('$_baseUrl.json');
    Map<String, dynamic> data = jsonDecode(response.body);

    _items.clear();

    if (data != null) {
      data.forEach((productId, productData) {
        _items.add(Product(
          id: productId,
          title: productData['title'],
          price: productData['price'],
          description: productData['description'],
          imageUrl: productData['imageUrl'],
          isFavorite: productData['isFavorite'],
        ));
      });
      notifyListeners();
    }
    return Future.value();
  }

  Future<void> addProduct(Product newProduct) {
    final addJson = jsonEncode({
      "title": newProduct.title,
      "description": newProduct.description,
      "price": newProduct.price,
      "imageUrl": newProduct.imageUrl,
      "isFavorite": newProduct.isFavorite,
    });

    return http
        .post(
      '$_baseUrl.json',
      body: addJson,
    )
        .then((response) {
      _items.add(Product(
        id: jsonDecode(response.body)['name'],
        title: newProduct.title,
        price: newProduct.price,
        description: newProduct.description,
        imageUrl: newProduct.imageUrl,
      ));
      notifyListeners();
    }).catchError((error) {
      throw error;
    });
  }

  Future<void> upDateProduct(Product product) async {
    if (product == null || product.id == null) {
      return;
    }

    final index = _items.indexWhere((prod) => prod.id == product.id);
    if (index >= 0) {
      await http.patch(
        '$_baseUrl/${product.id}.json',
        body: jsonEncode({
          "title": product.title,
          "description": product.description,
          "price": product.price,
          "imageUrl": product.imageUrl,
        }),
      );
      _items[index] = product;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    final index = _items.indexWhere((prod) => prod.id == id);
    if (index >= 0) {
      _items.removeWhere((prod) => prod.id == id);
      notifyListeners();
    }
  }
}

// List<Product> get items {
//     if (_showFavoriteOnly) {
//       return [..._items].where((prod) => prod.isFavorite).toList();
//     }
//     return [..._items];
//   }

//   bool _showFavoriteOnly = false;
//   void showFavoriteOnly() {
//     _showFavoriteOnly = true;
//     notifyListeners();
//   }

//   void showAll() {
//     _showFavoriteOnly = false;
//     notifyListeners();
//   }
