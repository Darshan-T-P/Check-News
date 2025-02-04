import 'package:check_news/add_news.dart';
import 'package:check_news/bookmars.dart';
import 'package:check_news/global_news.dart';
import 'package:check_news/news_list.dart';
import 'package:check_news/profile_pages.dart';
import 'package:check_news/search_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;

  // Pages corresponding to bottom navigation bar
  final List<Widget> pages = [
    NewsList(),
    SearchPage(newsList: news,),
    AddNews(),
    ProfilePages(),
    BookmarksPages(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // drawer: Drawer(
        //   child: Column(
        //     children: [
        //       const DrawerHeader(
        //         padding: EdgeInsets.all(20),
        //         margin: EdgeInsets.all(10),
        //         child: Text(
        //           "Profile",
        //           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        //         ),
        //       ),
        //       ListTile(
        //         title: const Text("Add Content"),
        //         leading: const Icon(Icons.add),
        //         onTap: () {
        //           Navigator.push(
        //             context,
        //             MaterialPageRoute(builder: (context) => AddNews()),
        //           );
        //         },
        //       ),
        //       ListTile(
        //         title: const Text("Settings"),
        //         leading: const Icon(Icons.settings),
        //         onTap: () {
        //           // Navigate to Settings Page (add your page here)
        //         },
        //       ),
        //       ListTile(
        //         title: const Text("Log out"),
        //         leading: const Icon(Icons.logout),
        //         onTap: () {
        //           context.read<FirebaseAuthMethod>().signOut(context);
        //           // Implement logout functionality here
        //         },
        //       )
        //     ],
        //   ),
        // ),

        body: pages[currentPage], // Display the selected page dynamically
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          currentIndex: currentPage,
          onTap: (value) {
            setState(() {
              currentPage = value;
            });
          },
          selectedIconTheme: const IconThemeData(
            color:
                Color.fromRGBO(0, 223, 130, 1), // Icon color for selected items
          ),
          unselectedIconTheme: const IconThemeData(
            color:
                Color.fromRGBO(3, 98, 76, 1), // Icon color for unselected items
          ),
          selectedItemColor:
              Color.fromRGBO(0, 223, 130, 1), // Label color for selected items
          unselectedItemColor:
              Color.fromRGBO(3, 98, 76, 1), // Label color for unselected items
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold, // Styling for selected labels
            fontSize: 14,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12, // Styling for unselected labels
          ),
          type: BottomNavigationBarType.fixed, // Keeps all items visible
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_rounded),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.add_circle_outline_rounded,
                size: 30,
              ),
              label: 'Add',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark),
              label: 'Bookmarks',
            ),
          ],
        ),
      ),
    );
  }
}
