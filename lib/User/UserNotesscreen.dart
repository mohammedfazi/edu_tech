import 'package:flutter/material.dart';

import '../Common/Textstyle.dart';
import '../admin/AddNotes_screen.dart';
import '../common_appbar.dart';

class Usernotesscreen extends StatefulWidget {
  const Usernotesscreen({super.key});

  @override
  State<Usernotesscreen> createState() => _UsernotesscreenState();
}

class _UsernotesscreenState extends State<Usernotesscreen> {
  final _dbHelper = DatabaseHelper();
  late Future<List<Note>> _notesList;

  @override
  void initState() {
    super.initState();
    _notesList = _dbHelper.getAllNotes();
  }

  Future<void> _refreshNotes() async {
    setState(() {
      _notesList = _dbHelper.getAllNotes();
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: common_appbar("Notes"),
      body: FutureBuilder<List<Note>>(
        future: _notesList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final note = snapshot.data![index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(note.title,style: commonstylepoppins(size: 18,weight: FontWeight.w800),),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(note.subtitle,style: commonstylepoppins(size: 15),),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NoteDetailPage(note: note),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
