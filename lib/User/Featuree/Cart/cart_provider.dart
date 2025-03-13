import 'package:flutter/material.dart';
import '../Product/product_models.dart';
class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  double get totalPrice {
    double total = 0;
    for (var item in _cartItems) {
      total += item.product.price * item.quantity;
    }
    return total;
  }

  void addItem(Product product) {
    final existingItem = _cartItems.firstWhere(
          (item) => item.product == product,
      orElse: () => CartItem(product: product, quantity: 0),
    );

    if (existingItem.quantity == 0) {
      _cartItems.add(CartItem(product: product));
    } else {
      existingItem.quantity++;
    }
    notifyListeners();
  }

  void removeItem(Product product) {
    _cartItems.removeWhere((item) => item.product == product);
    notifyListeners();
  }

  void increaseQuantity(Product product) {
    final existingItem = _cartItems.firstWhere(
          (item) => item.product == product,
      orElse: () => CartItem(product: product, quantity: 0),
    );
    existingItem.quantity++;
    notifyListeners();
  }

  void decreaseQuantity(Product product) {
    final existingItem = _cartItems.firstWhere(
          (item) => item.product == product,
      orElse: () => CartItem(product: product, quantity: 0),
    );
    if (existingItem.quantity > 1) {
      existingItem.quantity--;
    } else {
      _cartItems.removeWhere((item) => item.product == product);
    }
    notifyListeners();
  }
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}