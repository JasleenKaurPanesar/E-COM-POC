import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';
import 'package:e_commerce/model/shop.dart';
import 'package:e_commerce/model/product.dart';
import 'package:e_commerce/model/shop.dart';
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
class AddProductEvent extends ShopsEvent {
  final String shopId;
  final String uid;
  final Product newProduct;

  AddProductEvent({
    required this.shopId,
    required this.uid,
    required this.newProduct,
  });

  @override
  List<Object> get props => [shopId, uid, newProduct];
}
//Update ProductEvent
class UpdateProductEvent extends ShopsEvent {
  final String shopId;
  final String uid;
  final String name;
  final int newQuantity;
  final double newPrice;

  const UpdateProductEvent({
    required this.shopId,
    required this.uid,
    required this.name,
    required this.newQuantity,
    required this.newPrice,
  });

  @override
  List<Object?> get props => [shopId, uid, name, newQuantity,newPrice];
}
class UpdateProductIsShownEvent extends ShopsEvent {
  final String shopId;
  final String uid;
  final String name;
  final bool isShown;

  const UpdateProductIsShownEvent({
    required this.shopId,
    required this.uid,
    required this.name,
    required this.isShown,
  });

  @override
  List<Object> get props => [shopId, uid, name, isShown];
}