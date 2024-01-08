import 'package:flutter/material.dart';
import 'package:e_commerce/model/product.dart';
import 'package:e_commerce/screens/cart_screen.dart';
import 'package:e_commerce/screens/add_product_screen.dart';
import 'package:e_commerce/screens/product_card.dart';
import 'package:e_commerce/blocs/cart_bloc/cart_bloc.dart';
import 'package:e_commerce/blocs/cart_bloc/cart_event.dart';
import 'package:e_commerce/blocs/cart_bloc/cart_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce/model/shop.dart';
import 'package:e_commerce/cubit/user_cubit.dart';
import 'package:e_commerce/cubit/role_cubit.dart';
import 'package:e_commerce/reusable_widget/custom_app_bar.dart';
class ShopDetailScreen extends StatefulWidget {
  final Shop shop;

  const ShopDetailScreen({required this.shop});

  @override
  _ShopDetailScreenState createState() => _ShopDetailScreenState();
}

class _ShopDetailScreenState extends State<ShopDetailScreen> {
  void addToCart(Product product, int quantity) {
    context.read<CartBloc>().add(AddToCartEvent(product, quantity));
  }

  void updateProductQuantityAfterOrder(String productName, int newQuantity) {
    setState(() {
      widget.shop.products.forEach((product) {
        if (product.name == productName) {
          product.quantity = newQuantity;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final String userRole = context.read<RoleCubit>().getUserRole() ?? '';

    return Scaffold(
      appBar: CustomAppBar(title:"Shops Details"),
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
                        children: widget.shop.products
                        .where((product) => product.isShown) // Filter products based on isShown
                        .map((product) {
                          return ProductCard(
                            product: product,
                            onAddToCart: (product, quantity) {
                              addToCart(product, quantity);
                            },
                            onUpdateQuantityAfterOrder: (productName, newQuantity) {
                              updateProductQuantityAfterOrder(productName, newQuantity);
                            },
                          );
                        })
                        .toList(),
                      ),
                      SizedBox(height: 20),
                      if (userRole == 'Shop Owner')
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddProductScreen(shop: widget.shop),
                              ),
                            );
                          },
                          child: Text('Add Product'),
                        ),
                      if (userRole != 'Shop Owner')
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CartScreen(cart: cart, shopName: widget.shop.name),
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


