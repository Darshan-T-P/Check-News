import 'package:check_news/news_details_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, required this.newsList});

  final List<Map<String, dynamic>> newsList;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List _allResult = [];
  List _filteredNews = [];
  getNewsStream() async {
    var data = await FirebaseFirestore.instance
        .collection('news')
        .orderBy('title')
        .get();

    setState(() {
      _allResult = data.docs;
    });

    filterNews();
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChange);
  }

  _onSearchChange() {
    filterNews();
  }

  filterNews() {
    var showResult = [];
    if (_searchController.text != "") {
      for (var newsSnapShot in _allResult) {
        var title = newsSnapShot['title'].toString().toLowerCase();
        if (title.contains(_searchController.text.toLowerCase())) {
          showResult.add(newsSnapShot);
        }
      }
    } else {
      showResult = List.from(_allResult);
    }

    setState(() {
      _filteredNews = showResult;
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChange);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    getNewsStream();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: 
           const Text("Search News",
              style: TextStyle(color: Color.fromRGBO(0, 223, 130, 1))),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _searchController,
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
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                      .collection("news")
                      .where('approve', isEqualTo: 'approved')
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text("Error loading news!"),
                      );
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text("No news available"),
                      );
                    }
      
                return Expanded(
                    child: ListView.builder(
                  itemCount: _filteredNews.length,
                  itemBuilder: (context, index) {
                    
                    final news = _filteredNews[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewsDetailsPage(
                              id: news.id,
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
                            news['author'] ?? 'Unknown Author',
                          ),
                        ),
                      ),
                    );
                  },
                ));
              }
            ),
          ],
        ),
      ),
    );
  }
}
