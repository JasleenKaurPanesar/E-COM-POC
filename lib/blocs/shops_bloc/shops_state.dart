import 'package:equatable/equatable.dart';
import 'package:e_commerce/model/shop.dart';
abstract class ShopsState extends Equatable {
  const ShopsState();
}

class ShopsLoading extends ShopsState {
  @override
  List<Object> get props => [];
}

class ShopsLoaded extends ShopsState {
  final List<Shop> shops;

  ShopsLoaded({required this.shops});

  @override
  List<Object> get props => [shops];
}

class ShopsError extends ShopsState {
  final String error;

  ShopsError({required this.error});

  @override
  List<Object> get props => [error];
}