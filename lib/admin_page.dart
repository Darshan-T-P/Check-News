import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int totalUsers = 10; // Example count
  int totalPosts = 100; // Example count

  // Function to approve news by updating Firestore
  Future<void> _approveNews(String newsId) async {
    await FirebaseFirestore.instance.collection("news").doc(newsId).update({
      'approve': 'approved',
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("News item approved successfully")),
    );
  }

  // Function to delete news from Firestore
  Future<void> _rejectNews(String newsId) async {
    await FirebaseFirestore.instance.collection("news").doc(newsId).delete();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("News item deleted successfully")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            // **Admin Dashboard Card**
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

            // **News Approval Section**
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('news')
                    .where('approve', whereIn: ['pending', 'waiting'])
                    .snapshots(),
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
                      return Dismissible(
                        key: Key(newsList[index]['id']),
                        background: Container(
                          color: Colors.green,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(Icons.check, color: Colors.white),
                        ),
                        secondaryBackground: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(Icons.close, color: Colors.white),
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
                                icon: const Icon(Icons.close, color: Colors.red),
                                onPressed: () =>
                                    _rejectNews(newsList[index]['id']),
                              ),
                            ],
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
