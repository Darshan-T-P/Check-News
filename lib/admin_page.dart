import 'package:check_news/news_details_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage>
    with SingleTickerProviderStateMixin {
  int totalUsers = 0;
  int totalPosts = 0;
  late AnimationController _controller;
  late Animation<int> _userAnimation;
  late Animation<int> _postAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Fetch and animate total users
    FirebaseFirestore.instance.collection('users').get().then((snapshot) {
      int count = snapshot.docs.length;
      _userAnimation = IntTween(begin: 0, end: count).animate(_controller)
        ..addListener(() {
          setState(() {
            totalUsers = _userAnimation.value;
          });
        });
      _controller.forward();
    });

    // Fetch and animate total posts
    FirebaseFirestore.instance.collection('news')
    .where('approve',isEqualTo: 'approved')
    .get().then((snapshot) {
      int count = snapshot.docs.length;
      _postAnimation = IntTween(begin: 0, end: count).animate(_controller)
        ..addListener(() {
          setState(() {
            totalPosts = _postAnimation.value;
          });
        });
      _controller.forward();
    });
  }

  // Function to approve news
  Future<void> _approveNews(String newsId) async {
    await FirebaseFirestore.instance.collection("news").doc(newsId).update({
      'approve': 'approved',
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("News item approved successfully")),
    );
  }

  // Function to delete news
  Future<void> _rejectNews(String newsId) async {
    await FirebaseFirestore.instance.collection("news").doc(newsId).delete();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("News item deleted successfully")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageTransition(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Admin Panel",
            style: TextStyle(color: Color.fromRGBO(0, 223, 130, 1)),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              // **Admin Dashboard Card with Animated Numbers**
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Theme.of(context).colorScheme.secondary,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Total Users",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            "$totalUsers",
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Total Posts",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            "$totalPosts",
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // **Pending News Section**
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 16.0, top: 10),
                  child: Text(
                    "Pending News",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 5),

              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('news').where(
                      'approve',
                      whereIn: ['pending', 'waiting']).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text("No pending news updates"),
                      );
                    }

                    List<Map<String, dynamic>> newsList =
                        snapshot.data!.docs.map((doc) {
                      var data = doc.data() as Map<String, dynamic>;

                      return {
                        "title": data["title"] ?? "Untitled",
                        "author": data["author"] ?? "Unknown",
                        "id": doc.id,
                      };
                    }).toList();

                    return ListView.builder(
                      itemCount: newsList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  NewsDetailsPage(id: newsList[index]['id']),
                            ));
                          },
                          child: Dismissible(
                            key: Key(newsList[index]['id']),
                            background: Container(
                              color: Colors.green,
                              alignment: Alignment.centerLeft,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child:
                                  const Icon(Icons.check, color: Colors.white),
                            ),
                            secondaryBackground: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child:
                                  const Icon(Icons.close, color: Colors.white),
                            ),
                            onDismissed: (direction) {
                              if (direction == DismissDirection.startToEnd) {
                                _approveNews(newsList[index]['id']);
                              } else {
                                _rejectNews(newsList[index]['id']);
                              }
                            },
                            child: ListTile(
                              title: Text(newsList[index]['title']),
                              subtitle: Text("By ${newsList[index]['author']}"),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.check,
                                        color: Colors.green),
                                    onPressed: () =>
                                        _approveNews(newsList[index]['id']),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close,
                                        color: Colors.red),
                                    onPressed: () =>
                                        _rejectNews(newsList[index]['id']),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom Page Transition
class PageTransition extends StatelessWidget {
  final Widget child;
  const PageTransition({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 700),
      transitionBuilder: (child, animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
      child: child,
    );
  }
}
