import 'package:flutter/material.dart';
import 'package:e_commerce/reusable_widget/reusable_widget.dart';
import 'package:e_commerce/model/shop.dart';
import 'package:e_commerce/model/product.dart';
import 'package:e_commerce/cubit/userCubit.dart';
import 'package:e_commerce/blocs/shops_bloc/shops_bloc.dart';
import 'package:e_commerce/blocs/shops_bloc/shops_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddProductScreen extends StatefulWidget {
  final Shop shop;

  const AddProductScreen({required this.shop});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _photoController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final String uid1 = context.read<UserCubit>().getUid() ?? ''; // provide a default value

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTextField(
                    'Product Name',
                    Icons.shopping_cart,
                    false,
                    _nameController,
                    (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the product name';
                      }
                      return null;
                    },
                    true,
                  ),
                  SizedBox(height: 16),
                  ImagePickerField(controller: _photoController),
                  SizedBox(height: 16),
                  buildTextField(
                    'Product Description',
                    Icons.description,
                    false,
                    _descriptionController,
                    (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the product description';
                      }
                      return null;
                    },
                    true,
                  ),
                  SizedBox(height: 16),
                  buildTextField(
                    'Product Price',
                    Icons.money,
                    false,
                    _priceController,
                    (value) {
                      if (value == null || double.tryParse(value) == null) {
                        return 'Please enter a valid price';
                      }
                      return null;
                    },
                    true,
                  ),
                  SizedBox(height: 16),
                  buildTextField(
                    'Product Quantity',
                    Icons.format_list_numbered,
                    false,
                    _quantityController,
                    (value) {
                      if (value == null || int.tryParse(value) == null) {
                        return 'Please enter a valid quantity';
                      }
                      return null;
                    },
                    true,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      print("checkkkkkk plz");
                      if (_formKey.currentState!.validate()) {
                        // Dispatch the AddProductEvent here
                        final String shopId =
                            widget.shop.name.toLowerCase().replaceAll(" ", ""); // Replace with your actual shop ID
                        final String uid = uid1; // Replace with your actual user ID
                        final Product newProduct = Product(
                          name: _nameController.text,
                          photo: _photoController.text,
                          description: _descriptionController.text,
                          price: double.parse(_priceController.text),
                          quantity: int.parse(_quantityController.text),
                          shopName: widget.shop.name,
                        );

                        // Dispatch the AddProductEvent
                        context.read<ShopsBloc>().add(AddProductEvent(
                              shopId: shopId,
                              uid: uid1,
                              newProduct: newProduct,
                            ));

                        // Navigate back to the ShopDetailScreen
                        Navigator.pop(context);
                      }
                    },
                    child: Text('Add Product'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
