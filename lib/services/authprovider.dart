import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  firebase_auth.User? _user;
  String _role = 'User'; // Default role
  bool _isLoading = true;

  firebase_auth.User? get user => _user;
  String get role => _role;
  bool get isLoggedIn => _user != null;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _checkUser(); // Check user state when AuthProvider is created
  }

  Future<void> _checkUser() async {
    firebase_auth.FirebaseAuth.instance
        .authStateChanges()
        .listen((firebase_auth.User? user) async {
      _user = user;
      if (_user != null) {
        // Fetch stored role first for fast loading
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? savedRole = prefs.getString('user_role');

        if (savedRole != null) {
          _role = savedRole;
        } else {
          await _fetchUserRole();
        }
      }
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> _fetchUserRole() async {
    if (_user == null) return;

    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_user!.uid)
        .get();

    if (documentSnapshot.exists) {
      _role = documentSnapshot.get('role') ?? 'User';

      // Store the role in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_role', _role);
    } else {
      _role = 'User';
    }
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    try {
      firebase_auth.UserCredential userCredential =
          await firebase_auth.FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user;

      if (_user != null) {
        await _fetchUserRole(); // Fetch role after login
      }
      notifyListeners();
    } catch (e) {
      rethrow; // Handle errors as needed
    }
  }

  Future<void> signOut(BuildContext context) async {
    await firebase_auth.FirebaseAuth.instance.signOut();
    _user = null;
    _role = 'User'; // Reset role on logout

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_role'); // Clear stored role
    notifyListeners();
  }
}

// import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
// import 'package:flutter/material.dart';

// class AuthProvider with ChangeNotifier {
//   firebase_auth.User? _user;
//   bool _isLoggedIn = false;

//   firebase_auth.User? get user => _user;
//   bool get isLoggedIn => _isLoggedIn;

//   // Initialize FirebaseAuth and check if the user is already logged in
//   AuthProvider() {
//     _checkUserAuthState();
//   }

//   Future<void> _checkUserAuthState() async {
//     try {
//       firebase_auth.FirebaseAuth.instance.authStateChanges().listen((firebase_auth.User? user) {
//         if (user != null) {
//           _user = user;
//           _isLoggedIn = true;
//         } else {
//           _user = null;
//           _isLoggedIn = false;
//         }
//         notifyListeners();
//       });
//     } catch (e) {
//       print("Error checking auth state: $e");
//     }
//   }

//   // Sign-in method
//   Future<void> signIn(String email, String password) async {
//     try {
//       firebase_auth.UserCredential userCredential = await firebase_auth.FirebaseAuth.instance
//           .signInWithEmailAndPassword(email: email, password: password);
//       _user = userCredential.user;
//       _isLoggedIn = true;
//       notifyListeners();
//     } catch (e) {
//       throw e;
//     }
//   }

//   // Sign-out method
//   Future<void> signOut() async {
//     await firebase_auth.FirebaseAuth.instance.signOut();
//     _user = null;
//     _isLoggedIn = false;
//     notifyListeners();
//   }
// }
