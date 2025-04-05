import 'package:edu_tech/Common/Textstyle.dart';
import 'package:edu_tech/Widget/commontextfield.dart';
import 'package:edu_tech/common_appbar.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Note {
  final int? id;
  final String title;
  final String subtitle;
  final String description;

  Note({this.id, required this.title, required this.subtitle, required this.description});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'description': description,
    };
  }

  static Note fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      subtitle: map['subtitle'],
      description: map['description'],
    );
  }
}

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'notes_database.db');
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        subtitle TEXT,
        description TEXT
      )
    ''');
  }

  Future<int> insertNote(Note note) async {
    final db = await database;
    return await db.insert('notes', note.toMap());
  }

  Future<List<Note>> getAllNotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('notes');
    return List.generate(maps.length, (i) {
      return Note.fromMap(maps[i]);
    });
  }
}

class AddNotePage extends StatefulWidget {
  @override
  _AddNotePageState createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final _dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Note')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              commontextfield("Title", _titleController),
              commontextfield("Sub Title", _subtitleController),
              commontextfield("Description About Notes", _descriptionController,lines: 7),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final note = Note(
                      title: _titleController.text,
                      subtitle: _subtitleController.text,
                      description: _descriptionController.text,
                    );
                    await _dbHelper.insertNote(note);
                    Navigator.pop(context, true);
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotesListPage extends StatefulWidget {
  @override
  _NotesListPageState createState() => _NotesListPageState();
}

class _NotesListPageState extends State<NotesListPage> {
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
    return Scaffold(
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNotePage()),
          );
          if (result == true) {
            _refreshNotes();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class NoteDetailPage extends StatelessWidget {
  final Note note;

  NoteDetailPage({required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: common_appbar("View Notes"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Title: ${note.subtitle}', style: commonstylepoppins(size: 20,weight: FontWeight.w800)),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Subtitle: ${note.subtitle}', style: commonstylepoppins(size: 15,weight: FontWeight.w500)),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Description: ${note.description}',style:commonstylepoppins(size: 12,weight: FontWeight.w300)),
            ),
          ],
        ),
      ),
    );
  }
}