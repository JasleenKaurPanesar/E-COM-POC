import 'package:flutter/foundation.dart';
import 'package:e_commerce/model/shop.dart';
import 'package:e_commerce/model/shopService.dart';
import 'package:geolocator/geolocator.dart';

class ShopProvider extends ChangeNotifier {
  List<Shop> _shops = [];

  Future<void> initializeShops() async {
    try {
      _shops = await ShopService.getAllShops();
      print('Shops loaded successfully: ${_shops.length} shops');
      notifyListeners();
    } catch (e) {
      print('Error loading shops: $e');
    }
  }

  List<Shop> get shops => _shops;

  Shop getShop(String shopName) {
    return _shops.firstWhere((shop) => shop.name == shopName);
  }

  List<Shop> getShopsInRadius(Position userLocation, double selectedRadius) {
  
    if (_shops.isEmpty) {
      print('Shops list is empty.');
      return [];
    }
   var x=_shops.where((shop) {
      double distance = Geolocator.distanceBetween(
        userLocation.latitude,
        userLocation.longitude,
        shop.latitude,
        shop.longitude,
      );

      return distance / 1000 <= selectedRadius; // Convert to kilometers
    }).toList();
      print("location ${x[0].name}");
    return _shops.where((shop) {
      double distance = Geolocator.distanceBetween(
        userLocation.latitude,
        userLocation.longitude,
        shop.latitude,
        shop.longitude,
      );

      return distance / 1000 <= selectedRadius; // Convert to kilometers
    }).toList();
  }
}
