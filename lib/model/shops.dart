import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/model/product.dart';
import 'package:e_commerce/model/shop.dart';

class ShopList {
  static Future<List<Shop>> getShops() async {
    try {
      CollectionReference _referenceShoppingList =
          FirebaseFirestore.instance.collection('shops');

      QuerySnapshot snapshot = await _referenceShoppingList.get();

      if (snapshot.docs.isEmpty) {
        // If there are no documents in the collection, return an empty list
        return [];
      }

      List<Shop> shops = snapshot.docs.map((shopDoc) {
        Map<String, dynamic> shopData = shopDoc.data() as Map<String, dynamic>;

        // Ensure that the 'products' field is a list
        List<dynamic>? productsData = shopData['products'];

        // Check if productsData is a list
        List<Product> products = (productsData is List)
            ? productsData.map((productData) => Product.fromMap(productData)).toList()
            : [];

        return Shop(
          name: shopData['name'],
          photo: shopData['photo'],
          description: shopData['description'],
          address: shopData['address'],
          latitude: shopData['latitude'],
          longitude: shopData['longitude'],
          owner: shopData['owner'],
          products: products,
        );
      }).toList();
     print('Shop Detailsdummy: ${shops[0].name}, ${shops[0].address}, ${shops[0].latitude}, ${shops[0].longitude}');

      return shops;
    } catch (e) {
      print("Error fetching data from Firestore: $e");
      return [];
    }
  }
}


