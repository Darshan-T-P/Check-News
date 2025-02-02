// import 'package:check_news/screens/login_emaipassword.dart';
// import 'package:check_news/screens/sign.dart';
// import 'package:check_news/signup.dart';
// import 'package:flutter/material.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({Key? key}) : super(key: key);

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pushNamed(context, EmailPasswordSignup.routeName);
//               },
//               child:Text('Email/Password Sign Up') ,
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pushNamed(context, EmailPasswordLogin.routeName);
//               },
//               child:Text('Email/Password Login') ,
//             ),
//            TextButton(
//                 onPressed: () {
//                   Navigator.pushNamed(context, PhoneScreen.routeName);
//                 },
//                 child: Text('Phone Sign In')),
            
            
//           ],
//         ),
//       ),
//     );
//   }
// }