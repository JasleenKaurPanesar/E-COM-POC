import 'package:e_commerce/model/shop.dart';
import 'package:e_commerce/blocs/shops_bloc/shops.dart';  
import 'package:geolocator/geolocator.dart';


class ShopService {
  static Future<List<Shop>> getAllShops() async {
    try {
      List<Shop> shops = await ShopList.getShops();
      return shops;
    } catch (e) {
      print("Error getting shops: $e");
      return [];
    }
  }

  static List<Shop> getShopsInRadius(List<Shop> shops, Position userLocation, double selectedRadius) {
  if (shops.isEmpty) {
    print('Shops list is empty.');
    return [];
  }

  List<Shop> nearbyShops =  shops.where((shop) {
    double distance = Geolocator.distanceBetween(
      userLocation.latitude,
      userLocation.longitude,
      shop.latitude,
      shop.longitude,
    );
   
    return distance / 1000 <= selectedRadius; // Convert to kilometers
  }).toList();

  if (nearbyShops.isNotEmpty) {
    print("location ${nearbyShops[0].name}");
  }

  return nearbyShops;
}

}
