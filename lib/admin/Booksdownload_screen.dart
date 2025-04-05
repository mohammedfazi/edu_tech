import 'package:edu_tech/Common/Textstyle.dart';
import 'package:edu_tech/common_appbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class Book {
  final String title;
  final String author;
  final String downloadUrl;
  final int id; // Add id

  Book({required this.title, required this.author, required this.downloadUrl, required this.id});

  factory Book.fromJson(Map<String, dynamic> json) {
    String author = 'Unknown Author';
    if (json['authors'] != null && json['authors'].isNotEmpty) {
      author = json['authors'][0]['name'] ?? 'Unknown Author';
    }

    String downloadUrl = '';
    if (json['formats'] != null) {
      downloadUrl = json['formats']['application/epub+zip'] ??
          json['formats']['text/plain; charset=utf-8'] ??
          json['formats']['application/pdf'] ??
          '';
    }

    return Book(
      title: json['title'] ?? 'Unknown Title',
      author: author,
      downloadUrl: downloadUrl,
      id: json['id'] ?? 0, //Add id
    );
  }
}

class FreeBooksPage extends StatefulWidget {
  @override
  _FreeBooksPageState createState() => _FreeBooksPageState();
}

class _FreeBooksPageState extends State<FreeBooksPage> {
  List<Book> books = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response = await http.get(Uri.parse('https://gutendex.com/books'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        List results = jsonData['results'];

        setState(() {
          books = results.map((bookJson) => Book.fromJson(bookJson)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load books. Status code: ${response.statusCode}';
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
      appBar: common_appbar("Books"),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage))
          : ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return Card(
            color: Colors.grey.shade50,
            child: ListTile(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  book.title,
                  style: commonstylepoppins(
                      size: 15, weight: FontWeight.w800),
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  book.author,
                  style: commonstylepoppins(),
                ),
              ),
              trailing: Icon(Icons.arrow_forward_ios), // Changed to view detail icon
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookDetailPage(book: book),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class BookDetailPage extends StatelessWidget {
  final Book book;

  BookDetailPage({required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(book.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: ${book.title}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Author: ${book.author}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            if (book.downloadUrl.isNotEmpty)
              ElevatedButton(
                onPressed: () async {
                  if (await canLaunchUrl(Uri.parse(book.downloadUrl))) {
                    await launchUrl(Uri.parse(book.downloadUrl));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Could not launch ${book.downloadUrl}')),
                    );
                  }
                },
                child: Text('Download Book'),
              ),
            if (book.downloadUrl.isEmpty)
              Text("Download URL not available."),
            SizedBox(height: 20),
            // Text('Book ID: ${book.id}', style: TextStyle(fontSize: 14, color: Colors.grey)), // Added book ID
          ],
        ),
      ),
    );
  }
}