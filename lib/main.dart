import 'package:edu_tech/Splashscreen.dart';
import 'package:edu_tech/User/UserDashboardscreen.dart';
import 'package:edu_tech/admin/AdminDashboard.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAED7h0zurJFSP-UDkbEvyX--xRpEl93iE",
      appId: "1:572016178823:android:d8700c1c3ee212cb652a22",
      messagingSenderId: "572016178823",
      projectId: "exploreeasy-1d801",
    ),
  );
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


