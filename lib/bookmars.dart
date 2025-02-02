import 'package:check_news/global_news.dart';
import 'package:check_news/news_details_page.dart';
import 'package:flutter/material.dart';

class BookmarksPages extends StatelessWidget {
  const BookmarksPages({super.key});

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
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: news.isNotEmpty
            ? ListView.builder(
                itemCount: news.length,
                itemBuilder: (context, index) {
                  final cartItem = news[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewsDetailsPage(
                            newsContent: cartItem,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      color: Theme.of(context).colorScheme.secondary,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            cartItem['imageUrl'] as String,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          cartItem['title'].toString(),
                          style: Theme.of(context).textTheme.titleMedium,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        subtitle: Text(
                          'Author: ${cartItem['Author']}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            // Handle bookmark removal
                          },
                          icon: const Icon(
                            Icons.remove_circle,
                            color: Colors.red,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
            : const Center(
                child: Text(
                  "No bookmarks found.",
                  style: TextStyle(fontSize: 18),
                ),
              ),
      ),
    );
  }
}
