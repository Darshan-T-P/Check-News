import 'package:check_news/screens/image_post.dart';
import 'package:check_news/services/storage/storage_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  String? _imageUrl;
  final String _defaultImageUrl =
      "https://i.ibb.co/CtjXmQ7/Adobe-Stock-245562438-scaled.jpg"; // Replace with your default image URL

  Future<void> uploadNewsToDb(String imageUrl) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // Fetch user's name from Firestore
      final userDoc = await FirebaseFirestore.instance.collection("users").doc(user.uid).get();
      final userName = userDoc.data()?['name'] ?? "Unknown";

      final data = await FirebaseFirestore.instance.collection("news").add({
        "title": _titlecontroller.text.trim(),
        "content": _contentcontroller.text.trim(),
        "image": imageUrl,
        "Author": userName,
        "Date": FieldValue.serverTimestamp(),
        "approve": "pending"
      });
      print("News uploaded with ID: ${data.id}");
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("News posted successfully!")));
    } catch (e) {
      print("Error uploading news: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to post news: $e")));
    }
  }

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
              ImagePost(
                onImageUpload: (url) {
                  setState(() {
                    _imageUrl = url;
                  });
                },
              ),
              const SizedBox(height: 20),
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
              const SizedBox(height: 20),
              SizedBox(
                height: 280, // Adjust height for the content box
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
              ElevatedButton.icon(
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Confirm to Post"),
                          content: const Text(
                              "Your content of news will be uploaded"),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                final imageUrlToUse =
                                    _imageUrl ?? _defaultImageUrl;

                                await uploadNewsToDb(imageUrlToUse);

                                Navigator.pop(context); // Close the dialog
                              },
                              child: const Text("OK"),
                            ),
                          ],
                        );
                      });
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Theme.of(context).colorScheme.tertiary,
                ),
                label: const Text("POST",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                icon: const Icon(
                  Icons.send,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
