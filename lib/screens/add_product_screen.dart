import 'package:flutter/material.dart';
import 'package:e_commerce/reusable_widget/reusable_widget.dart';

class AddProductScreen extends StatefulWidget {
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: Padding(
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
              buildTextField(
                'Product Photo URL',
                Icons.image,
                false,
                _photoController,
                (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the product photo URL';
                  }
                  return null;
                },
                true,
              ),
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
                  if (_formKey.currentState!.validate()) {
                    // Your logic to add the product to the shop
                  }
                },
                child: Text('Add Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
