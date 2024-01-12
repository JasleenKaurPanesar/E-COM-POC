import 'package:flutter/material.dart';
import 'package:e_commerce/model/product.dart';
import 'package:e_commerce/screens/shop_owner/add_product_screen.dart';
import 'package:e_commerce/screens/shop_owner/product_card_owner.dart';
import 'package:e_commerce/blocs/cart_bloc/cart_bloc.dart';
import 'package:e_commerce/blocs/cart_bloc/cart_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce/model/shop.dart';
import 'package:e_commerce/cubit/role_cubit.dart';
import 'package:e_commerce/reusable_widget/custom_app_bar.dart';
class ProductDetailScreen extends StatefulWidget {
  final Shop shop;

  const ProductDetailScreen({required this.shop});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
 



  @override
  Widget build(BuildContext context) {
    final String userRole = context.read<RoleCubit>().getUserRole() ?? '';

    return Scaffold(
      appBar: const CustomAppBar(title:"Shop Details"),
      body: SingleChildScrollView(
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            List<Product> cart = (state as CartLoadedState).cart;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.shop.name,
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.shop.description,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Products',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      const SizedBox(height: 10),
                      // Display the details of each product
                      for (Product product in widget.shop.products)
                        ProductCardOwner(
                          product: product
                        ),
                      const SizedBox(height: 20),
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
                          child: const Text('Add Product'),
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
