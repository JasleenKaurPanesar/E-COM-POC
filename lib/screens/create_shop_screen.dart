import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce/blocs/shops_bloc/shops_bloc.dart';
import 'package:e_commerce/blocs/shops_bloc/shops_event.dart';
import 'package:e_commerce/blocs/shops_bloc/shops_state.dart';
import 'package:e_commerce/model/shop.dart';
import 'package:e_commerce/reusable_widget/reusable_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:e_commerce/screens/create_shop_success_screen.dart';
import 'dart:convert';

class CreateShopScreen extends StatefulWidget {
   final String uid; 

  const CreateShopScreen({Key? key, required this.uid}) : super(key: key);

  @override
  _CreateShopScreenState createState() => _CreateShopScreenState();
}

class _CreateShopScreenState extends State<CreateShopScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _photoController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _latController = TextEditingController();
  TextEditingController _lngController = TextEditingController();

Future<void> _pickImage() async {
  final ImagePicker _picker = ImagePicker();
  try {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      final String base64Image = base64Encode(bytes);

      setState(() {
        _photoController.text = base64Image;
      });
    }
  } catch (e) {
    // Handle the exception (e.g., print an error message)
    print("Error picking image: $e");
  }
}

  @override
  Widget build(BuildContext context) {
   
    final String uid = widget.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Shop'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  buildTextField(
                    "Shop Name",
                    Icons.shop,
                    false,
                    _nameController,
                    (value) =>
                        value!.isEmpty ? 'Shop name cannot be empty' : null,
                    true,
                  ),
                  SizedBox(height: 16),
                  ImagePickerField(controller: _photoController),
                  SizedBox(height: 16),
                  buildTextField(
                    "Description",
                    Icons.description,
                    false,
                    _descriptionController,
                    (value) =>
                        value!.isEmpty ? 'Description cannot be empty' : null,
                    true,
                  ),
                  SizedBox(height: 16),
                  buildTextField(
                    "Address",
                    Icons.location_on,
                    false,
                    _addressController,
                    (value) =>
                        value!.isEmpty ? 'Address cannot be empty' : null,
                    true,
                  ),
                  SizedBox(height: 16),
                  buildTextField(
                    "Latitude",
                    Icons.map,
                    false,
                    _latController,
                    (value) =>
                        value!.isEmpty ? 'Latitude cannot be empty' : null,
                    true,
                  ),
                  SizedBox(height: 16),
                  buildTextField(
                    "Longitude",
                    Icons.map,
                    false,
                    _lngController,
                    (value) =>
                        value!.isEmpty ? 'Longitude cannot be empty' : null,
                    true,
                  ),
                  SizedBox(height: 32),
                 ElevatedButton(
  onPressed: () async {
    if (_formKey.currentState!.validate()) {
      Shop newShop = Shop(
        name: _nameController.text.trim(),
        photo: _photoController.text.trim(),
        description: _descriptionController.text.trim(),
        address: _addressController.text.trim(),
        latitude: double.parse(_latController.text.trim()),
        longitude: double.parse(_lngController.text.trim()),
        owner: uid ?? "",
        products: [],
      );

      // Dispatch the CreateShop event
      BlocProvider.of<ShopsBloc>(context).add(CreateShop(newShop: newShop, uid: uid));

      // Wait for a short duration (e.g., 500 milliseconds) to allow the state to update
      await Future.delayed(Duration(milliseconds: 500));

      // Navigate to the success screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CreateShopSuccessScreen(uid: uid),
        ),
      );
    }
  },
  child: Text('Create Shop'),
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
