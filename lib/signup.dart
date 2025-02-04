import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class UploadImage extends StatefulWidget {
  const UploadImage({super.key});

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  @override
  Widget build(BuildContext context) {
    final selectedFile=ModalRoute.of(context)!.settings.arguments as FilePickerResult;
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload"),
      ),
      
    );
  }
}
