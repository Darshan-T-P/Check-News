// import 'package:check_news/services/firebase_auth_method.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class EmailPasswordSignup extends StatefulWidget {
//   static String routeName = '/signup-email-password';
//   const EmailPasswordSignup({super.key});

//   @override
//   _EmailPasswordSignupState createState() => _EmailPasswordSignupState();
// }

// class _EmailPasswordSignupState extends State<EmailPasswordSignup> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();


//   void signUpUser() async {
//     context.read<FirebaseAuthMethods>().signUpWithEmail(
//           email: emailController.text,
//           password: passwordController.text,
//           context: context,
//         );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Text(
//             "Sign Up",
//             style: TextStyle(fontSize: 30),
//           ),
//           SizedBox(height: MediaQuery.of(context).size.height * 0.08),
//           Container(
//             margin: const EdgeInsets.symmetric(horizontal: 20),
//             child: TextField(
//               controller: emailController,
             
//             ),
//           ),
//           const SizedBox(height: 20),
//           Container(
//             margin: const EdgeInsets.symmetric(horizontal: 20),
//             child:TextField(
//               controller: passwordController,
              
//             ),
//           ),
//           const SizedBox(height: 40),
//           ElevatedButton(
//             onPressed: signUpUser,
//             style: ButtonStyle(
//               backgroundColor: WidgetStateProperty.all(Colors.blue),
//               textStyle: WidgetStateProperty.all(
//                 const TextStyle(color: Colors.white),
//               ),
//               minimumSize: WidgetStateProperty.all(
//                 Size(MediaQuery.of(context).size.width / 2.5, 50),
//               ),
//             ),
//             child: const Text(
//               "Sign Up",
//               style: TextStyle(color: Colors.white, fontSize: 16),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String phoneNo, smsSent, verificationId;
  final _auth = FirebaseAuth.instance;

  Future<void> verifyPhone() async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNo,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Automatically signs in the user
        await _auth.signInWithCredential(credential);
        showSnackBar("Phone number verified and signed in!");
      },
      verificationFailed: (FirebaseAuthException e) {
        showSnackBar("Verification failed: ${e.message}");
      },
      codeSent: (String verId, int? resendToken) {
        verificationId = verId;
        smsCodeDialog(context).then((value) {
          print("OTP dialog displayed.");
        });
      },
      codeAutoRetrievalTimeout: (String verId) {
        verificationId = verId;
      },
    );
  }

  Future<void> signIn(String smsCode) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      await _auth.signInWithCredential(credential);
      showSnackBar("Successfully signed in!");
      // Navigate to another page
    } catch (e) {
      showSnackBar("Error signing in: $e");
    }
  }

  Future smsCodeDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter OTP'),
          content: TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              smsSent = value;
            },
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                signIn(smsSent);
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Phone Authentication')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                hintText: "Enter your phone number (+1234567890)",
              ),
              keyboardType: TextInputType.phone,
              onChanged: (value) {
                phoneNo = value;
              },
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: verifyPhone,
              child: Text("Verify"),
            ),
          ],
        ),
      ),
    );
  }
}
