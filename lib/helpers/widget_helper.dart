
import 'package:flutter/material.dart';
import 'dart:convert';

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data'; 

TextFormField buildTextField({
  required String text,
  required IconData icon,
  required TextEditingController controller,
  String? Function(String?)? validator,
  bool isButtonEnabled = true,
  int maxLines = 1,
  bool isPasswordType = false,
}) {
  return TextFormField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Colors.black,
    validator: validator,
    style: TextStyle(color: Colors.black.withOpacity(0.9)),
    maxLines: maxLines,
    decoration: InputDecoration(
      prefixIcon: Icon(icon, color: Colors.black),
      labelText: text,
      labelStyle: TextStyle(color: Colors.black.withOpacity(0.9)),
      filled: true,
      fillColor: Colors.grey[200],
      floatingLabelBehavior: FloatingLabelBehavior.never,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide(width: 0, style: BorderStyle.none),
      ),
      errorText: isButtonEnabled ? (validator != null ? validator(controller.text) : null) : null,
    ),
    keyboardType: isPasswordType ? TextInputType.visiblePassword : TextInputType.emailAddress,
  );
}



File base64ToFile(String base64String, String fileName) {
  try {
    final List<int> bytes = base64.decode(base64String);
    
    // Sanitize the filename
    final sanitizedFileName = fileName.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
    
    final File file = File(sanitizedFileName);

    // Write the file
    file.writeAsBytesSync(bytes);

    return file;
  } catch (error) {
    print("Error converting base64 to file: $error");
    return File(''); // You can return null or an empty file, depending on your needs
  }
}
Future<String> uploadImageToStorage(String base64Image, String fileName) async {
  try {
    List<int> imageBytes = base64Decode(base64Image);
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference storageReference = storage.ref().child('shop_images').child(fileName);

    // Convert List<int> to Uint8List
    Uint8List uint8List = Uint8List.fromList(imageBytes);

    // Use putData with Uint8List
    await storageReference.putData(uint8List);

    print('Image uploaded to storage');

    // Return the download URL
    return await storageReference.getDownloadURL();
  } catch (e) {
    print('Error uploading image to storage: $e');
    return ''; // You might want to return null or handle the error differently based on your needs
  }
}
