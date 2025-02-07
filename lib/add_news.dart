import 'package:check_news/select_image.dart';
import 'package:check_news/services/storage/storage_services.dart';
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
