import 'package:flutter/material.dart';


class Dimensions {

  static double getWidth(String width, context){
    return MediaQuery.of(context).size.width * (int.parse(width) / 100);
  }

  static double getHeight(String height, context){
    return MediaQuery.of(context).size.height * (double.parse(height) / 100);
  }

  static final double loginText = 12;
}