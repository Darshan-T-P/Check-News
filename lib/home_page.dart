import 'package:check_news/add_news.dart';
import 'package:check_news/bookmars.dart';
import 'package:check_news/global_news.dart';
import 'package:check_news/news_list.dart';
import 'package:check_news/profile_pages.dart';
import 'package:check_news/search_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  // Pages corresponding to bottom navigation bar
  final List<Widget> pages = [
    NewsList(),
    SearchPage(newsList: news),
    ProfilePages(),
    BookmarksPages(),
  ];

  final List<Widget> _navigationItem = [
    const Icon(Icons.home, color: Colors.white),
    const Icon(Icons.search, color: Colors.white),
    const Icon(Icons.person, color: Colors.white),
    const Icon(Icons.bookmark, color: Colors.white),
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: currentPage == 0, // Allow back navigation only if on home page
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          if (currentPage != 0) {
            setState(() {
              currentPage = 0; // Go back to the home screen instead of exiting
            });

            // Update the bottom navigation bar to reflect the home screen
            _bottomNavigationKey.currentState?.setPage(0);
          }
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: pages[currentPage], // Display the selected page dynamically
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
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
            key: _bottomNavigationKey, // Add key for state tracking
            backgroundColor: Theme.of(context).colorScheme.tertiary,
            color: const Color.fromRGBO(3, 15, 15, 1),
            items: _navigationItem,
            height: 60,
            index: currentPage, // Set the current index
            animationDuration: const Duration(milliseconds: 500),
            onTap: (index) {
              setState(() {
                currentPage = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
