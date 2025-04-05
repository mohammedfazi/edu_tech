import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'Common/Textstyle.dart';

AppBar common_appbar(txt){
  return AppBar(
    backgroundColor: Colors.grey.shade50,
    leading: IconButton(onPressed: (){
      Get.back();
    }, icon: Icon(Icons.arrow_back_ios_new_rounded,color: Colors.black,)),
    centerTitle: true,
    title: Text(txt,style: commonstylepoppins(color: Colors.black,weight: FontWeight.w700,size: 15),),
  );
}