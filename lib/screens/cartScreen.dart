import 'package:e_commerce/model/product.dart';
import 'package:e_commerce/providers/cartProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
   final List<Product> cart;
  const CartScreen({Key? key, required this.cart}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // Access the CartProvider using Provider.of
    CartProvider cartProvider = Provider.of<CartProvider>(context, listen: false);

    // Now you can use cartProvider.cart to get the cart list

    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          List<Product> cart = cartProvider.cart;

          return ListView.builder(
            itemCount: cart.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(cart[index].photo),
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
                    // Use CartProvider to remove the item from the cart
                    cartProvider.removeFromCart(cart[index]);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Assuming you have a function in CartProvider to handle booking the order
          cartProvider.bookOrder();

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
