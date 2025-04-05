import 'package:edu_tech/Common/Textstyle.dart';
import 'package:edu_tech/common_appbar.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ExamMark {
  final int? id;
  final String studentName;
  final String registerNumber;
  final String subject1;
  final int marks1;
  final String subject2;
  final int marks2;
  final String subject3;
  final int marks3;
  final String subject4;
  final int marks4;
  final String subject5;
  final int marks5;

  ExamMark({
    this.id,
    required this.studentName,
    required this.registerNumber,
    required this.subject1,
    required this.marks1,
    required this.subject2,
    required this.marks2,
    required this.subject3,
    required this.marks3,
    required this.subject4,
    required this.marks4,
    required this.subject5,
    required this.marks5,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentName': studentName,
      'registerNumber': registerNumber,
      'subject1': subject1,
      'marks1': marks1,
      'subject2': subject2,
      'marks2': marks2,
      'subject3': subject3,
      'marks3': marks3,
      'subject4': subject4,
      'marks4': marks4,
      'subject5': subject5,
      'marks5': marks5,
    };
  }

  static ExamMark fromMap(Map<String, dynamic> map) {
    return ExamMark(
      id: map['id'],
      studentName: map['studentName'],
      registerNumber: map['registerNumber'],
      subject1: map['subject1'],
      marks1: map['marks1'],
      subject2: map['subject2'],
      marks2: map['marks2'],
      subject3: map['subject3'],
      marks3: map['marks3'],
      subject4: map['subject4'],
      marks4: map['marks4'],
      subject5: map['subject5'],
      marks5: map['marks5'],
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
    String path = join(await getDatabasesPath(), 'exam_marks_database.db');
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE exam_marks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        studentName TEXT,
        registerNumber TEXT,
        subject1 TEXT,
        marks1 INTEGER,
        subject2 TEXT,
        marks2 INTEGER,
        subject3 TEXT,
        marks3 INTEGER,
        subject4 TEXT,
        marks4 INTEGER,
        subject5 TEXT,
        marks5 INTEGER
      )
    ''');
  }

  Future<int> insertExamMark(ExamMark examMark) async {
    final db = await database;
    return await db.insert('exam_marks', examMark.toMap());
  }

  Future<List<ExamMark>> getAllExamMarks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('exam_marks');
    return List.generate(maps.length, (i) {
      return ExamMark.fromMap(maps[i]);
    });
  }
}

class AddExamMarkPage extends StatefulWidget {
  @override
  _AddExamMarkPageState createState() => _AddExamMarkPageState();
}

class _AddExamMarkPageState extends State<AddExamMarkPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _studentNameController = TextEditingController();
  final TextEditingController _registerNumberController = TextEditingController();
  final TextEditingController _subject1Controller = TextEditingController();
  final TextEditingController _marks1Controller = TextEditingController();
  final TextEditingController _subject2Controller = TextEditingController();
  final TextEditingController _marks2Controller = TextEditingController();
  final TextEditingController _subject3Controller = TextEditingController();
  final TextEditingController _marks3Controller = TextEditingController();
  final TextEditingController _subject4Controller = TextEditingController();
  final TextEditingController _marks4Controller = TextEditingController();
  final TextEditingController _subject5Controller = TextEditingController();
  final TextEditingController _marks5Controller = TextEditingController();
  final _dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Exam Marks')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _studentNameController,
                decoration: InputDecoration(labelText: 'Student Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter student name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _registerNumberController,
                decoration: InputDecoration(labelText: 'Register Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter register number';
                  }
                  return null;
                },
              ),
              // Subject 1
              TextFormField(
                controller: _subject1Controller,
                decoration: InputDecoration(labelText: 'Subject 1'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter subject 1';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _marks1Controller,
                decoration: InputDecoration(labelText: 'Marks 1'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter marks 1';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              // Subject 2
              TextFormField(
                controller: _subject2Controller,
                decoration: InputDecoration(labelText: 'Subject 2'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter subject 2';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _marks2Controller,
                decoration: InputDecoration(labelText: 'Marks 2'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter marks 2';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              // Subject 3
              TextFormField(
                controller: _subject3Controller,
                decoration: InputDecoration(labelText: 'Subject 3'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter subject 3';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _marks3Controller,
                decoration: InputDecoration(labelText: 'Marks 3'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter marks 3';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              // Subject 4
              TextFormField(
                controller: _subject4Controller,
                decoration: InputDecoration(labelText: 'Subject 4'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter subject 4';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _marks4Controller,
                decoration: InputDecoration(labelText: 'Marks 4'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter marks 4';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              // Subject 5
              TextFormField(
                controller: _subject5Controller,
                decoration: InputDecoration(labelText: 'Subject 5'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter subject 5';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _marks5Controller,
                decoration: InputDecoration(labelText: 'Marks 5'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter marks 5';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final examMark = ExamMark(
                      studentName: _studentNameController.text,
                      registerNumber: _registerNumberController.text,
                      subject1: _subject1Controller.text,
                      marks1: int.parse(_marks1Controller.text),
                      subject2: _subject2Controller.text,
                      marks2: int.parse(_marks2Controller.text),
                      subject3: _subject3Controller.text,
                      marks3: int.parse(_marks3Controller.text),
                      subject4: _subject4Controller.text,
                      marks4: int.parse(_marks4Controller.text),
                      subject5: _subject5Controller.text,
                      marks5: int.parse(_marks5Controller.text),
                    );
                    await _dbHelper.insertExamMark(examMark);
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

class ExamMarksListPage extends StatefulWidget {
  @override
  _ExamMarksListPageState createState() => _ExamMarksListPageState();
}

class _ExamMarksListPageState extends State<ExamMarksListPage> {
  final _dbHelper = DatabaseHelper();
  late Future<List<ExamMark>> _examMarksList;

  @override
  void initState() {
    super.initState();
    _examMarksList = _dbHelper.getAllExamMarks();
  }

  Future<void> _refreshExamMarks() async {
    setState(() {
      _examMarksList = _dbHelper.getAllExamMarks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:common_appbar("Exam Marks"),
      body: FutureBuilder<List<ExamMark>>(
        future: _examMarksList,
        builder: (context, examMarksSnapshot) {
          if (examMarksSnapshot.hasData) {
            return ListView.builder(
              itemCount: examMarksSnapshot.data!.length,
              itemBuilder: (context, index) {
                final examMark = examMarksSnapshot.data![index];
                int totalMarks = examMark.marks1 +
                    examMark.marks2 +
                    examMark.marks3 +
                    examMark.marks4 +
                    examMark.marks5;

                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.grey.shade50,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            "Student Name : ${examMark.studentName}",
                            style: commonstylepoppins(size: 15,color: Colors.red,weight: FontWeight.w500),
                          ),
                          Text(
                            "Register Number : ${examMark.registerNumber}",
                            style: commonstylepoppins(size: 15,color: Colors.red,weight: FontWeight.w500),
                          ),
                          DataTable(
                            columns: <DataColumn>[
                              DataColumn(
                                label: Text(
                                  'Subject',
                                  style: commonstylepoppins(weight: FontWeight.w800, size: 15),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Marks',
                                  style: commonstylepoppins(weight: FontWeight.w800, size: 15),
                                ),
                              ),
                            ],
                            rows: <DataRow>[
                              DataRow(cells: <DataCell>[
                                DataCell(
                                  Text(
                                    examMark.subject1,
                                    style: commonstylepoppins(weight: FontWeight.w800),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    "${examMark.marks1}/100".toString(),
                                    style: commonstylepoppins(weight: FontWeight.w500),
                                  ),
                                ),
                              ]),
                              DataRow(cells: <DataCell>[
                                DataCell(
                                  Text(
                                    examMark.subject2,
                                    style: commonstylepoppins(weight: FontWeight.w800),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    "${examMark.marks2}/100".toString(),
                                    style: commonstylepoppins(weight: FontWeight.w500),
                                  ),
                                ),
                              ]),
                              DataRow(cells: <DataCell>[
                                DataCell(
                                  Text(
                                    examMark.subject3,
                                    style: commonstylepoppins(weight: FontWeight.w800),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    "${examMark.marks3}/100".toString(),
                                    style: commonstylepoppins(weight: FontWeight.w500),
                                  ),
                                ),
                              ]),
                              DataRow(cells: <DataCell>[
                                DataCell(
                                  Text(
                                    examMark.subject4,
                                    style: commonstylepoppins(weight: FontWeight.w800),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    "${examMark.marks4}/100".toString(),
                                    style: commonstylepoppins(weight: FontWeight.w500),
                                  ),
                                ),
                              ]),
                              DataRow(cells: <DataCell>[
                                DataCell(
                                  Text(
                                    examMark.subject5,
                                    style: commonstylepoppins(weight: FontWeight.w800),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    "${examMark.marks5}/100".toString(),
                                    style: commonstylepoppins(weight: FontWeight.w500),
                                  ),
                                ),
                              ]),
                            ],
                          ),
                          SizedBox(height: 10), // Add some spacing
                          Text(
                            "Total Marks: ${totalMarks}/500",
                            style: commonstylepoppins(
                                weight: FontWeight.w600, size: 16, color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (examMarksSnapshot.hasError) {
            return Center(child: Text('Error: ${examMarksSnapshot.error}'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddExamMarkPage()),
          );
          if (result == true) {
            _refreshExamMarks();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}