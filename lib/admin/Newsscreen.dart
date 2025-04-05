import 'package:edu_tech/common_appbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Common/Textstyle.dart';


class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List<dynamic> articles = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });
    final apiKey = '72cc9794a011414e892f69eb74aaaa63';
    final url = Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=us&apiKey=$apiKey');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          articles = data['articles'];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load news: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: common_appbar("News Feed"),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage))
          : ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final article = articles[index];
          return Card(
            color: Colors.white,
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              leading: article['urlToImage'] != null
                  ? Image.network(
                article['urlToImage'],
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                  return Icon(Icons.image_not_supported);
                },
              )
                  : Icon(Icons.image_not_supported),
              title: Text(article['title'] ?? 'No Title',style: commonstylepoppins(weight: FontWeight.w800),),
              subtitle: Text(article['description'] ?? 'No Description',style: commonstylepoppins(size: 12),),
              onTap: () {
                // Handle tap to open the full article (e.g., using url_launcher)
                // You would typically use url_launcher package to open the url.
                //Example: launch(article['url']);
                //import 'package:url_launcher/url_launcher.dart';
                if (article['url'] != null) {
                  //launch(article['url']); //You need to install url_launcher
                  //Example of placeholder text.
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Opening ${article['url']}'),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Article URL not available'),
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}