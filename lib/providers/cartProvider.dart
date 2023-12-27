import 'package:flutter/material.dart';
import 'package:e_commerce/model/product.dart';
import 'package:e_commerce/model/dummydata.dart';

class CartProvider extends ChangeNotifier {
  List<Product> _cart = [];
  List _dummyShops =  DummyShopList.getShops();

  List<Product> get cart => _cart;

  void addToCart(Product product, int quantity) {
    _cart.add(Product(
      name: product.name,
      price: product.price,
      quantity: quantity,
      photo: product.photo,
      description: product.description,
    ));
    notifyListeners();
  }

  void removeFromCart(Product product) {
    _cart.remove(product);
    notifyListeners();
  }

  void bookOrder() {
    // Deduct the booked quantities from the corresponding shop's product list
    for (var cartProduct in _cart) {
      for (var shop in _dummyShops) {
        var productIndex = shop.products.indexWhere((shopProduct) => shopProduct.name == cartProduct.name);
        if (productIndex != -1) {
          shop.products[productIndex].quantity -= cartProduct.quantity;
        }
      }
    }

    // Clear the cart after booking the order
    _cart.clear();
    notifyListeners();
  }
  

  // Add other cart management methods as needed
}
