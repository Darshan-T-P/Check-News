import 'package:check_news/global_news.dart';
import 'package:flutter/material.dart';

class BookmarksPages extends StatelessWidget {
  const BookmarksPages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bookmarked News"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: news.length,
          itemBuilder: (context, index) {
            final cartItem = news[index];
            return Card(
              elevation: 6,
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              shadowColor: Colors.green,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // News Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        cartItem['imageUrl'] as String,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 15), // Space between image and text
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cartItem['title'].toString(),
                            style: Theme.of(context).textTheme.titleMedium,
                            overflow: TextOverflow
                                .ellipsis, // Avoid long text overflow
                            maxLines: 1,
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Author: ${cartItem['Author'].toString()}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.remove_circle,
                        color: Colors.red,
                        size: 35,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
