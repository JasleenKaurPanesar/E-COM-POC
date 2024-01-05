import 'package:equatable/equatable.dart';
import 'package:e_commerce/model/shop.dart';

abstract class ShopsState extends Equatable {
  const ShopsState();
}

class CreateShopLoading extends ShopsState {
  @override
  List<Object?> get props => [];
}


class CreateShopSuccess extends ShopsState {
  @override
  List<Object?> get props => [];
}

class CreateShopFailure extends ShopsState {
  final String error;

  CreateShopFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class ShopsLoading extends ShopsState {
  @override
  List<Object?> get props => [];
}

class ShopsLoaded extends ShopsState {
  final List<Shop> shops;

  ShopsLoaded({required this.shops});

  @override
  List<Object?> get props => [shops];
}

class ShopsError extends ShopsState {
  final String error;

  ShopsError({required this.error});

  @override
  List<Object?> get props => [error];
}
class UserShopsLoaded extends ShopsState {
  final List<Shop> userShops; // Change the type to List<Shop>

  UserShopsLoaded({required this.userShops});

  @override
  List<Object?> get props => [userShops];
}
class UserShopsError extends ShopsState {
  final String error;

  UserShopsError({required this.error});

  @override
  List<Object?> get props => [error];
}


// class AddProductSuccess extends ShopsState {
//   final List<Shop> updatedShops;

//   AddProductSuccess({required this.updatedShops});

//   @override
//   List<Object> get props => [updatedShops];
// }