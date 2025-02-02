import 'dart:io';
import 'package:check_news/services/storage/storage_services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ImagePost extends StatefulWidget {
  final Function(String) onImageUpload; // Callback to return the image URL
  const ImagePost({super.key, required this.onImageUpload});

  @override
  State<ImagePost> createState() => _ImagePostState();
}

class _ImagePostState extends State<ImagePost> {
  File? _selectedImage;

  Future<void> _uploadImage(File image) async {
    final storageServices =
        Provider.of<StorageServices>(context, listen: false);
    await storageServices.uploadImage(image).then((url) {
      widget.onImageUpload(url); // Return the uploaded image URL
    }).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error uploading image: $e")),
      );
    });
  }

  Future<void> _pickFromGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
        await _uploadImage(File(image.path)); // Upload image after selection
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error picking image: $e")));
    }
    Navigator.of(context).pop();
  }

  Future<void> _pickFromCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
        await _uploadImage(File(image.path)); // Upload image after selection
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error picking image: $e")));
    }
    Navigator.of(context).pop();
  }

  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Select Image Source",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.blue),
              title: const Text("Choose from Camera"),
              onTap: _pickFromCamera,
            ),
            ListTile(
              leading: const Icon(Icons.image, color: Colors.green),
              title: const Text("Choose from Gallery"),
              onTap: _pickFromGallery,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showImageSourceOptions,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(8),
          image: _selectedImage != null
              ? DecorationImage(
                  image: FileImage(_selectedImage!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: _selectedImage == null
            ? Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.image,
                    size: 200,
                    color: Colors.black.withOpacity(0.5),
                  ),
                  const Text(
                    "Tap to Add Image",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            : null,
      ),
    );
  }
}
