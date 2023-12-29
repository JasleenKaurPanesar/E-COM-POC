import 'package:flutter/foundation.dart';
import 'package:e_commerce/model/product.dart';
import 'package:e_commerce/model/shop.dart';
import 'package:e_commerce/providers/shopsProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartProvider extends ChangeNotifier {
  List<Product> _cart = [];
  late List<Shop> _dummyShops=[];
  late ShopProvider _shopProvider;

  CartProvider(ShopProvider shopProvider) {
    _dummyShops = shopProvider.shops;
    _shopProvider = shopProvider;
    print("shopers ${ _dummyShops.length}");
  }



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

  Future<void> updateProductQuantity(
      String shopName, String productName, int newQuantity) async {
    try {
      // Reference to the document in the 'shops' collection
      DocumentReference shopDocument =
          FirebaseFirestore.instance.collection('shops').doc(shopName);

      // Get the current data of the shop
      DocumentSnapshot shopSnapshot = await shopDocument.get();
      Map<String, dynamic> shopData =
          shopSnapshot.data() as Map<String, dynamic>;

      // Find the product index in the 'products' array
      int productIndex = shopData['products']
          .indexWhere((product) => product['name'] == productName);

      if (productIndex != -1) {
        int currentQuantity =
            shopData['products'][productIndex]['quantity'];
        print("current ${currentQuantity}");
        // Ensure currentQuantity is greater than or equal to newQuantity before updating
        if (currentQuantity >= newQuantity) {
          // Subtract the new quantity from the current quantity
          shopData['products'][productIndex]['quantity'] =
              currentQuantity - newQuantity;
          // Update the document in Firestore
          await shopDocument.update(shopData);
          notifyListeners(); // Notify listeners after updating quantity
          print('Quantity updated successfully.');
        } else {
          print('Insufficient quantity available.');
        }
      } else {
        print('Product not found in the shop.');
      }
    } catch (e) {
      print('Error updating quantity: $e');
    }
  }

  Future<void> bookOrder() async {
    // Deduct the booked quantities from the corresponding shop's product list
    for (var cartProduct in _cart) {
      for (var shop in _dummyShops) {
        var productIndex = shop.products
            .indexWhere((shopProduct) => shopProduct.name == cartProduct.name);
        if (productIndex != -1) {
          // Deduct the quantity in the local model
          shop.products[productIndex].quantity -= cartProduct.quantity;

          // Update Firestore document
          await updateProductQuantity(
            shop.name.toLowerCase().replaceAll(' ', ''),
            shop.products[productIndex].name,
            cartProduct.quantity,
          );
        }
      }
    }

    // Clear the cart after booking the order
    _cart.clear();
    notifyListeners();
  }
}
