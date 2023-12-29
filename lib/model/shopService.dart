import 'package:e_commerce/model/shop.dart';
import 'package:e_commerce/model/shops.dart';
class ShopService {
  static Future<List<Shop>> getAllShops() async {
    try {
      // Call the existing function to get the list of shops
      List<Shop> shops = await ShopList.getShops();

      // You can further process the list if needed

      return shops;
    } catch (e) {
      print("Error getting shops: $e");
      return [];
    }
  }
}