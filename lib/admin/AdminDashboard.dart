import 'package:edu_tech/User/Bus/Bustracting.dart';
import 'package:edu_tech/admin/AddAttendencescreen.dart';
import 'package:edu_tech/admin/AddExammarksscreen.dart';
import 'package:edu_tech/admin/AddHomeworkscreen.dart';
import 'package:edu_tech/admin/AddNotes_screen.dart';
import 'package:edu_tech/admin/Addeventscreen.dart';
import 'package:edu_tech/admin/Leavescreen.dart';
import 'package:edu_tech/admin/Newsscreen.dart';
import 'package:edu_tech/admin/Openlibraryscreen.dart';
import 'package:edu_tech/common_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Common/Commonsize.dart';
import '../Common/Textstyle.dart';
import '../Loginscreen.dart';

class GridItem {
  final IconData icon;
  final String name;
  final Widget screen;

  GridItem({required this.icon, required this.name, required this.screen});
}
class Admindashboardscreen extends StatefulWidget {
  const Admindashboardscreen({super.key});

  @override
  State<Admindashboardscreen> createState() => _AdmindashboardscreenState();
}

class _AdmindashboardscreenState extends State<Admindashboardscreen> {

  final List<GridItem> gridItems = [
    GridItem(icon: Icons.home, name: 'Assignment', screen: HomeworkListPage()),
    GridItem(icon: Icons.map, name: 'Bus Tracing', screen: Bustractingscreen()),
    GridItem(icon: Icons.event, name: 'Attendance', screen: AttendanceListPage()),
    GridItem(icon: Icons.rss_feed, name: 'News Feed', screen: NewsScreen()),
    GridItem(icon: Icons.notes, name: 'Notes', screen: NotesListPage()),
    GridItem(icon: Icons.library_books, name: 'Open Library', screen: OpenLibraryScreen()),
    GridItem(icon: Icons.grading, name: 'Exam Mark', screen: ExamMarksListPage()),
    GridItem(icon: Icons.calendar_today, name: 'Leave Application', screen: TeacherLeaveApplicationListPage()), // Added Leave Application
    GridItem(icon: Icons.event, name: 'Events', screen: GetEventScreen()), // Added Leave Application

  ];

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: (){
            logout();
          }, icon: Icon(Icons.logout,color: Colors.black,))
        ],
        title: Text("Admin Dashboard",style: commonstylepoppins(color: Colors.black,weight: FontWeight.w700,size: 15),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 2 columns
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.0, // Square items
                ),
                itemCount: gridItems.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Get.to(gridItems[index].screen);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        border: Border.all(color: Colors.blue), // Border color
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(gridItems[index].icon, size: 40),
                          SizedBox(height: 8),
                          Text(gridItems[index].name,style: commonstylepoppins(weight: FontWeight.w800),textAlign: TextAlign.center,),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> logout() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            title: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
            content: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                "Are you sure you want to logout the Edu Nest.",
                style: commonstylepoppins(
                  color: Colors.black,
                  weight: FontWeight.w400,
                  size: 15,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: displaywidth(context) * 0.30,
                    child: TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Center(
                            child: Text(
                              "No",
                              style: commonstylepoppins(color: Colors.black),
                            ))),
                  ),
                  SizedBox(
                    width: displaywidth(context) * 0.30,
                    child: TextButton(
                        onPressed: () {
                          Get.to(const Loginscreen());
                        },
                        child: Center(
                            child: Text(
                              "Yes",
                              style: commonstylepoppins(color: Colors.black),
                            ))),
                  )
                ],
              )
            ],
          );
        });
  }
}
