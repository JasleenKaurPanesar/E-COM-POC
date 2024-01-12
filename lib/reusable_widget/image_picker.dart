import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

class ImagePickerField extends StatefulWidget {
  final TextEditingController controller;

  const ImagePickerField({Key? key, required this.controller}) : super(key: key);

  @override
  _ImagePickerFieldState createState() => _ImagePickerFieldState();
}

class _ImagePickerFieldState extends State<ImagePickerField> {
  final ImagePicker _picker = ImagePicker();
  String? _validationMessage;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
      );

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        final String base64Image = base64Encode(bytes);

        setState(() {
          widget.controller.text = base64Image;
          _validationMessage = null; // Reset validation message when a new image is picked
        });
      }
    } catch (e) {
      // Handle the exception (e.g., print an error message)
      print("Error picking image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _showImagePickerOptions(context),
          child: Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Center(
              child: widget.controller.text.isNotEmpty
                  ? Image.memory(
                      base64Decode(widget.controller.text),
                      fit: BoxFit.cover,
                      height: 150,
                      width: 150,
                    )
                  : const Icon(Icons.add_photo_alternate, size: 40),
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => _showImagePickerOptions(context),
          child: const Text('Pick Image'),
        ),
        if (_validationMessage != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              _validationMessage!,
              style: const TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }

  Future<void> _showImagePickerOptions(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Photo Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        );
      },
    );
  }
}
