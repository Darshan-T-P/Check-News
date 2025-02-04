import 'package:check_news/imagepage_view.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timeago/timeago.dart' as timeago;

class NewsDetailsPage extends StatefulWidget {
  final String id;
  const NewsDetailsPage({
    super.key,
    required this.id,
  });

  @override
  State<NewsDetailsPage> createState() => _NewsDetailsPageState();
}

class _NewsDetailsPageState extends State<NewsDetailsPage> {
  final ScrollController _scrollController = ScrollController();
  late String userId;
  bool isLiked = false;
  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser!.uid;
    checkIfBookmarked();
  }

  Future<void> checkIfBookmarked() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        List<dynamic> bookmarks = userDoc['bookmarks'] ?? [];
        setState(() {
          isBookmarked = bookmarks.contains(widget.id);
        });
      }
    } catch (e) {
      print("Error checking bookmarks: $e");
    }
  }

  Future<void> likePost() async {
    try {
      await FirebaseFirestore.instance
          .collection('news')
          .doc(widget.id)
          .update({
        'likes': FieldValue.arrayUnion([userId]),
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error Liking the post')),
      );
    }
  }

  Future<void> dislikePost() async {
    try {
      await FirebaseFirestore.instance
          .collection('news')
          .doc(widget.id)
          .update({
        'likes': FieldValue.arrayRemove([userId]),
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error disliking the post')),
      );
    }
  }

  Future<void> toggleBookmark() async {
    try {
      DocumentReference userRef =
          FirebaseFirestore.instance.collection('users').doc(userId);

      await userRef.update({
        'bookmarks': isBookmarked
            ? FieldValue.arrayRemove([widget.id])
            : FieldValue.arrayUnion([widget.id])
      });

      setState(() {
        isBookmarked = !isBookmarked;
      });
    } catch (e) {
      print("Error updating bookmark: $e");
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("News Details"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: toggleBookmark,
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
            ),
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('news')
            .doc(widget.id)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('News not found.'));
          }

          var data = snapshot.data!;
          var newsData = data.data() as Map<String, dynamic>;

          Timestamp timestamp = newsData['date'];
          DateTime dateTime = timestamp.toDate();
          String formattedTime = timeago.format(dateTime);

          List<dynamic> likesList = newsData['likes'] ?? [];
          isLiked = likesList.contains(userId);

          List<dynamic> imageUrls = newsData['images'] ?? [];

          return SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (imageUrls.isNotEmpty)
                  Center(
                    child: SizedBox(
                      height: 250,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(10),
                        scrollDirection: Axis.horizontal,
                        itemCount: imageUrls.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ImageViewerScreen(
                                    imageUrls: imageUrls, // Pass full list
                                    initialIndex:
                                        index, // Start from tapped image
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  imageUrls[index],
                                  height: 350,
                                  width: MediaQuery.of(context).size.width * 0.9,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    newsData['title'],
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const CircleAvatar(),
                      const SizedBox(width: 10),
                      Text(
                        newsData['author'],
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              if (isLiked) {
                                dislikePost();
                              } else {
                                likePost();
                              }
                            },
                            icon: isLiked
                                ? const Icon(Icons.thumb_up_alt_rounded,
                                    color: Colors.blue)
                                : const Icon(Icons.thumb_up_alt_outlined),
                          ),
                          Text("${likesList.length} likes"),
                        ],
                      ),
                      const Spacer(),
                      const Icon(Icons.access_time_rounded),
                      const SizedBox(width: 5),
                      Text(formattedTime),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    newsData['content'],
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _scrollController.animateTo(
            0.0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        },
        child: const Icon(Icons.keyboard_arrow_up_rounded),
      ),
    );
  }
}
