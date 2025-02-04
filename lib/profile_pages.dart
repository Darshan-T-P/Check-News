import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:check_news/services/authprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePages extends StatefulWidget {
  const ProfilePages({super.key});

  @override
  State<ProfilePages> createState() => _ProfilePagesState();
}

class _ProfilePagesState extends State<ProfilePages> {
  FilePickerResult? _filePickerResult;

  void _openFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      allowedExtensions: ["jpg", "jpeg", "png", "mp4"],
      type: FileType.custom,
    );
    setState(() {
      _filePickerResult = result;
    });
  }

  late final TextEditingController _changenamecontroller =
      TextEditingController();
  String name = '';
  String phone = '';
  final user = firebase_auth.FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  void dispose() {
    _changenamecontroller.dispose();
    super.dispose();
  }

  Future<void> _fetchUserData() async {
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user!.uid).get();
      if (doc.exists) {
        setState(() {
          name = doc['name'] ?? 'Your Name';
          phone = doc['phone'] ?? 'Not Provided';
        });
      }
    }
  }

  Future<void> _updateName(String newName) async {
    if (user != null) {
      await _firestore.collection('users').doc(user!.uid).update({
        'name': newName,
      });
      setState(() {
        name = newName;
      });
    }
  }

  Future<String?> editName() => showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Change Name:"),
          content: TextField(
            controller: _changenamecontroller,
            autofocus: true,
            decoration: const InputDecoration(hintText: "Enter your name"),
            onSubmitted: (_) => submit(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                submit();
              },
              child: const Text("Done"),
            )
          ],
        ),
      );

  void submit() {
    final newName = _changenamecontroller.text.trim();
    if (newName.isNotEmpty) {
      _updateName(newName);
    }
    Navigator.of(context).pop();
    _changenamecontroller.clear();
  }

  Future<void> _confirmLogout() async {
    bool? shouldLogout = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Logout"),
          content: const Text("Are you sure you want to log out?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text("Log Out"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (shouldLogout ?? false) {
      await context.read<AuthProvider>().signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);

        // Determine the correct home page based on user role
        String homeRoute = authProvider.role == 'Admin' ? '/admin_home' : '/home';

        // Navigate to home screen and prevent default back navigation
        Navigator.pushReplacementNamed(context, homeRoute);

        return Future.value(false); // Prevents page from closing
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: const Text(
            "My Profile",
            style: TextStyle(color: Color.fromRGBO(0, 223, 130, 1)),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () async {
                final name = await editName();
                if (name == null) return;
              },
              icon: const Icon(Icons.edit),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 80,
                        // backgroundImage: const AssetImage('assets/images/shoes_3.png'),
                        backgroundColor: Colors.grey.shade300,
                        child: Icon(
                          Icons.person,
                          size: 120,
                        ),
                      ),
                    ),
                    Positioned(
                        left: 120,
                        bottom: 6,
                        child: GestureDetector(
                          onTap: () async {},
                          child: Icon(
                            Icons.add_a_photo,
                            size: 30,
                            color: Colors.black,
                          ),
                        )),
                  ],
                ),
                const SizedBox(height: 40),
                Container(
                  height: height * 0.3,
                  width: width * 0.85,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromRGBO(0, 223, 130, 1),
                        Color.fromRGBO(3, 98, 76, 1),
                        Color.fromRGBO(3, 15, 15, 1)
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        detailWidget(Icons.person, name),
                        const SizedBox(height: 25),
                        detailWidget(Icons.phone, phone),
                        const SizedBox(height: 25),
                        detailWidget(Icons.publish_rounded, "300 Posts"),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _confirmLogout,
                  label: const Text("Log Out"),
                  icon: const Icon(Icons.logout),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 24,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget detailWidget(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 30,
          color: Theme.of(context).colorScheme.tertiary,
        ),
        const SizedBox(width: 16),
        Text(
          text,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ],
    );
  }
}
