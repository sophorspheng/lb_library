import 'package:flutter/material.dart';

class AppColor {
  //===============================================
  // Primary Color
  //===============================================
  static const primary = Color(0xFF0A8B53);
  static const primaryHex = 'FF0A8B53';
  static const secondary = Color(0xFFDEB72D);
  static const primaryColors = [primary];

  static const buttonLight = Color.fromRGBO(232, 233, 243, 1);
  static const buttonDark = Color.fromRGBO(37, 48, 63, 1);

  //===============================================
  // Descriptive Color
  //===============================================
  static const highlight = Color.fromRGBO(59, 143, 205, 1);
  static const success = Color.fromRGBO(2, 200, 132, 1);
  static const error = Color.fromRGBO(236, 102, 102, 1);
  static const info = Colors.blue;
  static const warning = Colors.amber;
  static const active = Color.fromRGBO(2, 200, 132, 1);
  static const inactive = Color.fromRGBO(236, 102, 102, 1);

  //===============================================
  // App Color
  //===============================================
  static const black = Color.fromRGBO(27, 33, 44, 1);
  static const white = Colors.white;

  //===============================================
  // Screen Background
  //===============================================
  static const background = Color.fromRGBO(234, 241, 244, 1);
  static const backgroundDark = Color.fromRGBO(27, 33, 44, 1);
  static const backgroundLight = Colors.white;

  //===============================================
  // Cursor Color
  //===============================================
  static const cursor = primary;

  //===============================================
  // Card Color
  // Light: White
  // Dark: Black 80xdfdf
  //===============================================
  static const card = Colors.white;
  static const cardDark = Color.fromRGBO(37, 48, 63, 1);

  //===============================================
  // Divider Color
  // Light: Grey
  // Dark: White 60
  //===============================================
  static const divider = Color(0xFFCDCDCD);
  static const dividerDark = Colors.white12;

  //===============================================
  // Bill Payment Color
  //===============================================
  static const electricity = Color(0xFFFF6B00);
  static const water = Color(0xFF0066FF);
  static const solidWaste = Color(0xFF06C755);
}
