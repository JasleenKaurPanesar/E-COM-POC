import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:e_commerce/model/product.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  List<Product> _cart = [];

  @override
  CartState get initialState => CartInitial();

  @override
  Stream<CartState> mapEventToState(CartEvent event) async* {
    if (event is AddToCart) {
      _cart.add(event.product);
      yield CartUpdated(cart: _cart);
    } else if (event is RemoveFromCart) {
      _cart.remove(event.product);
      yield CartUpdated(cart: _cart);
    } else if (event is BookOrder) {
      // Implement order booking logic here
      // Clear the cart after booking the order
      _cart.clear();
      yield CartUpdated(cart: _cart);
    }
  }

  List<Product> get cart => _cart;
}

abstract class CartEvent {}

class AddToCart extends CartEvent {
  final Product product;
  final int quantity;

  AddToCart({required this.product, required this.quantity});
}

class RemoveFromCart extends CartEvent {
  final Product product;

  RemoveFromCart({required this.product});
}

class BookOrder extends CartEvent {}

abstract class CartState {}

class CartInitial extends CartState {}

class CartUpdated extends CartState {
  final List<Product> cart;

  CartUpdated({required this.cart});
}
