import 'dart:io';
import 'package:check_news/services/cloudinary_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SelectImageScreen extends StatefulWidget {
  final String title;
  final String content;

  const SelectImageScreen(
      {super.key, required this.title, required this.content});

  @override
  State<SelectImageScreen> createState() => _SelectImageScreenState();
}

class _SelectImageScreenState extends State<SelectImageScreen> {
  List<FilePickerResult?> _filePickerResults = [];
  List<String?> _imagePaths = [];
  bool _isUploading = false;


  Future<void> pickImages() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: true);
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _filePickerResults.add(result);
        _imagePaths.addAll(result.files.map((file) => file.path!));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No images selected!")),
      );
    }
  }


  void removeImage(int index) {
    setState(() {
      _imagePaths.removeAt(index);
      _filePickerResults.removeAt(index);
    });
  }

  
  Future<void> uploadNewsToDb() async {
    setState(() {
      _isUploading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

     
      final userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();
      final userName = userDoc.data()?['name'] ?? "Unknown";

      final newsRef = await FirebaseFirestore.instance.collection("news").add({
        "title": widget.title.trim(),
        "content": widget.content.trim(),
        "author": userName,
        "date": FieldValue.serverTimestamp(),
        "likes": [],
        "approve": "pending",
        "images": [], // Will update later if images exist
      });

      final String newsId = newsRef.id;
      CloudinaryService cloudinaryService = CloudinaryService();
      List<String> uploadedUrls = [];

      if (_filePickerResults.isNotEmpty && _imagePaths.isNotEmpty) {
        
        for (var fileResult in _filePickerResults) {
          final uploadedUrl =
              await cloudinaryService.uploadToCloudinary(fileResult!, newsId);
          if (uploadedUrl != null) {
            uploadedUrls.add(uploadedUrl);
          }
        }
      }

      // Update Firestore with uploaded image URLs if any exist
      if (uploadedUrls.isNotEmpty) {
        await newsRef.update({"images": uploadedUrls});
      }

      setState(() {
        _isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("News posted successfully!")),
      );

      // Navigate back to home screen
      Navigator.popUntil(context, (route) => route.isFirst);
    } catch (e) {
      setState(() {
        _isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to post news: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      appBar: AppBar(
        title: const Text("Select Images",
            style: TextStyle(color: Color.fromRGBO(0, 223, 130, 1))),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image Previews
            _imagePaths.isNotEmpty
                ? SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _imagePaths.length,
                      itemBuilder: (context, index) => Stack(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Image.file(File(_imagePaths[index]!),
                                height: 200, 
                                fit: BoxFit.contain),
                          ),
                          Positioned(
                            top: 5,
                            right: 5,
                            child: IconButton(
                              icon: const Icon(Icons.cancel,
                                  color: Colors.red, size: 30),
                              onPressed: () => removeImage(index),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(
                    height: 200,
                    width: double.infinity,
                    color: Theme.of(context).colorScheme.secondary,
                    child: const Center(
                        child: Text("No images selected",
                            style: TextStyle(fontSize: 16))),
                  ),
            const SizedBox(height: 30),

            // Select Images Button
            ElevatedButton(
              onPressed: pickImages,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                textStyle: const TextStyle(fontSize: 18),
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
              child: const Text("Select Images"),
            ),
             const SizedBox(height: 100),
            ElevatedButton(
              onPressed: uploadNewsToDb,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 66),
                textStyle: const TextStyle(fontSize: 18),
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
              child: const Text("Post without Image"),
            ),

            const SizedBox(height: 20),

            // Upload Button with Animation
            _isUploading
                ? Column(
                    children: [
                      Lottie.asset('assets/animations/uploading.json',
                          height: 150),
                      const SizedBox(height: 10),
                      const Text("Uploading... Please wait",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  )
                : ElevatedButton.icon(
                    onPressed: uploadNewsToDb,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 80),
                      textStyle: const TextStyle(fontSize: 18),
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.send, color: Colors.white),
                    label: const Text("Post News",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
          ],
        ),
      ),
    );
  }
}
