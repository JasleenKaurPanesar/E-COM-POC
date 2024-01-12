import 'package:e_commerce/blocs/cart_bloc/cart_bloc.dart';
import 'package:e_commerce/blocs/cart_bloc/cart_event.dart';
import 'package:e_commerce/blocs/cart_bloc/cart_state.dart';
import 'package:e_commerce/blocs/shops_bloc/shops_bloc.dart';
import 'package:e_commerce/blocs/shops_bloc/shops_event.dart';
import 'package:e_commerce/model/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce/screens/order_booked_screen.dart';

class BookOrderScreen extends StatelessWidget {
  final List<Product> selectedProducts;

  const BookOrderScreen({required this.selectedProducts});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        // Handle changes in the CartBloc state
        if (state is CartLoadedState) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Book Order'),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Selected Products',
                    style: Theme.of(context).textTheme.headline5,
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
                          // Use CartBloc to remove the item from the cart
                          context.read<CartBloc>().add(RemoveFromCartEvent(product));
                        },
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 16.0),
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        child: ListTile(
                          title: Text(product.name),
                          subtitle: Text('Price: \$${product.price.toString()}'),
                          trailing: Text('Qty: ${product.quantity.toString()}'),
                         
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
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Total Order Value: \$${calculateTotalOrderValue(state)}',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                // Book the order using CartBloc
                context.read<CartBloc>().add(BookOrderEvent());
              // Navigate to the Order Booked screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderBookedScreen(),
                  )
                );
              },
              child: Icon(Icons.book),
            ),
          );
        } else {
          return CircularProgressIndicator(); 
        }
      },
    );
  }

  int calculateTotalQuantity(CartLoadedState state) {
    int totalQuantity = 0;
    for (var product in state.cart) {
      totalQuantity += product.quantity;
    }
    return totalQuantity;
  }

  double calculateTotalOrderValue(CartLoadedState state) {
    double totalOrderValue = 0.0;
    for (var product in state.cart) {
      totalOrderValue += (product.price * product.quantity);
    }
    return totalOrderValue;
  }
}
