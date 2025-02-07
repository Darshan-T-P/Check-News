import 'package:check_news/services/storage/storage_services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:check_news/services/authprovider.dart';
import 'package:check_news/admin_home.dart';
import 'package:check_news/home_page.dart';
import 'package:check_news/route/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: ".env");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),  // 🔹 Provides Auth State
        ChangeNotifierProvider(create: (_) => StorageServices()) // Storage service
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
          titleMedium: TextStyle(fontFamily: 'EBGaramond', fontSize: 32, fontWeight: FontWeight.bold),
          titleSmall: TextStyle(fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(fontWeight: FontWeight.bold, fontSize: 32, color: Colors.black),
          headlineSmall: TextStyle(fontFamily: 'EBGaramond', fontWeight: FontWeight.normal, fontSize: 32),
          bodyLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      routes: {
        '/home': (context) => HomePage(),
        '/AdminHome': (context) => AdminHome(),
      },
      home: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          if (authProvider.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (!authProvider.isLoggedIn) {
            return LoginPage();
          }

          return authProvider.role == 'Admin' ? AdminHome() : HomePage();
        },
      ),
    );
  }
}
