import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class StorageServices with ChangeNotifier {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final List<String> _imageUrl = [];

  List<String> get imageUrl => _imageUrl;

  /// Uploads an image to Firebase Storage and returns the download URL.
  Future<String> uploadImage(File image) async {
    try {
      // Create a unique filename for the image
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = _storage.ref().child("news_images/$fileName");

      // Upload the file
      UploadTask uploadTask = ref.putFile(image);
      TaskSnapshot snapshot = await uploadTask;

      // Get the download URL
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Save the URL in the local list
      _imageUrl.add(downloadUrl);
      notifyListeners();

      return downloadUrl;
    } catch (e) {
      debugPrint("Error uploading image: $e");
      throw Exception("Failed to upload image");
    }
  }

  uploadLocalImage(String defaultImage) {}
}
