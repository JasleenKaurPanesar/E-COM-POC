import 'package:bloc/bloc.dart';
import 'package:e_commerce/model/shop.dart';
import 'package:geolocator/geolocator.dart';
import 'shops_event.dart';
import 'shops_state.dart';
import 'ShopService.dart';
import 'shops.dart';
import 'dart:async';

class ShopsBloc extends Bloc<ShopsEvent, ShopsState> {
  final _reloadController = StreamController<void>();

  ShopsBloc() : super(ShopsLoading()) {
    on<LoadShops>(_mapLoadShopsToState);
    on<FilterShops>(_mapFilterShopsToState);
  }

  // Stream for reloading shops
  Stream<void> get reloadStream => _reloadController.stream;

  // Function to trigger a reload
  void reloadShops() {
    _reloadController.add(null);
  }

  void dispose() {
    _reloadController.close();
  }

  Future<void> _mapLoadShopsToState(LoadShops event, Emitter<ShopsState> emit) async {
    try {
      List<Shop> shops = await ShopService.getAllShops();
      emit(ShopsLoaded(shops: shops));
    } catch (e) {
      emit(ShopsError(error: 'Error loading shops'));
    }
  }

  Future<void> _mapFilterShopsToState(FilterShops event, Emitter<ShopsState> emit) async {
    try {
      List<Shop> shops = await ShopService.getShopsInRadius(
        (state as ShopsLoaded).shops,
        event.userLocation,
        event.selectedRadius,
      );
      emit(ShopsLoaded(shops: shops));
    } catch (e) {
      emit(ShopsError(error: 'Error filtering shops'));
    }
  }
}
