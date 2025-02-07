import 'package:check_news/add_news.dart';
import 'package:check_news/admin_page.dart';
import 'package:check_news/bookmars.dart';
import 'package:check_news/news_list.dart';
import 'package:check_news/profile_pages.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
int currentPage = 0;

  // Pages corresponding to bottom navigation bar
  final List<Widget> pages = [
    NewsList(),
    AdminPage(),
    ProfilePages(),
    BookmarksPages(),
  ];

  final List<Widget> _navigationItem = [
    const Icon(Icons.home, color: Colors.white),
    const Icon(Icons.person_pin_sharp, color: Colors.white),
    const Icon(Icons.person, color: Colors.white),
    const Icon(Icons.bookmark, color: Colors.white),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: pages[currentPage], // Display the selected page dynamically
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          elevation: 6.0, // Gives a floating effect
          splashColor: Colors.green.withOpacity(0.3), // Soft ripple effect
          highlightElevation: 10.0, // Increases elevation on press
          backgroundColor: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddNews()),
            );
          },
          child: const Icon(Icons.add,
              color: Colors.black, size: 30), // Bigger icon
        ),
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          color: const Color.fromRGBO(3, 15, 15, 1),
          items: _navigationItem,
          height: 60,
          animationDuration: const Duration(milliseconds: 500),
          onTap: (index) {
            setState(() {
              currentPage = index;
            });
          },
        ),
      ),
    );
  }
}
