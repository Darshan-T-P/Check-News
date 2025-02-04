import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';

class NewsCart extends StatefulWidget {
  final String id;
  final String title;
  final String image;
  final dynamic time;
  final String author;
  final List likes;

  const NewsCart({
    super.key,
    required this.id,
    required this.title,
    required this.image,
    required this.time,
    required this.author,
    required this.likes,
  });

  @override
  State<NewsCart> createState() => _NewsCartState();
}

class _NewsCartState extends State<NewsCart> {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  int likeCount = 0;

  @override
  void initState() {
    super.initState();
    fetchLikes(); // Fetch likes when the widget initializes
  }

  Future<void> fetchLikes() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('news')
          .doc(widget.id)
          .get();

      if (doc.exists) {
        List likes = doc['likes'] ?? [];
        setState(() {
          likeCount = likes.length;
        });
      }
    } catch (e) {
      print("Error fetching likes: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    String formattedTime = "Invalid Time Format";

    try {
      DateTime dateTime;

      if (widget.time is DateTime) {
        dateTime = widget.time;
      } else if (widget.time is Timestamp) {
        dateTime = widget.time.toDate();
      } else if (widget.time is int) {
        dateTime = DateTime.fromMillisecondsSinceEpoch(widget.time * 1000);
      } else if (widget.time is String) {
        if (widget.time == "No Date") {
          throw Exception("No valid date provided");
        }
        try {
          dateTime = DateTime.parse(widget.time);
        } catch (e) {
          dateTime = DateFormat("MMMM d, yyyy 'at' h:mm:ss a z").parse(widget.time, true);
        }
      } else {
        throw Exception("Unsupported time format: ${widget.time}");
      }

      formattedTime = timeago.format(dateTime);
    } catch (e) {
      formattedTime = "No Date";
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: height * 0.3,
              width: width * 0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    Colors.green.shade700,
                    Colors.green.shade200,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  widget.image,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 10,
              left: 20,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage('assets/images/img.png'),
                    backgroundColor: Colors.grey.shade300,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.author,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 70,
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.thumb_up_alt, size: 18, color: Colors.grey),
                            const SizedBox(width: 5),
                            Text(
                              "$likeCount Likes",
                              style: const TextStyle(fontSize: 12, color: Colors.black54),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 18, color: Colors.grey),
                            const SizedBox(width: 5),
                            Text(
                              formattedTime,
                              style: const TextStyle(fontSize: 12, color: Colors.black54),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
