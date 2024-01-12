import 'package:e_commerce/model/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:e_commerce/cubit/user_cubit.dart';
import 'package:e_commerce/blocs/shops_bloc/shops_event.dart';
import 'package:e_commerce/blocs/shops_bloc/shops_bloc.dart'; // Import your shops_bloc file

class ProductCardOwner extends StatefulWidget {
  final Product product;

  const ProductCardOwner({
    required this.product,
  });

  @override
  _ProductCardOwnerState createState() => _ProductCardOwnerState();
}

class _ProductCardOwnerState extends State<ProductCardOwner> {
  late TextEditingController _quantityController;
  late TextEditingController _priceController;
  bool _isEditing = false;
  bool _isShown = true;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(text: widget.product.quantity.toString());
    _priceController = TextEditingController(text: widget.product.price.toString());
    _isShown = widget.product.isShown;
  }

  void updateProductQuantityPrice(String shopId, String uid, String name, int newQuantity, double newPrice) {
    // Use context.read to get the instance of ShopsBloc
    final shopsBloc = context.read<ShopsBloc>();
    // Dispatch the UpdateProductEvent
    shopsBloc.add(
      UpdateProductEvent(
        shopId: shopId,
        uid: uid,
        name: name,
        newQuantity: newQuantity,
        newPrice: newPrice,
      ),
    );
  }

  void updateProductIsShown(String shopId, String uid, String name, bool isShown) {
    final shopsBloc = context.read<ShopsBloc>();

    // Dispatch the UpdateProductEvent
    shopsBloc.add(
      UpdateProductIsShownEvent(
        shopId: shopId,
        uid: uid,
        name: name,
        isShown: isShown,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String uid = context.read<UserCubit>().getUid() ?? '';

    return Container(
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: SingleChildScrollView(
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(widget.product.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
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
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text(
                      'Description:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        widget.product.description,
                        style: const TextStyle(
                          color: Colors.green,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Text(
                      'Price:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 4),
                    if (_isEditing)
                      Expanded(
                        child: TextFormField(
                          controller: _priceController,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            // Handle changes in price
                          },
                        ),
                      )
                    else
                      Text(
                        '\$${widget.product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _isEditing = !_isEditing;
                        });
                      },
                      child: Icon(
                        _isEditing ? Icons.check : Icons.edit,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Text(
                      'Qty:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 4),
                    if (_isEditing)
                      Expanded(
                        child: TextFormField(
                          controller: _quantityController,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            // Handle changes in quantity
                          },
                        ),
                      )
                    else
                      Text(
                        widget.product.quantity.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _isEditing = !_isEditing;
                        });
                      },
                      child: Icon(
                        _isEditing ? Icons.check : Icons.edit,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (_isEditing)
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Save changes button
                     
                          setState(() {
                            _isEditing = false;
                            // Update product data in the database or wherever it's stored
                            widget.product.price = double.parse(_priceController.text);
                            widget.product.quantity = int.parse(_quantityController.text);
                            updateProductQuantityPrice(
                              widget.product.shopName.toLowerCase().replaceAll(" ", ""),
                              uid,
                              widget.product.name,
                              widget.product.quantity,
                              widget.product.price,
                            );
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue, // Set the background color
                        ),
                        child: const Text('Save Changes'),
                      ),
                    ],
                  ),
                Row(
                  children: [
                    const Text(
                      'Show:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Switch(
                      value: _isShown,
                      onChanged: (value) {
                        setState(() {
                          _isShown = value;
                          // Update the isShown field of the product
                          widget.product.isShown = value;
                          updateProductIsShown(
                            widget.product.shopName.toLowerCase().replaceAll(" ", ""),
                            uid,
                            widget.product.name,
                            widget.product.isShown,
                          );
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            onTap: () {
              // Handle product click
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }
}
