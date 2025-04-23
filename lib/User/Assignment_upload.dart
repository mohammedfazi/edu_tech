import 'dart:io';
import 'package:edu_tech/Common/Textstyle.dart';
import 'package:edu_tech/Widget/Alerttoastdialog.dart';
import 'package:edu_tech/common_appbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:image/image.dart' as img;
import 'dart:typed_data';
import 'package:get/get.dart';

class AssignmentUploadPage extends StatefulWidget {
  const AssignmentUploadPage({super.key});

  @override
  _AssignmentUploadPageState createState() => _AssignmentUploadPageState();
}

class _AssignmentUploadPageState extends State<AssignmentUploadPage> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? _image;
  final picker = ImagePicker();
  late Database _database;
  bool _isDatabaseInitialized = false;

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    try {
      final databasePath = await getDatabasesPath();
      final path = join(databasePath, 'assignment_db.db');
      _database = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute(
            'CREATE TABLE assignments (id INTEGER PRIMARY KEY AUTOINCREMENT, subject TEXT, description TEXT, image BLOB)',
          );
        },
      );
      _isDatabaseInitialized = true;
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print("Error initializing database: $e");
      if (mounted) {
        // _showErrorDialog("Failed to initialize database. The app may not function correctly.");
      }
    }
  }

  // void _showErrorDialog(String message) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Error'),
  //         content: Text(message),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: const Text('OK'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Future<void> _getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    } else {
      print('No image selected.');
    }
  }

  Future<void> _uploadAssignment() async {
    if (!_isDatabaseInitialized) {
      // _showErrorDialog("Database is not initialized. Please try again later.");
      return;
    }
    if (_formKey.currentState!.validate()) {
      if (_image == null) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(
        //     content: Text('Please select an image.'),
        //   ),
        // );
        return;
      }

      try {
        final imageBytes = await _image!.readAsBytes();
        final resizedImage = img.decodeImage(imageBytes);
        if (resizedImage == null) {
          throw Exception('Failed to decode image');
        }
        final resizedBytes = img.encodeJpg(resizedImage, quality: 70);

        await _database.insert(
          'assignments',
          {
            'subject': _subjectController.text,
            'description': _descriptionController.text,
            'image': resizedBytes,
          },
        );

        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(
        //     content: Text('Assignment uploaded successfully!'),
        //   ),
        // );
        Get.back();
        _subjectController.clear();
        _descriptionController.clear();
        setState(() {
          _image = null;
        });
      } catch (e) {
        print("Error uploading assignment: $e");
        // _showErrorDialog("Failed to upload assignment. Please try again.");
      }
    }
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    if (_isDatabaseInitialized) {
      _database.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: common_appbar("Upload Assignment"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  controller: _subjectController,
                  decoration: const InputDecoration(
                    labelText: 'Subject',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter subject';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter description';
                    }
                    return null;
                  },
                  maxLines: 3,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _getImage,
                  child: const Text('Select Image'),
                ),
                const SizedBox(height: 10),
                if (_image != null)
                  Image.file(
                    _image!,
                    height: 100,
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isDatabaseInitialized ? _uploadAssignment : null,
                  child: Text(_isDatabaseInitialized ? 'Upload Assignment' : 'Uploading...'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AssignmentListPage extends StatefulWidget {
  const AssignmentListPage({super.key});

  @override
  State<AssignmentListPage> createState() => _AssignmentListPageState();
}

class _AssignmentListPageState extends State<AssignmentListPage> {
  late Database _database;
  List<Map<String, dynamic>> _assignments = [];
  bool _isDatabaseInitialized = false;

  @override
  void initState() {
    super.initState();
    _initDatabaseAndFetchAssignments();
    _fetchAssignments();
  }

  Future<void> _initDatabaseAndFetchAssignments() async {
    try {
      final databasePath = await getDatabasesPath();
      final path = join(databasePath, 'assignment_db.db');
      _database = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute(
            'CREATE TABLE assignments (id INTEGER PRIMARY KEY AUTOINCREMENT, subject TEXT, description TEXT, image BLOB)',
          );
        },
      );
      _isDatabaseInitialized = true;
      await _fetchAssignments();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print("Error initializing database: $e");
      if (mounted) {
        // Optionally show an error message here as well
      }
    }
  }

  Future<void> _fetchAssignments() async {
    if (_isDatabaseInitialized) {
      try {
        final List<Map<String, dynamic>> assignments = await _database.query('assignments');
        setState(() {
          _assignments = assignments;
        });
      } catch (e) {
        print("Error fetching assignments: $e");
        // Optionally show an error message
      }
    }
  }

  @override
  void dispose() {
    if (_isDatabaseInitialized) {
      _database.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: common_appbar("Assignment List"),
      body: _isDatabaseInitialized
          ? _assignments.isEmpty
          ? const Center(child: Text('No assignments uploaded yet.'))
          : ListView.builder(
        itemCount: _assignments.length,
        itemBuilder: (context, index) {
          final assignment = _assignments[index];
          final imageData = assignment['image'] as List<int>?;
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Subject: ${assignment['subject']}', style: commonstylepoppins(size: 15,weight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  Text('Description: ${assignment['description']}',style: commonstylepoppins(size: 12,weight: FontWeight.w500),),
                  const SizedBox(height: 8),
                  if (imageData != null)
                    Image.memory(
                      Uint8List.fromList(imageData),
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                ],
              ),
            ),
          );
        },
      )
          : const Center(child: CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(AssignmentUploadPage());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}