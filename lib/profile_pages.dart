import 'package:check_news/utils/custom_panter.dart';
import 'package:flutter/material.dart';

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
          title: Text("Change Name:"),
          content: TextField(
            controller: _changenamecontroller,
            autofocus: true,
            decoration: InputDecoration(hintText: "Enter your name"),
            onSubmitted: (_) => submit(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                submit();
              },
              child: Text("Done"),
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: () async {
                  final name = await editName();
                  if (name == null || name.isEmpty) return;
                  setState(() {
                    this.name = name;
                  });
                },
                icon: Icon(Icons.edit)),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
        child: Column(
          children: [
            Container(
              height: height * 0.6,
              width: width * 0.85,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                    colors: [
                      Colors.green.shade900,
                      Colors.green.shade700,
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: CustomPaint(
                  size: Size(width, height),
                  painter: CardCustomPainter(),
                  child: Stack(
                    children: [
                      // Image Overlay
                      Positioned(
                        bottom: 25,
                        left: 15,
                        child: Opacity(
                          opacity: 0.3, // Adjust opacity for the overlay
                          child: Image.asset(
                            'assets/images/img.png',
                            width: width * 0.7,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      // Content inside the container (you can add more content here)
                      Column(
                        children: [
                          // Profile content goes here
                          SizedBox(height: 40),
                          Center(
                            child: CircleAvatar(
                              radius: 90,
                              backgroundImage:
                                  AssetImage('assets/images/shoes_3.png'),
                              backgroundColor: Colors.grey.shade300,
                            ),
                          ),

                          SizedBox(height: 110),
                          detailWidget(Icons.person, name),
                          detailWidget(Icons.phone, "+91-9043072213"),
                          detailWidget(Icons.publish_rounded, "300 Posts"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Log Out Button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              child: Container(
                width: 160,
                height: 70,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  label: const Text("Log Out"),
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget detailWidget(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 75, vertical: 5),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 50,
              ),
              SizedBox(width: 20),
              Text(
                text,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
              ),
            ],
          )
        ],
      ),
    );
  }
}
