import 'package:e_commerce/model/product.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final Function(Product, int) onAddToCart;
  final Function(String, int) onUpdateQuantityAfterOrder;

  const ProductCard({
    required this.product,
    required this.onAddToCart,
    required this.onUpdateQuantityAfterOrder,
  });

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int quantity = 0;

  void incrementQuantity() {
    setState(() {
      quantity++;
    });
    widget.onAddToCart(widget.product, quantity);
  }

  void decrementQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
      widget.onAddToCart(widget.product, quantity);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(widget.product.photo),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        title: Text(widget.product.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '\$${widget.product.price.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Qty:${widget.product.quantity}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 4),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: decrementQuantity,
                ),
                Text('Quantity: $quantity'),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: incrementQuantity,
                ),
              ],
            ),
          ],
        ),
        onTap: () {
          // Handle product click
        },
      ),
    );
  }
}
