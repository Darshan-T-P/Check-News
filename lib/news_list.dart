import 'package:check_news/global_news.dart';
import 'package:check_news/news_cart.dart';
import 'package:check_news/news_details_page.dart';
import 'package:flutter/material.dart';

class NewsList extends StatefulWidget {
  const NewsList({super.key});

  @override
  State<NewsList> createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  final List<String> filters = [
    'New Posts',
    'All',
    'Trending',
    'Technical',
    'Agri',
    'Poltics'
  ];

  late String selected;

  @override
  void initState() {
    super.initState();
    selected = filters[0];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 120,
          child: ListView.builder(
              itemCount: filters.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final filter = filters[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selected = filter;
                      });
                    },
                    child: Chip(
                      label: Text(filter),
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: selected == filter ? Colors.white : Colors.black,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      backgroundColor:
                          selected == filter ? Colors.black : Colors.white,
                      side: BorderSide(
                        width: 3,
                        color: Colors.black,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                );
              }),
        ),
        Expanded(
          child: ListView.builder(
              itemCount: news.length,
              itemBuilder: (context, index) {
                final newss = news[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return NewsDetailsPage(newsContent: newss);
                    }));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: NewsCart(
                      title: newss['title'] as String,
                      time: newss['time'] as String,
                      image: newss['imageUrl'] as String,
                      author: newss['Author'] as String,
                    ),
                  ),
                );
              }),
        )
      ],
    );
  }
}
