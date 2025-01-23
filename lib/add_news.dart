import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddNews extends StatefulWidget {
  const AddNews({super.key});

  @override
  State<AddNews> createState() => _AddNewsState();
}

class _AddNewsState extends State<AddNews> {
  final TextEditingController _titlecontroller = TextEditingController();
  final TextEditingController _contentcontroller = TextEditingController();

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> uploadNewsToDb() async {
    try {
      final data = await FirebaseFirestore.instance.collection("news").add({
        "title": _titlecontroller.text.trim(),
        "content": _contentcontroller.text.trim(),
        "Date": FieldValue.serverTimestamp(),
      });
      print(data.id);
    } catch (e) {
      print(e);
    }
  }

  // Function to pick an image from the camera
  Future<void> _pickFromCamera() async {
    final image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
    Navigator.of(context).pop(); // Close the dialog
  }

  // Function to pick an image from the gallery
  Future<void> _pickFromGallery() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
    Navigator.of(context).pop(); // Close the dialog
  }

  // Function to show the bottom sheet
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add News"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // GestureDetector for the image container
            GestureDetector(
              onTap: _showImageSourceOptions,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
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
                    :null ,
              ),
            ),
            const SizedBox(height: 20),

            // Title Input Field
            TextField(
              controller: _titlecontroller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Title",
              ),
            ),
            const SizedBox(height: 20),

            // Large Content Box
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _contentcontroller,
                  maxLines: null, // Allow multiline input
                  expands: true, // Makes it fill the available space
                  decoration: const InputDecoration(
                    labelText: "Content",
                    contentPadding: EdgeInsets.all(16),
                    border: InputBorder.none,
                    hintText: "Enter your content here...",
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Post Button
            ElevatedButton.icon(
              onPressed: () async {
                // Handle post submission
                await uploadNewsToDb();
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 18),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              label: const Text("POST"),
              icon: const Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
