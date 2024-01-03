import 'package:flutter/material.dart';
import 'package:e_commerce/model/product.dart';
import 'package:e_commerce/screens/cartScreen.dart';
import 'package:e_commerce/screens/productCard.dart';
import 'package:e_commerce/blocs/cart_bloc/cart_bloc.dart';
import 'package:e_commerce/blocs/cart_bloc/cart_event.dart';
import 'package:e_commerce/blocs/cart_bloc/cart_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce/model/shop.dart';

class ShopDetailScreen extends StatefulWidget {
  final Shop shop;

  const ShopDetailScreen({required this.shop});

  @override
  _ShopDetailScreenState createState() => _ShopDetailScreenState();
}

class _ShopDetailScreenState extends State<ShopDetailScreen> {
  void addToCart(Product product, int quantity) {
    // Access the cart bloc using BlocProvider
    context.read<CartBloc>().add(AddToCartEvent(product, quantity));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shop Details"),
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            List<Product> cart = (state as CartLoadedState).cart;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 3,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.shop.photo),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.shop.name,
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      SizedBox(height: 8),
                      Text(
                        widget.shop.description,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Products',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      SizedBox(height: 10),
                      Column(
                        children: widget.shop.products.map((product) {
                          return ProductCard(
                            product: product,
                            onAddToCart: (product, quantity) {
                              addToCart(product, quantity);
                            },
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CartScreen(cart: cart),
                            ),
                          );
                        },
                        child: Text('View Cart'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
