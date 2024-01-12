import 'package:e_commerce/blocs/cart_bloc/cart_bloc.dart';
import 'package:e_commerce/blocs/cart_bloc/cart_event.dart';
import 'package:e_commerce/blocs/cart_bloc/cart_state.dart';
import 'package:e_commerce/model/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce/screens/end_user/order_booked_screen.dart';

class BookOrderScreen extends StatelessWidget {
  final List<Product> selectedProducts;

  const BookOrderScreen({required this.selectedProducts});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state is CartLoadedState) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('View Cart'),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Selected Products',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.cart.length,
                    itemBuilder: (context, index) {
                      final product = state.cart[index];
                      return Dismissible(
                        key: UniqueKey(),
                        onDismissed: (direction) {
                          context.read<CartBloc>().add(RemoveFromCartEvent(product));
                        },
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 16.0),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        child: Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          child: ListTile(
                            title: Text(product.name),
                            subtitle: Text('Price: \$${product.price.toString()}'),
                            trailing: Text('Qty: ${product.quantity.toString()}'),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Items Quantity: ${calculateTotalQuantity(state)}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Total Order Value: \$${calculateTotalOrderValue(state)}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                context.read<CartBloc>().add(BookOrderEvent());
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderBookedScreen(),
                  ),
                );
              },
              child: const Icon(Icons.book),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  int calculateTotalQuantity(CartLoadedState state) {
    return state.cart.fold(0, (int total, Product product) => total + product.quantity);
  }

  double calculateTotalOrderValue(CartLoadedState state) {
    return state.cart.fold(0.0, (double total, Product product) => total + (product.price * product.quantity));
  }
}
