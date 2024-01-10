import 'package:flutter/material.dart';
import 'package:e_commerce/helpers/reusable_widget.dart';
import 'package:e_commerce/model/shop.dart';
import 'package:e_commerce/model/product.dart';
import 'package:e_commerce/cubit/user_cubit.dart';
import 'package:e_commerce/blocs/shops_bloc/shops_bloc.dart';
import 'package:e_commerce/blocs/shops_bloc/shops_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce/reusable_widget/image_picker.dart';


class AddProductScreen extends StatefulWidget {
  final Shop shop;

  const AddProductScreen({super.key, required this.shop});

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
  bool _isButtonClicked = false;

  @override
  Widget build(BuildContext context) {
    final String uid1 = context.read<UserCubit>().getUid() ?? ''; // provide a default value

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
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
                    text: 'Product Name',
                    icon: Icons.shopping_cart,
                    isPasswordType: false,
                    controller: _nameController,
                    validator: (value) {
                      if (_isButtonClicked && (value == null || value.isEmpty)) {
                        return 'Please enter the product name';
                      }
                      return null;
                    },
                    isButtonEnabled: true,
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: ListTile(
                      title: Text(
                        'Add Shop Image',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ImagePickerField(controller: _photoController),
                    ),
                  ),
                  if (_photoController.text.isEmpty && _isButtonClicked)
                    const Center(
                      child:Padding(
                      padding: EdgeInsets.symmetric(vertical: 8,),
                      child: Text(
                        'Please pick an image for the product.',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    ),
                  const SizedBox(height: 16),
                  buildTextField(
                    text: 'Product Description',
                    icon: Icons.description,
                    isPasswordType: false,
                    controller: _descriptionController,
                    validator: (value) {
                      if (_isButtonClicked && (value == null || value.isEmpty)) {
                        return 'Please enter the product description';
                      }
                      return null;
                    },
                    isButtonEnabled: true,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  buildTextField(
                    text: 'Product Price',
                    icon: Icons.money,
                    isPasswordType: false,
                    controller: _priceController,
                    validator: (value) {
                      if (_isButtonClicked && (value == null || double.tryParse(value) == null)) {
                        return 'Please enter a valid price';
                      }
                      return null;
                    },
                    isButtonEnabled: true,
                  ),
                  const SizedBox(height: 16),
                  buildTextField(
                    text: 'Product Quantity',
                    icon: Icons.format_list_numbered,
                    isPasswordType: false,
                    controller: _quantityController,
                    validator: (value) {
                      if (_isButtonClicked && (value == null || int.tryParse(value) == null)) {
                        return 'Please enter a valid quantity';
                      }
                      return null;
                    },
                    isButtonEnabled: true,
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isButtonClicked = true;
                        });

                        if (_formKey.currentState!.validate() &&
                          _photoController.text.isNotEmpty) {
                          final String shopId = widget.shop.name.toLowerCase().replaceAll(" ", "");
                          final String uid = uid1;
                          final Product newProduct = Product(
                            name: _nameController.text,
                            photo: _photoController.text,
                            description: _descriptionController.text,
                            price: double.parse(_priceController.text),
                            quantity: int.parse(_quantityController.text),
                            shopName: widget.shop.name,
                          );

                          context.read<ShopsBloc>().add(AddProductEvent(
                            shopId: shopId,
                            uid: uid1,
                            newProduct: newProduct,
                          ));

                          Navigator.pop(context);
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          'Add Product',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
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
