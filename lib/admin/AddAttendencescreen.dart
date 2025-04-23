import 'package:edu_tech/Common/Textstyle.dart';
import 'package:edu_tech/common_appbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Attendance {
  final int? id;
  final String studentName;
  final String teacherName;
  final DateTime date;
  final bool present;

  Attendance({
    this.id,
    required this.studentName,
    required this.teacherName,
    required this.date,
    required this.present,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentName': studentName,
      'teacherName': teacherName,
      'date': date.toIso8601String(),
      'present': present ? 1 : 0,
    };
  }

  static Attendance fromMap(Map<String, dynamic> map) {
    return Attendance(
      id: map['id'],
      studentName: map['studentName'],
      teacherName: map['teacherName'],
      date: DateTime.parse(map['date']),
      present: map['present'] == 1,
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
    String path = join(await getDatabasesPath(), 'attendance_database.db');
    print('Database Path: $path');
    return await openDatabase(path, version: 3, onCreate: _createDb,onUpgrade: _upgradeDb,);
  }

  Future<void> _upgradeDb(Database db, int oldVersion, int newVersion) async{
    if (oldVersion < 3){
      await db.execute('''
        ALTER TABLE attendance ADD COLUMN studentName TEXT;
      ''');
    }
  }
  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
    CREATE TABLE attendance(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      studentName TEXT,
      teacherName TEXT,
      date TEXT,
      present INTEGER
    )
  ''');
  }

  Future<int> insertAttendance(Attendance attendance) async {
    final db = await database;
    return await db.insert('attendance', attendance.toMap());
  }

  Future<List<Attendance>> getAllAttendance() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('attendance');
    return List.generate(maps.length, (i) {
      return Attendance.fromMap(maps[i]);
    });
  }
}

class AddAttendancePage extends StatefulWidget {
  @override
  _AddAttendancePageState createState() => _AddAttendancePageState();
}

class _AddAttendancePageState extends State<AddAttendancePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _teacherNameController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  final _dbHelper = DatabaseHelper();
  List<String> _studentNames = [
    'Alice',
    'Bob',
    'Charlie',
    'David',
    'Eve',
    'Frank',
    'Grace',
    'Henry',
    'Ivy',
    'Jack'
  ];
  Map<String, bool> _studentAttendance = {};

  @override
  void initState() {
    super.initState();
    for (var name in _studentNames) {
      _studentAttendance[name] = true;
    }
  }

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
      appBar: AppBar(title: Text('Mark Attendance')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _teacherNameController,
                decoration: InputDecoration(labelText: 'Teacher Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter teacher name';
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
              Expanded(
                child: ListView.builder(
                  itemCount: _studentNames.length,
                  itemBuilder: (context, index) {
                    final name = _studentNames[index];
                    return CheckboxListTile(
                      title: Text(name),
                      value: _studentAttendance[name],
                      onChanged: (value) {
                        setState(() {
                          _studentAttendance[name] = value!;
                        });
                      },
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      for (var studentName in _studentNames) {
                        final attendance = Attendance(
                          studentName: studentName,
                          teacherName: _teacherNameController.text,
                          date: _selectedDate,
                          present: _studentAttendance[studentName]!,
                        );
                        await _dbHelper.insertAttendance(attendance);
                      }
                      Navigator.pop(context, true);
                    } catch (e) {
                      print('Error inserting attendance: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error saving attendance')));
                    }
                  }
                },
                child: Text('Save Attendance'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AttendanceListPage extends StatefulWidget {
  @override
  _AttendanceListPageState createState() => _AttendanceListPageState();
}

class _AttendanceListPageState extends State<AttendanceListPage> {
  final _dbHelper = DatabaseHelper();
  late Future<List<Attendance>> _attendanceList;

  @override
  void initState() {
    super.initState();
    _attendanceList = _dbHelper.getAllAttendance();
  }

  Future<void> _refreshAttendance() async {
    setState(() {
      _attendanceList = _dbHelper.getAllAttendance();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: common_appbar("Attendance"),
      body: FutureBuilder<List<Attendance>>(
        future: _attendanceList,
        builder: (context, attendanceSnapshot) {
          if (attendanceSnapshot.hasData) {
            return ListView.builder(
              itemCount: attendanceSnapshot.data!.length,
              itemBuilder: (context, index) {
                final attendance = attendanceSnapshot.data![index];
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Card(
                    color: Colors.white,
                    elevation: 2,
                    child: ListTile(
                      title: Text(attendance.studentName,style: commonstylepoppins(size: 15,weight: FontWeight.w800),),
                      subtitle: Text(
                          'Teacher: ${attendance.teacherName}, Date: ${DateFormat('yyyy-MM-dd').format(attendance.date)}',style: commonstylepoppins(),),
                      trailing: Text(attendance.present ? 'Present' : 'Absent',style: commonstylepoppins(weight: FontWeight.w800,color: attendance.present?Colors.green:Colors.red,size: 15),),
                    ),
                  ),
                );
              },
            );
          } else if (attendanceSnapshot.hasError) {
            return Center(child: Text('Error: ${attendanceSnapshot.error}'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddAttendancePage()),
          );
          if (result == true) {
            _refreshAttendance();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}