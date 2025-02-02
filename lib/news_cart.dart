import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class NewsCart extends StatefulWidget {
  final String title;
  final String image;
  final dynamic time; // This can be a Timestamp or a String
  final String author;

  const NewsCart({
    super.key,
    required this.title,
    required this.image,
    required this.time,
    required this.author,
  });

  @override
  State<NewsCart> createState() => _NewsCartState();
}

class _NewsCartState extends State<NewsCart> {
  bool isBookmarked = false; // Tracks if the news is bookmarked
  int likeCount = 0; // Tracks the number of likes

  void toggleBookmark() {
    setState(() {
      isBookmarked = !isBookmarked;
    });
  }

  void toggleLike() {
    setState(() {
      likeCount = likeCount + 1; // Increment like count when tapped
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    // Attempt to parse the time, handle invalid formats gracefully
    String formattedTime = "Invalid Time Format";
    try {
      DateTime dateTime;
      // If the time is a Timestamp (like in Firebase)
      if (widget.time is Timestamp) {
        dateTime = DateTime.fromMillisecondsSinceEpoch(
            widget.time.seconds * 1000); // Convert timestamp to DateTime
      } else {
        dateTime = DateTime.parse(widget.time); // For ISO8601 date format
      }
      formattedTime = timeago.format(dateTime); // Format as relative time
    } catch (e) {
      print("Error parsing date: $e");
      formattedTime = "No Date";
    }

    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: height * 0.3,
            width: width * 0.9,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
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
              borderRadius: BorderRadius.circular(30),
              child: Stack(
                children: [
                  // Image in the background from the network URL
                  widget.image.startsWith('http')
                      ? Positioned.fill(
                          child: Image.network(
                            widget.image,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Positioned.fill(
                          child: Image.asset(
                            widget.image, // Use Image.asset for local files
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                ],
              ),
            ),
          ),
          // CircleAvatar at the top-left position
          Positioned(
            top: 10,
            left: 20,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage(
                      'assets/images/img.png'), // Replace with your image path
                  backgroundColor: Colors.grey.shade300,
                ),
                const SizedBox(width: 10),
                Text(
                  widget.author,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          ),
          // Three-dot button at the top-right position
          Positioned(
            top: 10,
            right: 10,
            child: PopupMenuButton(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: "share",
                  child: Row(
                    children: [Icon(Icons.share), Text("Share")],
                  ),
                ),
                const PopupMenuItem(
                  value: "Favourite",
                  child: Row(
                    children: [Icon(Icons.bookmark), Text("Favourite")],
                  ),
                ),
              ],
              onSelected: (value) {
                // Handle menu item selection
                if (value == "Favourite") {
                  toggleBookmark();
                } else if (value == "share") {
                  print("Share option selected");
                }
              },
            ),
          ),
          // Bottom area with content and row for likes and time
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.thumb_up,
                                size: 18, color: Colors.grey),
                            const SizedBox(width: 5),
                            Text(
                              "$likeCount Likes", // Display the current like count
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black54),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.access_time,
                                size: 18, color: Colors.grey),
                            const SizedBox(width: 5),
                            Text(
                              formattedTime, // Display the relative time
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black54),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
