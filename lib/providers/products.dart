import 'dart:convert';
import '../utils/constants.dart';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/http_exceptions.dart';
import './product.dart';

class Products with ChangeNotifier {
  final _baseUrl = '${Constants.BASE_API_URL}/products';
  List<Product> _items = [];
  String _token;
  String _userId;

  Products([this._token, this._userId, this._items = const []]);

  List<Product> get items => [..._items];

  int get itensCount {
    return _items.length;
  }

  List<Product> get favoriteItems {
    return [..._items].where((prod) => prod.isFavorite).toList();
  }

  Future<void> loadProducts() async {
    final response = await http.get('$_baseUrl.json?auth=$_token');
    Map<String, dynamic> data = jsonDecode(response.body);

    final favResponse = await http.get(
        '${Constants.BASE_API_URL}/userFavorites/$_userId.json?auth=$_token');
    final favMap = jsonDecode(favResponse.body);

    _items.clear();
    if (data != null) {
      data.forEach((productId, productData) {
        final isFavorite = favMap == null ? false : favMap[productId] ?? false;

        _items.add(Product(
          id: productId,
          title: productData['title'],
          price: productData['price'],
          description: productData['description'],
          imageUrl: productData['imageUrl'],
          isFavorite: isFavorite,
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
    });

    return http
        .post(
      '$_baseUrl.json?auth=$_token',
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
        '$_baseUrl/${product.id}.json?auth=$_token',
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

  Future<void> deleteProduct(String id) async {
    final index = _items.indexWhere((prod) => prod.id == id);
    if (index >= 0) {
      final product = _items[index];
      _items.remove(product);
      notifyListeners();

      final response =
          await http.delete('$_baseUrl/${product.id}.json?auth=$_token');

      if (response.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();
        throw HttpExceptions('Ocorreu um erro na exclusão do produto');
      }
    }
  }
}
