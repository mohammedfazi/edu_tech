import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle commonstylepoppins({double size=12.0,Color color =Colors.black,FontWeight weight=FontWeight.w300}){
  return GoogleFonts.poppins(
    fontSize: size,
    fontWeight: weight,
    color: color,
    letterSpacing: 0.15

  );
}
TextStyle commonstylefair({double size=12.0,Color color =Colors.black,FontWeight weight=FontWeight.w300}){
  return GoogleFonts.playfair(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: 0.15

  );
}

TextStyle commonstyleplusjakarta({double size=12.0,Color color =Colors.black,FontWeight weight=FontWeight.w300}){
  return GoogleFonts.plusJakartaSans(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: 0.15
  );
}

TextStyle btnstyle(){
  return GoogleFonts.poppins(
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.21
  );
}