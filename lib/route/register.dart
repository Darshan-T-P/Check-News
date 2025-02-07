import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool showProgress = false;
  final _formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpassController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  bool _isObscure = true;
  bool _isObscure2 = true;

  var options = ['User', 'Admin'];
  var _currentItemSelected = "User";
  var role = "User";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 80),
                const Text(
                  "Register Now",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 40,
                  ),
                ),
                const SizedBox(height: 50),
                buildTextField(nameController, "Name", TextInputType.name),
                const SizedBox(height: 20),
                buildTextField(mobileController, "Phone", TextInputType.phone),
                const SizedBox(height: 20),
                buildTextField(
                    emailController, "Email", TextInputType.emailAddress),
                const SizedBox(height: 20),
                buildPasswordField(passwordController, "Password", _isObscure,
                    () {
                  setState(() => _isObscure = !_isObscure);
                }),
                const SizedBox(height: 20),
                buildPasswordField(
                    confirmpassController, "Confirm Password", _isObscure2, () {
                  setState(() => _isObscure2 = !_isObscure2);
                }),
                const SizedBox(height: 20),
                buildRoleDropdown(),
                const SizedBox(height: 20),
                buildButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      TextEditingController controller, String hint, TextInputType type) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      ),
      keyboardType: type,
      validator: (value) =>
          value!.trim().isEmpty ? "$hint cannot be empty" : null,
    );
  }

  Widget buildPasswordField(TextEditingController controller, String hint,
      bool isObscure, VoidCallback toggle) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility),
          onPressed: toggle,
        ),
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      ),
      validator: (value) {
        if (value!.trim().isEmpty) return "$hint cannot be empty";
        if (hint == "Confirm Password" && value != passwordController.text) {
          return "Passwords do not match";
        }
        return null;
      },
    );
  }

  Widget buildRoleDropdown() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Role : ",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        DropdownButton<String>(
          dropdownColor: Colors.blue[900],
          iconEnabledColor: Colors.white,
          items: options
              .map((String item) =>
                  DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: (newValue) => setState(() {
            _currentItemSelected = newValue!;
            role = newValue;
          }),
          value: _currentItemSelected,
        ),
      ],
    );
  }

  Widget buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildButton(
            "Login",
            () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => LoginPage()))),
        buildButton("Register", signUp),
      ],
    );
  }

  Widget buildButton(String text, VoidCallback onPressed) {
    return MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      elevation: 5.0,
      height: 40,
      onPressed: onPressed,
      color: Colors.white,
      child: Text(text, style: const TextStyle(fontSize: 20)),
    );
  }

  void signUp() async {
    if (_formkey.currentState!.validate()) {
      setState(() => showProgress = true);
      try {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        await Future.delayed(Duration(seconds: 2));
        postDetailsToFirestore(userCredential.user);
      } on FirebaseAuthException catch (e) {
        setState(() => showProgress = false);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.message ?? "Registration failed")));
      }
    }
  }

  void postDetailsToFirestore(User? user) async {
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': nameController.text.trim(),
        'phone': mobileController.text.trim(),
        'email': emailController.text.trim(),
        'role': role,
      });
       await _auth.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (Route<dynamic> route) => false,
      );
    }
  }
}
