import 'package:check_news/services/authprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePages extends StatefulWidget {
  const ProfilePages({super.key});

  @override
  State<ProfilePages> createState() => _ProfilePagesState();
}

class _ProfilePagesState extends State<ProfilePages> {
  late final TextEditingController _changenamecontroller =
      TextEditingController();
  String name = '';

  @override
  void dispose() {
    _changenamecontroller.dispose();
    super.dispose();
  }

  void submit() {
    Navigator.of(context).pop(_changenamecontroller.text);
    _changenamecontroller.clear();
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

  // Function to show a confirmation dialog before logging out
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
                Navigator.of(context).pop(false);  // Cancel the logout
              },
            ),
            TextButton(
              child: const Text("Log Out"),
              onPressed: () {
                Navigator.of(context).pop(true);  // Confirm logout
              },
            ),
          ],
        );
      },
    );

    if (shouldLogout ?? false) {
      // Use AuthProvider to handle sign-out
      await context.read<AuthProvider>().signOut(context);  // Call sign-out from AuthProvider
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
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
              setState(() {
                this.name = name;
              });
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
              // Profile Picture
              Center(
                child: CircleAvatar(
                  radius: 80,
                  backgroundImage:
                      const AssetImage('assets/images/shoes_3.png'),
                  backgroundColor: Colors.grey.shade300,
                ),
              ),
              const SizedBox(height: 40),

              // User Details Card
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
                    ]), 
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      detailWidget(
                          Icons.person, name.isNotEmpty ? name : "Your Name"),
                      const SizedBox(height: 25),
                      detailWidget(Icons.phone, "+91-9876543210"),
                      const SizedBox(height: 25),
                      detailWidget(Icons.publish_rounded, "300 Posts"),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Log Out Button
              ElevatedButton.icon(
                onPressed: _confirmLogout,  // Trigger logout confirmation
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
