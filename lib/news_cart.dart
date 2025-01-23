import 'package:flutter/material.dart';

class NewsCart extends StatefulWidget {
  final String title;
  final String image;
  final String time;
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
                  // Image in the background
                  Positioned.fill(
                    child: Image.asset(
                      widget.image,
                      height: 200,
                      width: double.infinity,
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
                      'assets/images/img.jpg'), // Replace with your image path
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
                  value: "Favoutite",
                  child: Row(
                    children: [Icon(Icons.thumb_up_alt), Text("Favourite")],
                  ),
                ),
              ],
              onSelected: (value) {
                // Handle menu item selection
                if (value == "option1") {
                  print("Option 1 selected");
                } else if (value == "option2") {
                  print("Option 2 selected");
                }
              },
            ),
          ),
          // Bottom area with content and row for likes, views, and time
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
                            const Text(
                              "1.2k Likes",
                              style: TextStyle(
                                  fontSize: 12, color: Colors.black54),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.visibility,
                                size: 18, color: Colors.grey),
                            const SizedBox(width: 5),
                            const Text(
                              "3.5k Views",
                              style: TextStyle(
                                  fontSize: 12, color: Colors.black54),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.access_time,
                                size: 18, color: Colors.grey),
                            const SizedBox(width: 5),
                            const Text(
                              "2h ago",
                              style: TextStyle(
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
  //   return Card(
  //     elevation: 10, // Adds shadow for better visual hierarchy
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(20), // Rounded corners
  //     ),
  //     margin: EdgeInsets.all(20), // Outer margin for spacing
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         // Stack for placing the bookmark button
  //         Stack(
  //           children: [
  //             // News Image
  //             ClipRRect(
  //               borderRadius: BorderRadius.vertical(
  //                 top: Radius.circular(20), // Rounded corners for the top
  //               ),
  //               child: Center(
  //                 child: Image.asset(
  //                   widget.image,
  //                   height: 200,
  //                   width: double.infinity,
  //                   // fit: BoxFit.cover,
  //                 ),
  //               ),
  //             ),
  //             // Bookmark icon as a floating button at the top-right corner

  //             Positioned(
  //               top: 10, // Distance from the top
  //               right: 10, // Distance from the right
  //               child: FloatingActionButton(
  //                 onPressed: (){},
  //                 mini: true, // Makes the button smaller
  //                 child: Icon(
  //                   Icons.more_vert,
  //                   color: Colors.white,
  //                   size: 20,
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.all(16), // Padding for the content
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 widget.title,
  //                 style: Theme.of(context).textTheme.titleMedium,
  //               ),
  //               SizedBox(height: 8), // Spacing between title and row
  //               // Author and Time Row
  //               Row(
  //                 children: [
  //                   SizedBox(width: 45),
  //                   IconButton(
  //                     icon: Icon(
  //                       Icons.thumb_up_alt_outlined,
  //                       color: Colors.blue,
  //                     ),
  //                     onPressed: toggleLike,
  //                   ),
  //                   Text(
  //                     '$likeCount likes', // Display the current like count
  //                     style: Theme.of(context).textTheme.bodyMedium,
  //                   ),
  //                   Spacer(),
  //                   Icon(
  //                     Icons.access_time_outlined,
  //                     size: 20,
  //                   ),
  //                   SizedBox(width: 5), // Spacing between icon and time
  //                   Text(
  //                     widget.time,
  //                     style: Theme.of(context).textTheme.titleSmall,
  //                   ),
  //                 ],
  //               ), // Space before like section
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
