
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
Image logoWidget(String imageName){
  return Image.asset(
    imageName,
    fit:BoxFit.fitWidth,
    width:240,
    height:240
  );

}

 TextFormField buildTextField(
  String text,
  IconData icon,
  bool isPasswordType,
  TextEditingController controller,
  String? Function(String?)? validator,
  bool isButtonEnabled,
) {
  return TextFormField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Colors.black,
    validator: validator,
    style: TextStyle(color: Colors.black.withOpacity(0.9)),
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
    keyboardType:
        isPasswordType ? TextInputType.visiblePassword : TextInputType.emailAddress,
  );
}


class ImagePickerField extends StatelessWidget {
  final TextEditingController controller;

  const ImagePickerField({Key? key, required this.controller}) : super(key: key);

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        final String base64Image = base64Encode(bytes);

        controller.text = base64Image;
      }
    } catch (e) {
      // Handle the exception (e.g., print an error message)
      print("Error picking image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Product Photo",
          style: TextStyle(color: Colors.black),
        ),
        SizedBox(height: 16),
        buildTextField(
          "Upload Photo",
          Icons.upload,
          false,
          controller,
          (value) => value!.isEmpty ? 'Photo URL cannot be empty' : null,
          true,
        ),
        SizedBox(height: 8),
        ElevatedButton(
          onPressed: _pickImage,
          child: Text('Upload from Gallery'),
        ),
      ],
    );
  }
}
Container signInSignUpButon(BuildContext context,bool isLogIn,Function onTap,bool isEnabled){
  return Container(
    width:MediaQuery.of(context).size.width,
    height:50,
    margin:const EdgeInsets.fromLTRB(0,10,0,20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90.0)),
    child:ElevatedButton(
      onPressed:isEnabled?(){onTap();}:null ,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) {
        if(states.contains(MaterialState.pressed)){
          return Colors.black26;
        }
        return Colors.white;
        }
        ),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)))
        
      ),
      child:Text(
        isLogIn?"Log In":"Sign Up",
        style:const TextStyle(color: Colors.black87,fontWeight: FontWeight.bold,fontSize: 16)
      ),
      )
  );
  


}