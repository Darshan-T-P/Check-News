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
  bool visible = false;
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
      backgroundColor: Colors.orange[900],
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.orangeAccent[700],
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.all(12),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 80),
                        Text(
                          "Register Now",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 40,
                          ),
                        ),
                        SizedBox(height: 50),
                        buildTextField(nameController, "Name", TextInputType.name),
                        SizedBox(height: 20),
                        buildTextField(mobileController, "Phone", TextInputType.phone),
                        SizedBox(height: 20),
                        buildTextField(emailController, "Email", TextInputType.emailAddress),
                        SizedBox(height: 20),
                        buildPasswordField(passwordController, "Password", _isObscure, () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        }),
                        SizedBox(height: 20),
                        buildPasswordField(confirmpassController, "Confirm Password", _isObscure2, () {
                          setState(() {
                            _isObscure2 = !_isObscure2;
                          });
                        }),
                        SizedBox(height: 20),
                        buildRoleDropdown(),
                        SizedBox(height: 20),
                        buildButtons(),
                        SizedBox(height: 20),
                        Text(
                          "WEBFUN",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.yellowAccent[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String hint, TextInputType type) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(20),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      keyboardType: type,
      validator: (value) => value!.isEmpty ? "$hint cannot be empty" : null,
    );
  }

  Widget buildPasswordField(TextEditingController controller, String hint, bool isObscure, VoidCallback toggle) {
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
        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(20),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      validator: (value) => value!.length < 6 ? "Minimum 6 characters required" : null,
    );
  }

  Widget buildRoleDropdown() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Role : ",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        DropdownButton<String>(
          dropdownColor: Colors.blue[900],
          isDense: true,
          iconEnabledColor: Colors.white,
          items: options.map((String dropDownStringItem) {
            return DropdownMenuItem<String>(
              value: dropDownStringItem,
              child: Text(
                dropDownStringItem,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
              ),
            );
          }).toList(),
          onChanged: (newValueSelected) {
            setState(() {
              _currentItemSelected = newValueSelected!;
              role = newValueSelected;
            });
          },
          value: _currentItemSelected,
        ),
      ],
    );
  }

  Widget buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildButton("Login", () => Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()))),
        buildButton("Register", () {
          setState(() => showProgress = true);
          signUp();
        }),
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
      child: Text(text, style: TextStyle(fontSize: 20)),
    );
  }

  void signUp() async {
    if (_formkey.currentState!.validate()) {
      await _auth.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text)
          .then((value) => postDetailsToFirestore());
    }
  }

  postDetailsToFirestore() async {
    FirebaseFirestore.instance.collection('users').doc(_auth.currentUser!.uid).set({
      'name': nameController.text,
      'phone': mobileController.text,
      'email': emailController.text,
      'role': role,
    });
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
  }
}
