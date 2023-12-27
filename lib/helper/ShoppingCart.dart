import 'package:flutter/material.dart';
import 'package:e_commerce/model/product.dart';

class ShoppingCart {
  Map<Product, int> items = {};

  void addToCart(Product product, int quantity) {
    if (items.containsKey(product)) {
      items[product]= items[product]+ quantity;
    } else {
      items[product] = quantity;
    }
  }

  void removeFromCart(Product product, int quantity) {
    if (items.containsKey(product)) {
      items[product] = (items[product]! - quantity).clamp(0, items[product]!);
      if (items[product] == 0) {
        items.remove(product);
      }
    }
  }
}
