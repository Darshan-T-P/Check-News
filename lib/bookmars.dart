import 'package:check_news/news_details_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BookmarksPages extends StatefulWidget {
  const BookmarksPages({super.key});

  @override
  State<BookmarksPages> createState() => _BookmarksPagesState();
}

class _BookmarksPagesState extends State<BookmarksPages> {
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  List<String> bookmarkedNewsIds = [];

  @override
  void initState() {
    super.initState();
    fetchBookmarkedNewsIds();
  }

  /// Fetch bookmarked news IDs from the user's document in Firestore
  Future<void> fetchBookmarkedNewsIds() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        setState(() {
          bookmarkedNewsIds = List<String>.from(userDoc['bookmarks'] ?? []);
        });
      }
    } catch (e) {
      print("Error fetching bookmarks: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text("Bookmarked News",
            style: TextStyle(color: Color.fromRGBO(0, 223, 130, 1))),
        centerTitle: true,
      ),
      body: bookmarkedNewsIds.isEmpty
          ? const Center(
              child: Text("No bookmarks available"),
            )
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('news')
                  .where(FieldPath.documentId, whereIn: bookmarkedNewsIds)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text("Error loading news!"));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No bookmarks available"));
                }

                var bookmarkedNews = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: bookmarkedNews.length,
                  itemBuilder: (context, index) {
                    final newsItem = bookmarkedNews[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewsDetailsPage(
                              id: newsItem.id,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        color: Theme.of(context).colorScheme.secondary,
                        margin: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(
                            newsItem['title'] ?? 'No Title',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(newsItem['author'] ?? 'Unknown Author'),
                          trailing: IconButton(
                            onPressed: () async {
                              await removeBookmark(newsItem.id);
                            },
                            icon: const Icon(
                              Icons.bookmark_remove,
                              color: Colors.red,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  /// Remove a news ID from the user's bookmarks in Firestore
  Future<void> removeBookmark(String newsId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({
        'bookmarks': FieldValue.arrayRemove([newsId])
      });

      setState(() {
        bookmarkedNewsIds.remove(newsId);
      });
    } catch (e) {
      print("Error removing bookmark: $e");
    }
  }
}
