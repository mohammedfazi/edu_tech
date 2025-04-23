import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Common/Textstyle.dart';
import '../admin/AddAttendencescreen.dart';
import '../common_appbar.dart';

class Userattendencescreen extends StatefulWidget {
  const Userattendencescreen({super.key});

  @override
  State<Userattendencescreen> createState() => _UserattendencescreenState();
}

class _UserattendencescreenState extends State<Userattendencescreen> {
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
    return  Scaffold(
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
    );
  }
}
