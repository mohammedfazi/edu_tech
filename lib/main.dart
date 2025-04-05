import 'package:edu_tech/User/UserDashboardscreen.dart';
import 'package:edu_tech/admin/AdminDashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white
      ),
      debugShowCheckedModeBanner: false,
      home: Userdashboardscreen(),
    );
  }
}


