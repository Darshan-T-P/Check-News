import 'package:flutter/material.dart';

class NewsDetailsPage extends StatefulWidget {
  final Map<String, Object?> newsContent;
  const NewsDetailsPage({
    super.key,
    required this.newsContent,
  });

  @override
  State<NewsDetailsPage> createState() => _NewsDetailsPageState();
}

class _NewsDetailsPageState extends State<NewsDetailsPage> {
  final ScrollController _scrollController = ScrollController();
  int likes = 0;
  bool isLiked = false;
  // Scroll to the top of the page
  void scrollToTop() {
    _scrollController.animateTo(
      0.0, // Scroll to the top (0.0 position)
      duration: const Duration(milliseconds: 500), // Animation duration
      curve: Curves.easeInOut, // Animation curve
    );
  }

  @override
  void dispose() {
    _scrollController
        .dispose(); // Dispose of the ScrollController when the widget is destroyed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("News Details"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Displaying the news image
            Center(
              child: Image.asset(
                widget.newsContent['imageUrl'] as String,
                height: 350,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            // Displaying the news title
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                widget.newsContent['title'] as String,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            // Displaying the author and time
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const CircleAvatar(), // Placeholder for author avatar
                  const SizedBox(width: 10),
                  Text(
                    widget.newsContent['Author'] as String,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  SizedBox(width: 30),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          isLiked
                              ? Icons.thumb_up_alt
                              : Icons.thumb_up_alt_outlined,
                          color: isLiked ? Colors.blue : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            isLiked = !isLiked;
                            likes += isLiked
                                ? 1
                                : -1; // Increment or decrement likes
                          });
                        },
                      ),
                      Text("$likes likes"),
                    ],
                  ),

                  const Spacer(),
                  const Icon(Icons.access_time_rounded),
                  const SizedBox(width: 5),
                  Text(widget.newsContent['time'] as String),
                ],
              ),
            ),
            // Displaying the main content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.newsContent['content'] as String,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      ),
      // Floating action button to scroll to the top
      floatingActionButton: FloatingActionButton(
        onPressed: scrollToTop, // Invoke the scrollToTop method
        child: const Icon(Icons.keyboard_arrow_up_rounded),
      ),
    );
  }
}
