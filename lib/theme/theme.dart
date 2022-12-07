import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';

class PairTaskerTheme {
  PairTaskerTheme._();

  static TextStyle title1 = GoogleFonts.poppins(
    fontSize: 35,
    fontWeight: FontWeight.bold,
  );

  static TextStyle title2 = GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.bold,
  );

  static TextStyle title3 = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static TextStyle inputLabel =
      GoogleFonts.lato(fontSize: 14, color: HexColor('#99A4AE'));

  static TextStyle buttonText = GoogleFonts.lato(
    fontSize: 16,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );
}
