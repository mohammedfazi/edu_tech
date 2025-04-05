import 'package:flutter/material.dart';

Size displaysize(BuildContext context){
  return MediaQuery.of(context).size;
}

double displayheight(BuildContext context){
  return displaysize(context).height;
}

double displaywidth(BuildContext context){
  return displaysize(context).width;
}