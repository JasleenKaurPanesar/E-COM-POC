import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:e_commerce/model/shop.dart';
import 'package:e_commerce/model/shopService.dart';
import 'package:geolocator/geolocator.dart';

part 'shop_event.dart';
part 'shop_state.dart';

class ShopBloc extends Bloc<ShopEvent, ShopState> {
  List<Shop> _shops = [];

  @override
  ShopState get initialState => ShopInitial();

  @override
  Stream<ShopState> mapEventToState(ShopEvent event) async* {
    if (event is LoadShops) {
      yield* _mapLoadShopsToState();
    }
  }

  Stream<ShopState> _mapLoadShopsToState() async* {
    try {
      _shops = await ShopService.getAllShops();
      yield ShopsLoaded(shops: _shops);
    } catch (e) {
      yield ShopsError(error: 'Error loading shops: $e');
    }
  }

  List<Shop> get shops => _shops;
}

abstract class ShopEvent {}

class LoadShops extends ShopEvent {}

abstract class ShopState {}

class ShopInitial extends ShopState {}

class ShopsLoaded extends ShopState {
  final List<Shop> shops;

  ShopsLoaded({required this.shops});
}

class ShopsError extends ShopState {
  final String error;

  ShopsError({required this.error});
}
