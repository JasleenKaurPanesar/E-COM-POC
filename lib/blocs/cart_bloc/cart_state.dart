import 'package:e_commerce/model/product.dart';
import 'package:equatable/equatable.dart';

abstract class CartState extends Equatable {
  const CartState();
}

class CartLoadedState extends CartState {
  final List<Product> cart;

  const CartLoadedState(this.cart);

  @override
  List<Object> get props => [cart];
}

