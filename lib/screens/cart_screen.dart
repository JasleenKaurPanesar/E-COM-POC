import 'package:e_commerce/model/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce/blocs/cart_bloc/cart_bloc.dart';
import 'package:e_commerce/blocs/cart_bloc/cart_event.dart';
import 'package:e_commerce/blocs/cart_bloc/cart_state.dart';

class CartScreen extends StatelessWidget {
  final List<Product> cart;

  final String shopName;


  const CartScreen({Key? key, required this.cart,required this.shopName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          List<Product> cart = (state as CartLoadedState).cart;

          return ListView.builder(
            itemCount: cart.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(cart[index].photo),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(cart[index].name),
                    Text('Quantity: ${cart[index].quantity}'),
                  ],
                ),
                subtitle: Text('\$${cart[index].price.toStringAsFixed(2)}'),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // Use CartBloc to remove the item from the cart
                    context.read<CartBloc>().add(RemoveFromCartEvent(cart[index]));
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Assuming you have a function in CartBloc to handle booking the order
          context.read<CartBloc>().add(BookOrderEvent());

          // Navigate to the Order Booked screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderBookedScreen(),
            ),
          );
        },
        child: Icon(Icons.book),
      ),
    );
  }
}

class OrderBookedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Booked"),
      ),
      body: Center(
        child: Text("Your order has been booked!"),
      ),
    );
  }
}
