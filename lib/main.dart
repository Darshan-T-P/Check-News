import 'package:check_news/firebase_options.dart';
import 'package:check_news/home_page.dart';

import 'package:check_news/services/firebase_auth_method.dart'; // Import your FirebaseAuthMethod class
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import the provider package

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthMethod>(
          create: (_) => FirebaseAuthMethod(FirebaseAuth.instance),
        ),
       
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color.fromRGBO(56, 120, 38, 1),
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
        home: HomePage(),
      ),
    );
  }
}
