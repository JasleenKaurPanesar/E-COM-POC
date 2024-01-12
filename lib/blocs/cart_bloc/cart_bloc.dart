import 'package:bloc/bloc.dart';
import 'package:e_commerce/blocs/shops_bloc/shops_event.dart';
import 'package:e_commerce/model/product.dart';
import 'package:e_commerce/blocs/cart_bloc/cart_event.dart';
import 'package:e_commerce/blocs/cart_bloc/cart_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/blocs/shops_bloc/shops_bloc.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final List<Product> _cart = [];
  String shopName = '';
  final ShopsBloc shopsBloc;

  CartBloc({required this.shopsBloc}) : super(const CartLoadedState([])) {
    on<AddToCartEvent>(_addToCart);
    on<RemoveFromCartEvent>(_removeFromCart);
    on<BookOrderEvent>(_bookOrder);
  }

  void _addToCart(AddToCartEvent event, Emitter<CartState> emit) {
    // Check if the product is already in the cart
    bool productExists = _cart.any((product) => product.name == event.product.name);

    if (productExists) {
      // If the product exists, find it and update the quantity
      int existingIndex = _cart.indexWhere((product) => product.name == event.product.name);
      _cart[existingIndex].quantity = event.quantity;
    } else {
      // If the product is not in the cart, add it
      _cart.add(Product(
        name: event.product.name,
        price: event.product.price,
        quantity: event.quantity,
        photo: event.product.photo,
        description: event.product.description,
        shopName: event.product.shopName,
      ));
    }

    emit(CartLoadedState(List.from(_cart)));
  }

  void _removeFromCart(RemoveFromCartEvent event, Emitter<CartState> emit) {
    _cart.remove(event.product);

    emit(CartLoadedState(List.from(_cart)));
  }

  Future<void> _updateProductQuantity(String shopName, String productName, int newQuantity) async {

    try {
      DocumentReference shopDocument =
          FirebaseFirestore.instance.collection('shops').doc(shopName.replaceAll(' ', ''));

      DocumentSnapshot shopSnapshot = await shopDocument.get();
      Map<String, dynamic> shopData = shopSnapshot.data() as Map<String, dynamic>;

      int productIndex =
          shopData['products'].indexWhere((product) => product['name'] == productName);

      if (productIndex != -1) {
        int currentQuantity = shopData['products'][productIndex]['quantity'];

        if (currentQuantity >= newQuantity) {
          shopData['products'][productIndex]['quantity'] = currentQuantity - newQuantity;
          await shopDocument.update(shopData);
    
          shopsBloc.add(LoadShops());
        } else {
          print('Insufficient quantity available.');
        }
      } else {
        print('Product not found in the shop.');
      }
    } catch (e) {
      print('Error updating quantity: $e');
    }
  }

  void _bookOrder(BookOrderEvent event, Emitter<CartState> emit) async {
    // Handle booking order logic here
    for (var cartProduct in _cart) {
      // Update the quantity in the local model
      await _updateProductQuantity(cartProduct.shopName, cartProduct.name, cartProduct.quantity);
    }

    // Clear the cart after booking order
    _cart.clear();

    emit(CartLoadedState(List.from(_cart)));
  }
}
