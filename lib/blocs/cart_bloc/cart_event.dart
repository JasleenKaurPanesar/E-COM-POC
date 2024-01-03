import 'package:e_commerce/model/product.dart';
import 'package:equatable/equatable.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();
}

class AddToCartEvent extends CartEvent {
  final Product product;
  final int quantity;

  const AddToCartEvent(this.product, this.quantity);

  @override
  List<Object> get props => [product, quantity];
}

class RemoveFromCartEvent extends CartEvent {
  final Product product;

  const RemoveFromCartEvent(this.product);

  @override
  List<Object> get props => [product];
}

class BookOrderEvent extends CartEvent {
  @override
  List<Object> get props => [];
}

