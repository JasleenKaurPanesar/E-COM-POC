import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce/blocs/shops_bloc/shops_bloc.dart';
import 'package:e_commerce/blocs/shops_bloc/shops_event.dart';
import 'package:e_commerce/model/shop.dart';
import 'package:e_commerce/helpers/widget_helper.dart';
import 'package:e_commerce/reusable_widget/image_picker.dart';
import 'package:e_commerce/screens/shop_owner/create_shop_success_screen.dart';

class CreateShopScreen extends StatefulWidget {
  final String uid;

  const CreateShopScreen({Key? key, required this.uid}) : super(key: key);

  @override
  _CreateShopScreenState createState() => _CreateShopScreenState();
}

class _CreateShopScreenState extends State<CreateShopScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _photoController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lngController = TextEditingController();
  bool _isButtonClicked = false;

  @override
  Widget build(BuildContext context) {
    final String uid = widget.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Shop'),
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
                    text: "Shop Name",
                    icon: Icons.shop,
                    
                    controller: _nameController,
                    validator: (value) =>
                        _isButtonClicked && value!.isEmpty
                            ? 'Shop name cannot be empty'
                            : null,
                    isButtonEnabled: true,
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: ListTile(
                      title: Text(
                        'Add Shop Image',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ImagePickerField(controller: _photoController),
                  if (_photoController.text.isEmpty && _isButtonClicked)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Please pick an image for the shop.',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  const SizedBox(height: 16),
                  buildTextField(
                    text: "Description",
                    icon: Icons.description,
             
                    controller: _descriptionController,
                    validator: (value) =>
                        _isButtonClicked && value!.isEmpty
                            ? 'Description cannot be empty'
                            : null,
                    isButtonEnabled: true,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  buildTextField(
                    text: "Address",
                    icon: Icons.location_on,
            
                    controller: _addressController,
                    validator: (value) =>
                        _isButtonClicked && value!.isEmpty
                            ? 'Address cannot be empty'
                            : null,
                    isButtonEnabled: true,
                  ),
                  const SizedBox(height: 16),
                  buildTextField(
                    text: "Latitude",
                    icon: Icons.map,
          
                    controller: _latController,
                    validator: (value) =>
                        _isButtonClicked && value!.isEmpty
                            ? 'Latitude cannot be empty'
                            : null,
                    isButtonEnabled: true,
                  ),
                  const SizedBox(height: 16),
                  buildTextField(
                    text: "Longitude",
                    icon: Icons.map,
                 
                    controller: _lngController,
                    validator: (value) =>
                        _isButtonClicked && value!.isEmpty
                            ? 'Longitude cannot be empty'
                            : null,
                    isButtonEnabled: true,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _isButtonClicked = true;
                      });

                      if (_formKey.currentState!.validate() &&
                          _photoController.text.isNotEmpty) {
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
                        BlocProvider.of<ShopsBloc>(context)
                            .add(CreateShop(newShop: newShop, uid: uid));
                                // Dispatch the FetchUserShops event to reload user's shops
                      BlocProvider.of<ShopsBloc>(context).add(FetchUserShops(uid: uid));

 

                        // Wait for a short duration (e.g., 500 milliseconds) to allow the state to update
                        await Future.delayed(const Duration(milliseconds: 500));

                        // Navigate to the success screen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CreateShopSuccessScreen(uid: uid),
                                            ),
                                          );
                      }
                    },
                    child: const Text('Create Shop'),
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
