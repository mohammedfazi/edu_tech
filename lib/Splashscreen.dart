import 'dart:async';

import 'package:edu_tech/Common/Textstyle.dart';
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
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Loginscreen()));
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
      backgroundColor: Color_Constant.primarycolor,
      body: Center(
        // child: Image.asset("Assets/logo.png"),
        child: Text("E-Campus",style: commonstylepoppins(size: 30,weight: FontWeight.w800),),
      ),
    );
  }
}
