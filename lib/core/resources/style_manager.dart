import 'package:flutter/material.dart';


import 'font_manager.dart';

TextStyle _getTextStyle(
    double fontSize,
    FontWeight fontWeight,
    Color color,
    ) {
  return TextStyle(
    fontSize: fontSize,
    color: color,
    fontWeight: fontWeight,
    fontFamily:'Tajawal',


  );
}

//return regular style
TextStyle getRegularStyle({
  double fontSize = FontSize.s12,
   Color? color,
}) {
  return _getTextStyle(
    fontSize,
    FontWeightManager.regular,
    color?? Colors.black,
  );
}

// return light style
TextStyle getLightStyle({
  double fontSize = FontSize.s12,
   Color? color,
}) {
  return _getTextStyle(
    fontSize,
    FontWeightManager.light,
    color?? Colors.black,
  );
}

// return bold style
TextStyle getBoldStyle({
  double fontSize = FontSize.s12,
  Color? color,

}) {
  return _getTextStyle(
    fontSize,
    FontWeightManager.bold,
    color?? Colors.black,
  );
}

// return semi bold style
TextStyle getSemiBoldStyle({
  double fontSize = FontSize.s12,
  Color? color,
}) {
  return _getTextStyle(
    fontSize,
    FontWeightManager.semiBold,
    color?? Colors.black,
  );
}

// return medium style
TextStyle getMediumStyle({
  double fontSize = FontSize.s12,
  Color? color,
}) {
  return _getTextStyle(
    fontSize,
    FontWeightManager.medium,
    color?? Colors.black,
  );
}

