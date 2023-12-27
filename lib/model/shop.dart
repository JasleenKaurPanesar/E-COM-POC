import 'package:e_commerce/model/product.dart';

class Shop {
  String name;
  String photo;
  String description;
  String address;
  double latitude;
  double longitude;
  String owner;
  List<Product> products;

  Shop({
    required this.name,
    required this.photo,
    required this.description,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.owner,
    required this.products,
  });
}
