import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CloudinaryService {
  Future<String?> uploadToCloudinary(
      FilePickerResult filePickerResult, String newsId) async {
    if (filePickerResult.files.isEmpty ||
        filePickerResult.files.single.path == null) {
      print("No files selected or invalid path");
      return null;
    }

    File file = File(filePickerResult.files.single.path!);

    // Load Cloudinary credentials
    String cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
    String uploadPreset = dotenv.env['CLOUDINARY_UPLOAD_PRESET'] ?? '';

    if (cloudName.isEmpty || uploadPreset.isEmpty) {
      print("Cloudinary credentials are missing");
      return null;
    }

    var uri =
        Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");

    var request = http.MultipartRequest("POST", uri);

    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    // Add required fields
    request.fields['upload_preset'] = uploadPreset;

    request.fields['folder'] ="news/$newsId"; 
    request.fields['timestamp'] =(DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
    request.fields['expires_at'] =((DateTime.now().add(Duration(days: 40)).millisecondsSinceEpoch ~/1000)).toString();
    try {
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseBody);

      if (response.statusCode == 200) {
        String imageUrl = jsonResponse['secure_url'];
        print("Upload successful: $imageUrl");
        return imageUrl;
      } else {
        print("Upload failed: ${response.statusCode}, Response: $jsonResponse");
        return null;
      }
    } catch (e) {
      print("Error uploading to Cloudinary: $e");
      return null;
    }
  }

  Future<bool> deleteFromCloudinary(String publicId) async {
  String cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
  String apiKey = dotenv.env['CLOUDINARY_API_KEY'] ?? '';
  String apiSecret = dotenv.env['CLOUDINARY_API_SECRET'] ?? '';

  if (cloudName.isEmpty || apiKey.isEmpty || apiSecret.isEmpty) {
    print("Cloudinary credentials are missing");
    return false;
  }

  var url = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/destroy");

  var response = await http.post(url, body: {
    'public_id': publicId,
    'api_key': apiKey,
    'api_secret': apiSecret,
  });

  if (response.statusCode == 200) {
    print("Successfully deleted: $publicId");
    return true;
  } else {
    print("Failed to delete: $publicId");
    return false;
  }
}

}
