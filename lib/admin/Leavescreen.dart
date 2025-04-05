import 'package:edu_tech/Common/Textstyle.dart';
import 'package:edu_tech/common_appbar.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';

class LeaveApplication {
  final int? id;
  final String studentName;
  final String registerNumber;
  final String regarding;
  final String description;
  final DateTime date;
  String status; // 'Pending', 'Approved', 'Rejected'

  LeaveApplication({
    this.id,
    required this.studentName,
    required this.registerNumber,
    required this.regarding,
    required this.description,
    required this.date,
    this.status = 'Pending',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentName': studentName,
      'registerNumber': registerNumber,
      'regarding': regarding,
      'description': description,
      'date': date.toIso8601String(),
      'status': status,
    };
  }

  static LeaveApplication fromMap(Map<String, dynamic> map) {
    return LeaveApplication(
      id: map['id'],
      studentName: map['studentName'],
      registerNumber: map['registerNumber'],
      regarding: map['regarding'],
      description: map['description'],
      date: DateTime.parse(map['date']),
      status: map['status'],
    );
  }
}

// Database Helper
class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'leave_applications.db');
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE leave_applications(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        studentName TEXT,
        registerNumber TEXT,
        regarding TEXT,
        description TEXT,
        date TEXT,
        status TEXT
      )
    ''');
  }

  Future<int> insertLeaveApplication(LeaveApplication application) async {
    final db = await database;
    return await db.insert('leave_applications', application.toMap());
  }

  Future<List<LeaveApplication>> getAllLeaveApplications() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('leave_applications');
    return List.generate(maps.length, (i) {
      return LeaveApplication.fromMap(maps[i]);
    });
  }

  Future<int> updateLeaveApplicationStatus(int id, String status) async {
    final db = await database;
    return await db.update(
      'leave_applications',
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

// Student Screen
class StudentLeaveApplicationPage extends StatefulWidget {
  @override
  _StudentLeaveApplicationPageState createState() =>
      _StudentLeaveApplicationPageState();
}

class _StudentLeaveApplicationPageState
    extends State<StudentLeaveApplicationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _studentNameController = TextEditingController();
  final TextEditingController _registerNumberController = TextEditingController();
  final TextEditingController _regardingController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  final _dbHelper = DatabaseHelper();

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
      appBar: AppBar(title: Text('Leave Application')),
      body: Padding(
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
              TextFormField(
                controller: _regardingController,
                decoration: InputDecoration(labelText: 'Regarding'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter regarding';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),
              Row(
                children: <Widget>[
                  Text('Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}'),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final application = LeaveApplication(
                      studentName: _studentNameController.text,
                      registerNumber: _registerNumberController.text,
                      regarding: _regardingController.text,
                      description: _descriptionController.text,
                      date: _selectedDate,
                    );
                    await _dbHelper.insertLeaveApplication(application);
                    Navigator.pop(context, true);
                  }
                },
                child: Text('Send Request'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Teacher Screen
class TeacherLeaveApplicationListPage extends StatefulWidget {
  @override
  _TeacherLeaveApplicationListPageState createState() =>
      _TeacherLeaveApplicationListPageState();
}

class _TeacherLeaveApplicationListPageState
    extends State<TeacherLeaveApplicationListPage> {
  final _dbHelper = DatabaseHelper();
  late Future<List<LeaveApplication>> _applications;

  @override
  void initState() {
    super.initState();
    _applications = _dbHelper.getAllLeaveApplications();
  }

  Future<void> _refreshApplications() async {
    setState(() {
      _applications = _dbHelper.getAllLeaveApplications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: common_appbar("Leave Applications"),
      body: FutureBuilder<List<LeaveApplication>>(
        future: _applications,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final application = snapshot.data![index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.grey.shade50,
                    child: ListTile(
                      title: Text(application.studentName,style: commonstylepoppins(size: 15,weight: FontWeight.w800),),
                      subtitle: Text(
                          '${application.regarding} - ${DateFormat('yyyy-MM-dd').format(application.date)}',style: commonstylepoppins(),),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(application.status,style: commonstylepoppins(weight: FontWeight.w800,color: Colors.blue),),
                          if (application.status == 'Pending')
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.check, color: Colors.green),
                                  onPressed: () async {
                                    await _dbHelper.updateLeaveApplicationStatus(
                                        application.id!, 'Approved');
                                    _refreshApplications();
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.close, color: Colors.red),
                                  onPressed: () async {
                                    await _dbHelper.updateLeaveApplicationStatus(
                                        application.id!, 'Rejected');
                                    _refreshApplications();
                                  },
                                ),
                              ],
                            ),
                        ],
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
    );
  }
}