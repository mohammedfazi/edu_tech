import 'package:carousel_slider/carousel_slider.dart';
import 'package:edu_tech/User/Assignment_upload.dart';
import 'package:edu_tech/User/Chatbot.dart';
import 'package:edu_tech/User/UserAttendencescreen.dart';
import 'package:edu_tech/User/UserEventscreen.dart';
import 'package:edu_tech/User/UserExamscreen.dart';
import 'package:edu_tech/User/UserHomeworkscreen.dart';
import 'package:edu_tech/User/UserLeavescreen.dart';
import 'package:edu_tech/User/UserNotesscreen.dart';
import 'package:edu_tech/admin/Addeventscreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Common/Color_Constant.dart';
import '../Common/Commonsize.dart';
import '../Common/Textstyle.dart';
import '../Loginscreen.dart';
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
    GridItem(icon: Icons.home, name: 'Assignment', screen: Userhomeworkscreen()),
    GridItem(icon: Icons.map, name: 'Bus Tracing', screen: Bustractingscreen()),
    GridItem(icon: Icons.event, name: 'Attendance', screen: Userattendencescreen()),
    GridItem(icon: Icons.rss_feed, name: 'News Feed', screen: NewsScreen()),
    GridItem(icon: Icons.notes, name: 'Notes', screen: Usernotesscreen()),
    GridItem(icon: Icons.library_books, name: 'Open Library', screen: OpenLibraryScreen()),
    GridItem(icon: Icons.grading, name: 'Exam Mark', screen: Userexamscreen()),
    GridItem(icon: Icons.calendar_today, name: 'Leave Application', screen: Userleavescreen()), // Added Leave Application
    GridItem(icon: Icons.chat_rounded, name: 'Chat Bot', screen: EduNestChatbot()),
    GridItem(icon: Icons.event, name: 'Events', screen: Usereventscreen()),
    GridItem(icon: Icons.assessment, name: 'Assigment Upload', screen: AssignmentListPage()),

  ];

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text("Edu Nest",style: commonstylepoppins(color: Colors.black,weight: FontWeight.w700,size: 15),),
        actions: [
          IconButton(onPressed: (){
            logout();
          }, icon: Icon(Icons.logout,color: Colors.black,))
        ],
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
                child: Text("Edu Nest Categories",style: commonstylepoppins(weight: FontWeight.w800,size: 15),),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0), // Increased padding for better spacing
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16, // Increased spacing
                    mainAxisSpacing: 16, // Increased spacing
                    childAspectRatio: 1.0,
                  ),
                  itemCount: gridItems.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Get.to(gridItems[index].screen);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient( // Added gradient background
                            colors: [
                              Colors.blue.shade200,
                              Colors.blue.shade50,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12), // Rounded corners
                          boxShadow: [ // Added subtle shadow
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              gridItems[index].icon,
                              size: 40,
                              color: Colors.blue.shade800, // Darker icon color
                            ),
                            SizedBox(height: 12), // Increased spacing
                            Text(
                              gridItems[index].name,
                              style: commonstylepoppins(
                                weight: FontWeight.w700, // Slightly lighter weight
                                size: 14, // Adjusted font size
                              ),
                              textAlign: TextAlign.center,
                            ),
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
