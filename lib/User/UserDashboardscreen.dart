import 'package:carousel_slider/carousel_slider.dart';
import 'package:edu_tech/User/UserExamscreen.dart';
import 'package:edu_tech/User/UserHomeworkscreen.dart';
import 'package:edu_tech/User/UserNotesscreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Common/Commonsize.dart';
import '../Common/Textstyle.dart';
import '../admin/AddAttendencescreen.dart';
import '../admin/AdminDashboard.dart';
import '../admin/Leavescreen.dart';
import '../admin/Newsscreen.dart';
import '../admin/Openlibraryscreen.dart';
import 'Bus/Bustracting.dart';


class Userdashboardscreen extends StatefulWidget {
  const Userdashboardscreen({super.key});

  @override
  State<Userdashboardscreen> createState() => _UserdashboardscreenState();
}

class _UserdashboardscreenState extends State<Userdashboardscreen> {

  final List<GridItem> gridItems = [
    GridItem(icon: Icons.home, name: 'Homework', screen: Userhomeworkscreen()),
    GridItem(icon: Icons.map, name: 'Bus Tracing', screen: Bustractingscreen()),
    GridItem(icon: Icons.event, name: 'Attendance', screen: AttendanceListPage()),
    GridItem(icon: Icons.rss_feed, name: 'News Feed', screen: NewsScreen()),
    GridItem(icon: Icons.notes, name: 'Notes', screen: Usernotesscreen()),
    GridItem(icon: Icons.library_books, name: 'Open Library', screen: OpenLibraryScreen()),
    GridItem(icon: Icons.grading, name: 'Exam Mark', screen: Userexamscreen()),
    GridItem(icon: Icons.calendar_today, name: 'Leave Application', screen: TeacherLeaveApplicationListPage()), // Added Leave Application
  ];

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        automaticallyImplyLeading: false,
        title: Text("Edu Nest",style: commonstylepoppins(color: Colors.black,weight: FontWeight.w700,size: 15),),
      ),
      body:SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: CarouselSlider(
                    items: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.asset("Assets/banner1.jpg", fit: BoxFit.fill)),
                      ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.asset("Assets/banner2.jpg", fit: BoxFit.fill)),
                      ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.asset("Assets/banner3.png", fit: BoxFit.fill)),
                    ],
                    options: CarouselOptions(
                      height: displayheight(context) * 0.25,
                      aspectRatio: 16 / 8,
                      viewportFraction: 0.7,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                      autoPlayAnimationDuration: const Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      enlargeFactor: 0.3,
                      scrollDirection: Axis.horizontal,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Edu Nest Categories",style: commonstylepoppins(),),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
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
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("About Edu Nest",style: commonstylepoppins(weight: FontWeight.w800),),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Maintain detailed student profiles, including contact information, academic history, and more.Effortlessly record and monitor student attendance, providing valuable insights into student engagement.",style: commonstylepoppins(),),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Streamline leave application processes, allowing students to submit requests and educators to approve or reject them seamlessly.Access a vast digital library with search and download capabilities, enriching the learning experience.",style: commonstylepoppins(),),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Facilitate effective communication between educators, students, and parents through integrated messaging and notification systems.",style: commonstylepoppins(),),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
