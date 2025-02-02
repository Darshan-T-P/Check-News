import 'package:check_news/news_details_page.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, required this.newsList});

  final List<Map<String, dynamic>> newsList;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _searchController;
  List<Map<String, dynamic>> filteredNews = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    filteredNews = widget.newsList; // Initially show all news
  }

  void _filterNews(String query) {
    final filtered = widget.newsList
        .where((news) =>
            news['title']!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    setState(() {
      filteredNews = filtered;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text("Search News",
            style: TextStyle(color: Color.fromRGBO(0, 223, 130, 1))),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterNews,
              decoration: InputDecoration(
                hintText: "Search news by title...",
                prefixIcon: const Icon(
                  Icons.search,
                  size: 22,
                  color: Colors.white,
                ),
                hintStyle: TextStyle(fontSize: 20, color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                      color: Colors.transparent), // Default border
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                      color: Colors.white,
                      width: 2.0), // White border when focused
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                      color: Colors
                          .transparent), // Transparent border when not focused
                ),
              ),
            ),
          ),
          Expanded(
            child: filteredNews.isNotEmpty
                ? ListView.builder(
                    itemCount: filteredNews.length,
                    itemBuilder: (context, index) {
                      final news = filteredNews[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewsDetailsPage(
                                newsContent: news,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          color: Theme.of(context).colorScheme.secondary,
                          margin: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(
                              news['title'] ?? 'No Title',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              news['Author'] ?? 'Unknown Author',
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : const Center(
                    child: Text(
                      "No results found.",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
