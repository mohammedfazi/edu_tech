import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Common/Textstyle.dart';

Widget commontextfield(String txt,controller, {TextInputType type=TextInputType.text,int lines=1}){
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextFormField(
      cursorColor: Colors.black,
      keyboardType: type,
      maxLines: lines,
      controller: controller,
      style: commonstylepoppins(size: 15,weight: FontWeight.w500,color: Colors.black),
      decoration: InputDecoration(
        hintText: txt,
        isDense: true,
        contentPadding: EdgeInsets.all(12),
        hintStyle: commonstylepoppins(size: 14,color: Colors.black),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.black)),
        ),
    ),
  );
}