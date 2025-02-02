import 'package:check_news/services/firebase_auth_method.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PhoneScreen extends StatefulWidget {
  static String routeName = '/phone';
  const PhoneScreen({super.key});

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final TextEditingController phoneController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: phoneController,
            // hintText: 'Enter phone number',
          ),
          IconButton(
            onPressed: () {
              context
                  .read<FirebaseAuthMethods>()
                  .phoneSignIn(context, phoneController.text);
            },
            icon: Icon(Icons.one_k),
          ),
        ],
      ),
    );
  }
}