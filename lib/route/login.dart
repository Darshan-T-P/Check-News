import 'package:check_news/admin_home.dart';
import 'package:check_news/home_page.dart';
import 'package:check_news/route/register.dart';
import 'package:check_news/services/authprovider.dart'; // Your custom AuthProvider
import 'package:check_news/utils/showSnackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Alias for Firebase Auth

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscure3 = true;
  bool visible = false;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    
     firebase_auth.FirebaseAuth.instance.authStateChanges().listen((firebase_auth.User? user) {
    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()), // Replace with your home screen
      );
    }
  });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              color: Theme.of(context).colorScheme.secondary,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.70,
              child: Center(
                child: Container(
                  margin: EdgeInsets.all(12),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 30),
                        Text("Login", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 40)),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(hintText: 'Email'),
                          validator: (value) {
                            if (value!.isEmpty) return "Email cannot be empty";
                            if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
                              return "Please enter a valid email";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: passwordController,
                          obscureText: _isObscure3,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(_isObscure3 ? Icons.visibility : Icons.visibility_off),
                              onPressed: () => setState(() => _isObscure3 = !_isObscure3),
                            ),
                            hintText: 'Password',
                          ),
                          validator: (value) {
                            if (value!.isEmpty) return "Password cannot be empty";
                            if (value.length < 6) return "Password must be at least 6 characters";
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        MaterialButton(
                          onPressed: () {
                            if (_formkey.currentState!.validate()) {
                              signIn(emailController.text, passwordController.text);
                            }
                          },
                          color: Colors.white,
                          child: Text("Login"),
                        ),
                        Visibility(
                          visible: visible,
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.white,
              child: MaterialButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Register()));
                },
                color: Colors.blue[900],
                child: Text("Register Now", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // void signIn(String email, String password) async {
  //   final authProvider = Provider.of<AuthProvider>(context, listen: false);
  //   try {
  //     await authProvider.signIn(email, password);
  //     if (authProvider.user != null) {
  //       route();
  //     }
  //   } on firebase_auth.FirebaseAuthException catch (e) {
  //     showSnackBar(context, e.message!);
  //   }
  // }


void signIn(String email, String password) async {
  final authProvider = Provider.of<AuthProvider>(context, listen: false);
  try {
    await authProvider.signIn(email, password);
    firebase_auth.User? user = firebase_auth.FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Fetch user role from Firestore
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) {
        String role = doc.get('role'); // Ensure it's "role", not "rool"

        // Save role in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userRole', role);

        // Navigate based on role
        if (role == "Admin") {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminHome()));
        } else {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
        }
      }
    }
  } on firebase_auth.FirebaseAuthException catch (e) {
    showSnackBar(context, e.message!);
  }
}



  void route() {
    firebase_auth.User? user = firebase_auth.FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance.collection('users').doc(user!.uid).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if (documentSnapshot.get('rool') == "Admin") {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminHome()));
        } else {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
        }
      } else {
        print('Document does not exist on the database');
      }
    });
  }
}
