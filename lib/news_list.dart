import 'package:check_news/global_news.dart';
import 'package:check_news/news_cart.dart';
import 'package:check_news/news_details_page.dart';
import 'package:check_news/profile_pages.dart';
import 'package:check_news/search_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NewsList extends StatefulWidget {
  const NewsList({super.key});

  @override
  State<NewsList> createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  final List<String> filters = [
    'New Posts',
    'All',
    'Trending',
    'Technical',
    'Agri',
    'Politics',
  ];

  late String selected;

  @override
  void initState() {
    super.initState();
    selected = filters[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text("Check Here",
            style: TextStyle(color: Color.fromRGBO(0, 223, 130, 1))),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchPage(newsList: news),
                ),
              );
            },
            icon: const Icon(
              Icons.search,
              color: Color.fromRGBO(0, 223, 130, 1),
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePages(),
                ),
              );
            },
            icon: const Icon(
              Icons.notifications_none_sharp,
              color: Color.fromRGBO(0, 223, 130, 1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
              child: const CircleAvatar(
                radius: 18,
                child: Icon(Icons.person),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 80,
              child: ListView.builder(
                itemCount: filters.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final filter = filters[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selected = filter;
                        });
                      },
                      child: Chip(
                        label: Text(filter),
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: selected == filter
                              ? Theme.of(context).colorScheme.secondary
                              : Theme.of(context).colorScheme.tertiary,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 5,
                        ),
                        backgroundColor: selected == filter
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.primary,
                        side: const BorderSide(
                          width: 3,
                          color: Color.fromRGBO(3, 15, 15, 1),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                // Modify the Firestore query to filter out pending approvals
                stream: FirebaseFirestore.instance
                    .collection("news")
                    .where('approve', isEqualTo: 'approved')
                    .orderBy('date',descending: true)
                    // Only show approved news
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("Error loading news!"),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text("No news available"),
                    );
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final doc = snapshot.data!.docs[index];
                      final news = doc.data() as Map<String, dynamic>;

                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => NewsDetailsPage(
                                id: doc.id,
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: NewsCart(
                            id: doc.id,
                            title: news['title'] ?? 'No Title',
                            time: news['date'] is Timestamp
                                ? news['date'].toDate()
                                : 'No Date',
                            image: news['images'] is List
                                ? news['images'].isNotEmpty
                                    ? news['images'][0]
                                    : 'No image Data'
                                : news['images'] ?? 'No image Data',
                            author: news['author'],
                            likes: [],
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
    );
  }
}
