import 'package:edu_tech/Common/Textstyle.dart';
import 'package:edu_tech/common_appbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Homework {
  final int? id;
  final String subject;
  final String description;
  final DateTime dueDate;

  Homework({this.id, required this.subject, required this.description, required this.dueDate});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subject': subject,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
    };
  }

  static Homework fromMap(Map<String, dynamic> map) {
    return Homework(
      id: map['id'],
      subject: map['subject'],
      description: map['description'],
      dueDate: DateTime.parse(map['dueDate']),
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
    String path = join(await getDatabasesPath(), 'homework_database.db');
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE homeworks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        subject TEXT,
        description TEXT,
        dueDate TEXT
      )
    ''');
  }

  Future<int> insertHomework(Homework homework) async {
    final db = await database;
    return await db.insert('homeworks', homework.toMap());
  }

  Future<List<Homework>> getAllHomeworks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('homeworks');
    return List.generate(maps.length, (i) {
      return Homework.fromMap(maps[i]);
    });
  }
  Future<void> deleteHomework(int id) async{
    final db = await database;
    await db.delete('homeworks', where: 'id = ?', whereArgs: [id]);
  }
}

class AddHomeworkPage extends StatefulWidget {
  @override
  _AddHomeworkPageState createState() => _AddHomeworkPageState();
}

class _AddHomeworkPageState extends State<AddHomeworkPage> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: common_appbar("Add Homework"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _subjectController,
                  decoration: InputDecoration(
                    hintStyle: commonstylepoppins(size: 14,color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black)),

                      labelText: 'Subject'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter subject';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLines: 8,
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    hintStyle: commonstylepoppins(size: 14,color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black)),
                      labelText: 'Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter description';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Text('Due Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}',style: commonstylepoppins(weight: FontWeight.w800),),
                    IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final homework = Homework(
                      subject: _subjectController.text,
                      description: _descriptionController.text,
                      dueDate: _selectedDate,
                    );
                    await DatabaseHelper().insertHomework(homework);
                    Navigator.pop(context, true); // Return true to signal data change.
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

class HomeworkListPage extends StatefulWidget {
  @override
  _HomeworkListPageState createState() => _HomeworkListPageState();
}

class _HomeworkListPageState extends State<HomeworkListPage> {
  final _dbHelper = DatabaseHelper();
  late Future<List<Homework>> _homeworks;

  @override
  void initState() {
    super.initState();
    _homeworks = _dbHelper.getAllHomeworks();
  }

  Future<void> _refreshHomeworks() async {
    setState(() {
      _homeworks = _dbHelper.getAllHomeworks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: common_appbar("Homework"),
      body: FutureBuilder<List<Homework>>(
        future: _homeworks,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final homework = snapshot.data![index];
                return Dismissible(
                  key: Key(homework.id.toString()),
                  onDismissed: (direction) async{
                    await _dbHelper.deleteHomework(homework.id!);
                    _refreshHomeworks();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Homework deleted')));
                  },
                  background: Container(color: Colors.red),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ListTile(
                        title: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(homework.subject,style: commonstylepoppins(size: 18,weight: FontWeight.w800),),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(homework.description,style: commonstylepoppins(),),
                        ),
                        trailing: Text(DateFormat('yyyy-MM-dd').format(homework.dueDate),style: commonstylepoppins(weight: FontWeight.w800,size: 10),),
                      ),
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
            MaterialPageRoute(builder: (context) => AddHomeworkPage()),
          );
          if (result == true) {
            _refreshHomeworks();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}