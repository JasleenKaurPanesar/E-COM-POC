import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';
import 'package:e_commerce/model/shop.dart';
import 'package:e_commerce/model/product.dart';
// Events
abstract class ShopsEvent extends Equatable {
  const ShopsEvent();
}
// Add a new event for creating a shop
class CreateShop extends ShopsEvent {
  final Shop newShop;
  final String uid; // Add UID parameter

  const CreateShop({required this.newShop, required this.uid});

  @override
  List<Object> get props => [newShop, uid];
}



class LoadShops extends ShopsEvent {
  @override
  List<Object> get props => [];
}

class FilterShops extends ShopsEvent {
  final Position userLocation;
  final double selectedRadius;

  FilterShops({required this.userLocation, required this.selectedRadius});

  @override
  List<Object> get props => [userLocation, selectedRadius];
}
// Add a new event for fetching user shops
class FetchUserShops extends ShopsEvent {
  final String uid;

  FetchUserShops({required this.uid});

  @override
  List<Object> get props => [uid];
}
//ProductEvent
// class AddProductEvent extends Equatable {
//   final String shopId;
//   final String uid; // Add this property
//   final Product newProduct;

//   AddProductEvent({
//     required this.shopId,
//     required this.uid,
//     required this.newProduct,
//   });

//   @override
//   List<Object?> get props => [shopId, uid, newProduct];
// }