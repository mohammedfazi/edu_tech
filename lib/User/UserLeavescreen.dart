import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Common/Textstyle.dart';
import '../admin/Leavescreen.dart';
import '../common_appbar.dart';

class Userleavescreen extends StatefulWidget {
  const Userleavescreen({super.key});

  @override
  State<Userleavescreen> createState() => _UserleavescreenState();
}

class _UserleavescreenState extends State<Userleavescreen> {
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
    return  Scaffold(
      appBar: common_appbar("Leave Applications"),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StudentLeaveApplicationPage()),
          );
        },
        child: Icon(Icons.add),
      ),
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
                          // if (application.status == 'Pending')
                          //   Row(
                          //     children: [
                          //       IconButton(
                          //         icon: Icon(Icons.check, color: Colors.green),
                          //         onPressed: () async {
                          //           await _dbHelper.updateLeaveApplicationStatus(
                          //               application.id!, 'Approved');
                          //           _refreshApplications();
                          //         },
                          //       ),
                          //       IconButton(
                          //         icon: Icon(Icons.close, color: Colors.red),
                          //         onPressed: () async {
                          //           await _dbHelper.updateLeaveApplicationStatus(
                          //               application.id!, 'Rejected');
                          //           _refreshApplications();
                          //         },
                          //       ),
                          //     ],
                          //   ),
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
