import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

mystyle(double size,
    [Color color = Colors.white, FontWeight fw = FontWeight.w700]) {
  return GoogleFonts.montserrat(fontSize: size, color: color, fontWeight: fw);
}

String productIdFromUuid(Uuid id) {
  return "Skew_$id";
}
