import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:check_news/services/authprovider.dart';
import 'package:check_news/admin_home.dart';
import 'package:check_news/home_page.dart';
import 'package:check_news/route/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromRGBO(3, 98, 76, 1),
          primary: Color.fromRGBO(3, 15, 15, 1),
          secondary: Color.fromRGBO(0, 223, 130, 1),
          tertiary: Color.fromRGBO(3, 98, 76, 1),
        ),
        useMaterial3: true,
        textTheme: const TextTheme(
          titleMedium: TextStyle(
            fontFamily: 'EBGaramond',
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
          titleSmall: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          headlineMedium: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 32,
            color: Colors.black,
          ),
          headlineSmall: TextStyle(
            fontFamily: 'EBGaramond',
            fontWeight: FontWeight.normal,
            fontSize: 32,
          ),
          bodyLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          if (authProvider.user == null) {
            return LoginPage(); // Show LoginPage if user is not logged in
          }

          // Check role and navigate accordingly
          if (authProvider.role == 'User') {
            return HomePage(); // Navigate to HomePage if role is 'User'
          } else if (authProvider.role == 'Admin') {
            return AdminHome(); // Navigate to AdminHome if role is 'Admin'
          } else {
            return Center(child: CircularProgressIndicator()); // Show loading while fetching role
          }
        },
      ),
    );
  }
}

