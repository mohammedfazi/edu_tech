import 'package:edu_tech/Common/Textstyle.dart';
import 'package:edu_tech/common_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

class OpenLibraryScreen extends StatefulWidget {
  @override
  _OpenLibraryScreenState createState() => _OpenLibraryScreenState();
}

class _OpenLibraryScreenState extends State<OpenLibraryScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _books = [];
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadRandomBooks(); // Load random books on initial load
  }

  Future<void> _loadRandomBooks() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _books = [];
    });

    try {
      final response = await http.get(
        Uri.parse('http://openlibrary.org/search.json?q=random'), // Use 'random' as query
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _books = data['docs'];
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load books';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _searchBooks(String query) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _books = [];
    });

    try {
      final response = await http.get(
        Uri.parse('http://openlibrary.org/search.json?q=$query'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _books = data['docs'];
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load books';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _downloadBook(String bookId, String title) async {
    final String downloadUrl =
        'http://openlibrary.org/api/volumes/brief/olid/$bookId.json';

    try {
      final response = await http.get(Uri.parse(downloadUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> items = data['items'];

        if (items.isNotEmpty && items[0]['accessInfo']['webReaderLink'] != null) {
          final String webReaderLink = items[0]['accessInfo']['webReaderLink'];

          if (await canLaunchUrl(Uri.parse(webReaderLink))) {
            await launchUrl(Uri.parse(webReaderLink));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Could not launch book')),
            );
          }
        } else if (items.isNotEmpty && items[0]['accessInfo']['pdf'] != null && items[0]['accessInfo']['pdf']['acsTokenLink'] != null){
          final String pdfLink = items[0]['accessInfo']['pdf']['acsTokenLink'];
          _downloadPdf(pdfLink, title);

        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Download link not available')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to get download link')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  Future<void> _downloadPdf(String pdfLink, String title) async {
    Dio dio = Dio();
    try {
      if (pdfLink.startsWith('http')) {
        final dir = await getApplicationDocumentsDirectory();
        final filePath = '${dir.path}/$title.pdf';
        await dio.download(pdfLink, filePath);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Download complete: $filePath')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid PDF link')),
        );
      }
    } catch (e) {
      print('Download error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Download failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: common_appbar("Open Library"),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Books',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    if (_searchController.text.isEmpty) {
                      _loadRandomBooks();
                    } else {
                      _searchBooks(_searchController.text);
                    }
                  },
                ),
              ),
            ),
          ),
          if (_isLoading) CupertinoActivityIndicator(),
          if (_errorMessage.isNotEmpty) Text(_errorMessage),
          Expanded(
            child: ListView.builder(
              itemCount: _books.length,
              itemBuilder: (context, index) {
                final book = _books[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.grey.shade50,
                    child: ListTile(
                      title: Text(book['title'] ?? 'Unknown Title',style: commonstylepoppins(size: 15,weight: FontWeight.w800),),
                      subtitle: Text(book['author_name']?.join(', ') ?? 'Unknown Author',style: commonstylepoppins(),),
                      trailing: ElevatedButton(
                        onPressed: () {
                          _downloadBook(book['key'].toString().split('/').last, book['title']??'Unknown Title');
                        },
                        child: Text('View/Download',style: commonstylepoppins(),),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}