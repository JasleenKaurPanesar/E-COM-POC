import 'package:e_commerce/model/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShoppingCart {
  Map<Product, int> items = {};

  void addToCart(Product product, int quantity) {
    items.update(
      product,
      (existingQuantity) => existingQuantity + quantity,
      ifAbsent: () => quantity,
    );
  }

  void removeFromCart(Product product, int quantity) {
    items.update(
      product,
      (existingQuantity) => (existingQuantity - quantity).clamp(0, existingQuantity),
      ifAbsent: () => 0,
    );

    if (items[product] == 0) {
      items.remove(product);
    }
  }

  Future<void> updateProductQuantity(String shopName, String productName, int newQuantity) async {
    try {
      DocumentReference shopDocument = FirebaseFirestore.instance.collection('shops').doc(shopName);

      DocumentSnapshot shopSnapshot = await shopDocument.get();
      Map<String, dynamic> shopData = shopSnapshot.data() as Map<String, dynamic>;

      int productIndex =
          shopData['products'].indexWhere((product) => product['name'] == productName);

      if (productIndex != -1) {
        int currentQuantity = shopData['products'][productIndex]['quantity'];

        if (currentQuantity >= newQuantity) {
          shopData['products'][productIndex]['quantity'] = currentQuantity - newQuantity;
          await shopDocument.update(shopData);
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

  Future<void> bookOrder(List<Product> cart, List<Product> dummyShops) async {
    for (var cartProduct in cart) {
      for (var shopProduct in dummyShops) {
        if (shopProduct.name == cartProduct.name) {
          shopProduct.quantity -= cartProduct.quantity;
          await updateProductQuantity(
            shopProduct.shopName.toLowerCase().replaceAll(' ', ''),
            shopProduct.name,
            cartProduct.quantity,
          );
        }
      }
    }

    cart.clear();
  }
}
