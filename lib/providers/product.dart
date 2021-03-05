import 'dart:convert';
import '../utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void _toggFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  Future<void> toggFavorite(String token, String userId) async {
    _toggFavorite();
    try {
      final url =
          '${Constants.BASE_API_URL}/userFavorites/$userId/$id.json?auth=$token';

      final response = await http.put(
        url,
        body: jsonEncode(isFavorite),
      );

      if (response.statusCode >= 400) {
        _toggFavorite();
      }
    } catch (error) {
      _toggFavorite();
    }
  }
}
