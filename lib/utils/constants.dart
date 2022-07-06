

import 'dart:math';

import 'package:flutter/material.dart';

class Constants{

  // ignore: constant_identifier_names
  static const String PROJECT_OTA = "4e8a02fe-bb42-452d-b573-e0645f03c230";

  //e32e526f-d3f7-4686-b7ae-740662c7fa5d
  // ignore: constant_identifier_names
  static const String PROJECT_SEND_OTA = "e32e526f-d3f7-4686-b7ae-740662c7fa5d";

}

class ColorConst{
  //颜色
  static const Color_Font_Black = Color(0xFF222222);
  static const Color_Font_Gray = Color(0xFF999999);
  static const Color_Font_LightGray = Color(0xFF666666);
  static const Color_Font_White = Color(0xFFFFFFFF);
  static const Color_Font_Purple = Color(0xFF4768F3);
  static const Color_Split_Line = Color(0xFFE7E8ED);
  static const Color_BG = Color(0xFFEDEDED);
  static const Color_Font_Orange = Color(0xFFFF6600);
  static const Color_Clear = Colors.transparent;
  static const Color_Font_Red = Color(0xFFCD513E);

  //随机颜色
  static Color colorRandom() {
    return Color.fromRGBO(Random.secure().nextInt(255),
        Random.secure().nextInt(255), Random.secure().nextInt(255), 1);
  }
}