import 'package:flutter/material.dart';

import '../Common/Textstyle.dart';
import '../admin/AddExammarksscreen.dart';
import '../common_appbar.dart';

class Userexamscreen extends StatefulWidget {
  const Userexamscreen({super.key});

  @override
  State<Userexamscreen> createState() => _UserexamscreenState();
}

class _UserexamscreenState extends State<Userexamscreen> {

  final _dbHelper = DatabaseHelper();
  late Future<List<ExamMark>> _examMarksList;

  @override
  void initState() {
    super.initState();
    _examMarksList = _dbHelper.getAllExamMarks();
    _refreshExamMarks();
  }

  Future<void> _refreshExamMarks() async {
    setState(() {
      _examMarksList = _dbHelper.getAllExamMarks();
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
    );
  }
}
