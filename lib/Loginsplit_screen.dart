import 'package:edu_tech/Common/Commonsize.dart';
import 'package:edu_tech/Common/Textstyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'Loginscreen.dart';
import 'Loginscreen1.dart';


class Loginsplit extends StatefulWidget {
  const Loginsplit({super.key});

  @override
  State<Loginsplit> createState() => _LoginsplitState();
}

class _LoginsplitState extends State<Loginsplit> {
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        body: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Text("Welcome To Edu Nest",style: commonstylepoppins(size: 18,weight: FontWeight.w800),),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: InkWell(
                            onTap: (){
                              Get.to(Loginscreen1());
                            },
                            child: Container(
                              height: displayheight(context)*0.25,
                              width: displaywidth(context)*0.45,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.white
                              ),
                              child: const Center(
                                child: CircleAvatar(
                                  radius: 80,
                                  backgroundImage: AssetImage("Assets/img.png"),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:15.0,left: 8.0,right: 8.0),
                          child: Text("Admin/Teachers \n        Login",style: commonstylepoppins(size: 15,weight: FontWeight.w800),),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: InkWell(
                            onTap: (){
                              Get.to(Loginscreen());
                            },
                            child: Container(
                              height: displayheight(context)*0.25,
                              width: displaywidth(context)*0.45,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.white
                              ),
                              child: const Center(
                                child: CircleAvatar(
                                  radius: 80,
                                  backgroundImage: AssetImage("Assets/img_1.png"),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:15.0,left: 8.0,right: 8.0),
                          child: Text("Parent/Students \n    Login",style: commonstylepoppins(size: 15,weight: FontWeight.w800),),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}