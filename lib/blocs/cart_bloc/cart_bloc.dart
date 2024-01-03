import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:e_commerce/model/product.dart';
import 'package:e_commerce/blocs/cart_bloc/cart_event.dart';
import 'package:e_commerce/blocs/cart_bloc/cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  List<Product> _cart = [];
  
  CartBloc() : super(CartLoadedState([])) {
    on<AddToCartEvent>(_addToCart);
    on<RemoveFromCartEvent>(_removeFromCart);
    on<BookOrderEvent>(_bookOrder);
  }

  void _addToCart(AddToCartEvent event, Emitter<CartState> emit) {
    _cart.add(Product(
      name: event.product.name,
      price: event.product.price,
      quantity: event.quantity,
      photo: event.product.photo,
      description: event.product.description,
    ));

    emit(CartLoadedState(List.from(_cart)));
  }

  void _removeFromCart(RemoveFromCartEvent event, Emitter<CartState> emit) {
    _cart.remove(event.product);

    emit(CartLoadedState(List.from(_cart)));
  }

  void _bookOrder(BookOrderEvent event, Emitter<CartState> emit) {
    // Handle booking order logic here
    _cart.clear();

    emit(CartLoadedState(List.from(_cart)));
  }
}
