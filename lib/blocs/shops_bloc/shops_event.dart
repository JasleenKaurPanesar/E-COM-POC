import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';
import 'package:e_commerce/model/shop.dart';
// Events
abstract class ShopsEvent extends Equatable {
  const ShopsEvent();
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