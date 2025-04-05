import 'package:flutter/material.dart';

import '../Common/Textstyle.dart';


  void alerttoastgreen(BuildContext context,String txt){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration:const Duration(seconds: 1),
          backgroundColor: Colors.green,
            content: Text(txt,style: commonstylepoppins(weight: FontWeight.w500),)));}


  void alerttoastred(BuildContext context,String txt){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            duration:const Duration(seconds: 1),
            backgroundColor: Colors.red,
            content: Text(txt,style: commonstylepoppins(weight: FontWeight.w500),)));}

