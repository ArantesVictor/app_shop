import 'package:flutter/cupertino.dart';
import './product.dart';
import '../data/dummy_data.dart';

class Products with ChangeNotifier {
  List<Product> _items = DUMMY_PRODUCTS;

  List<Product> get items => [..._items];
  List<Product> get favoriteItems {
    return [..._items].where((prod) => prod.isFavorite).toList();
  }

  void addProduct(Product product) {
    _items.add(product);
    notifyListeners();
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
