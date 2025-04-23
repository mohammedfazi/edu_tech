import 'dart:async';

import 'package:edu_tech/Common/Textstyle.dart';
import 'package:edu_tech/Loginsplit_screen.dart';
import 'package:flutter/material.dart';

import 'Common/Color_Constant.dart';
import 'Loginscreen.dart';

class splashscreen extends StatefulWidget {
  const splashscreen({super.key});

  @override
  State<splashscreen> createState() => _splashscreenState();
}

class _splashscreenState extends State<splashscreen> {

  void splashfun(){

    Timer(Duration(seconds: 2), (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Loginsplit()));
    });

  }
  @override
  void initState() {
splashfun();
super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        // child: Image.asset("Assets/logo.png"),
        child: Text("Edu Nest",style: commonstylepoppins(size: 30,weight: FontWeight.w800,color: Colors.blue.shade900),),
      ),
    );
  }
}
