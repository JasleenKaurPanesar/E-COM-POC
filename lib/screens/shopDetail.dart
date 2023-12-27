import 'package:e_commerce/screens/cartScreen.dart';
import 'package:e_commerce/screens/productCard.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/model/product.dart';
import 'package:e_commerce/model/shop.dart';
import 'package:provider/provider.dart';
import 'package:e_commerce/providers/cartProvider.dart';
import 'package:e_commerce/model/dummydata.dart';
class ShopDetailScreen extends StatefulWidget {
  final Shop shop;

  const ShopDetailScreen({required this.shop});

  @override
  _ShopDetailScreenState createState() => _ShopDetailScreenState();
}

class _ShopDetailScreenState extends State<ShopDetailScreen> {
  void addToCart(Product product, int quantity) {
    // Access the cart from the CartProvider using Provider.of
    CartProvider cartProvider = Provider.of<CartProvider>(context, listen: false);

    // Check if the product is already in the cart
    int index = cartProvider.cart.indexWhere((cartProduct) => cartProduct.name == product.name);

    setState(() {
      if (index != -1) {
        // Product already exists in the cart, update quantity
        cartProvider.cart[index] = Product(
          name: product.name,
          price: product.price,
          quantity:  quantity,
          photo: product.photo,
          description: product.description,
        );
      } else {
        // Product doesn't exist in the cart, add a new entry
        cartProvider.addToCart(product, quantity);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shop Details"),
      ),
      body: SingleChildScrollView(
        child: Consumer<CartProvider>(
          builder: (context, cartProvider, child) {
            List<Product> cart = cartProvider.cart;
             Shop shop = DummyShopList.getShops().firstWhere(
              (element) => element.name == widget.shop.name,
            );
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 3,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(widget.shop.photo),
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
