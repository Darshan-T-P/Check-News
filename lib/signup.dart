// import 'package:check_news/services/firebase_auth_method.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpWithMobile extends StatefulWidget {
  const SignUpWithMobile({super.key});

  @override
  State<SignUpWithMobile> createState() => _SignUpWithMobileState();
}

class _SignUpWithMobileState extends State<SignUpWithMobile> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void phoneSignIn() {
    final phoneNumber = "+91${_phoneController.text.trim()}";

    if (phoneNumber.isEmpty || _phoneController.text.trim().length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid 10-digit mobile number.")),
      );
      return;
    }

    // FirebaseAuthMethod(FirebaseAuth.instance).phoneSignIn(context, phoneNumber);
  }

  @override
  Widget build(BuildContext context)  {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up with Mobile"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 100),
            // Mobile Number Input
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Mobile Number",
                prefixText: "+91 ", // Country code prefix
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Send OTP Button
            ElevatedButton(
              onPressed:()async{ await FirebaseAuth.instance.verifyPhoneNumber(
  phoneNumber: '+91 904 307 2213',
  verificationCompleted: (PhoneAuthCredential credential) {},
  verificationFailed: (FirebaseAuthException e) {},
  codeSent: (String verificationId, int? resendToken) {},
  codeAutoRetrievalTimeout: (String verificationId) {},
);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text("Send OTP"),
            ),
          ],
        ),
      ),
    );
  }
}
