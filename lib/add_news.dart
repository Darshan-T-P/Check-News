import 'package:check_news/select_image.dart';
import 'package:check_news/services/cloudinary_services.dart';
import 'package:check_news/services/storage/storage_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddNews extends StatefulWidget {
  const AddNews({super.key});

  @override
  State<AddNews> createState() => _AddNewsState();
}

class _AddNewsState extends State<AddNews> {
  final TextEditingController _titlecontroller = TextEditingController();
  final TextEditingController _contentcontroller = TextEditingController();

  final String _defaultImageUrl =
      "https://i.ibb.co/CtjXmQ7/Adobe-Stock-245562438-scaled.jpg"; // Replace with your default image URL

  Future<FilePickerResult?> pickImage() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    return result; // Return the selected file
  }

  // Future<void> uploadNewsToDb(FilePickerResult? filePickerResult) async {
  //   try {
  //     final user = FirebaseAuth.instance.currentUser;
  //     if (user == null) return;

  //     if (_titlecontroller.text.trim().isEmpty ||
  //         _contentcontroller.text.trim().isEmpty) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("Title and content cannot be empty!")),
  //       );
  //       return;
  //     }

  //     final userDoc = await FirebaseFirestore.instance
  //         .collection("users")
  //         .doc(user.uid)
  //         .get();
  //     final userName = userDoc.data()?['name'] ?? "Unknown";

  //     // Show loading indicator
  //     showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (context) {
  //         return const AlertDialog(
  //           title: Text("Uploading News"),
  //           content: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               CircularProgressIndicator(),
  //               SizedBox(height: 10),
  //               Text("Please wait..."),
  //             ],
  //           ),
  //         );
  //       },
  //     );

  //     // Add news entry first to get the document ID (newsId)
  //     final newsRef = await FirebaseFirestore.instance.collection("news").add({
  //       "title": _titlecontroller.text.trim(),
  //       "content": _contentcontroller.text.trim(),
  //       "author": userName,
  //       "date": FieldValue.serverTimestamp(),
  //       "approve": "pending",
  //       "image": "", // Placeholder
  //     });

  //     final String newsId = newsRef.id;

  //     // Upload image if selected
  //     String imageUrl = _defaultImageUrl;
  //     if (filePickerResult != null) {
  //       CloudinaryService cloudinaryService = CloudinaryService();
  //       final uploadedUrl = await cloudinaryService
  //           .uploadToCloudinary(filePickerResult, newsId: newsId);
  //       if (uploadedUrl != null) {
  //         imageUrl = uploadedUrl;
  //       }
  //     }

  //     // Update the news entry with the image URL
  //     await newsRef.update({"image": imageUrl});

  //     // Dismiss loading dialog
  //     Navigator.pop(context);

  //     print("News uploaded with ID: $newsId");
  //     ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("News posted successfully!")));
  //   } catch (e) {
  //     print("Error uploading news: $e");

  //     // Dismiss loading dialog in case of error
  //     Navigator.pop(context);

  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text("Failed to post news: $e")));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<StorageServices>(
        builder: (context, storageServices, child) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        appBar: AppBar(
          title: const Text(
            "Add News",
            style: TextStyle(color: Color.fromRGBO(0, 223, 130, 1)),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _titlecontroller,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 20)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          color: Color.fromRGBO(0, 223, 130, 1),
                          width: 4.0), // White border when focused
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          color: Colors
                              .white), // Transparent border when not focused
                    ),
                    labelText: "Title",
                    labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.primary)),
              ),
              const SizedBox(height: 26),
              SizedBox(
                height: 500, // Adjust height for the content box
                child: TextField(
                  controller: _contentcontroller,
                  maxLines: null,
                  expands: true,
                  decoration: InputDecoration(
                    labelText: "Content to be added",
                    labelStyle:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                    contentPadding: const EdgeInsets.all(10),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          color: Color.fromRGBO(0, 223, 130, 1),
                          width: 4.0), // White border when focused
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          color: Colors
                              .white), // Transparent border when not focused
                    ),
                    hintText: "Enter your content here...",
                    hintStyle:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_titlecontroller.text.trim().isEmpty ||
                      _contentcontroller.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Title and content cannot be empty!")),
                    );
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectImageScreen(
                        title: _titlecontroller.text.trim(),
                        content: _contentcontroller.text.trim(),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Theme.of(context).colorScheme.tertiary,
                ),
                child: const Text("Next",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      );
    });
  }
}
