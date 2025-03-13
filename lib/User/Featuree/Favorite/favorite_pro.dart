import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Product/product_models.dart';

class FavoriteProvider extends ChangeNotifier {
  final List<Product> _favorites = [];

  // Phương thức để lấy danh sách yêu thích
  List<Product> getFavorites() => _favorites;


  void toggleFavorite(Product product) {
    if (_favorites.contains(product)) {
      _favorites.remove(product);
    } else {
      _favorites.add(product);
    }
    notifyListeners();
  }
  bool isExist(Product product) {
    return _favorites.contains(product);
  }
  static FavoriteProvider of(BuildContext context, {bool listen = true}) {
    return Provider.of<FavoriteProvider>(context, listen: listen);
  }
}