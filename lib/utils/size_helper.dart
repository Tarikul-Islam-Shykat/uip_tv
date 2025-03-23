import 'package:flutter/material.dart';

class Sizer {
  static double customHeight(BuildContext context, double value) {
    var height = MediaQuery.of(context).size.height;
    return height * value;
  }

  static double customWidth(BuildContext context, double value) {
    var width = MediaQuery.of(context).size.width;
    return width * value;
  }

  static double companyLogoSize(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return height * 0.3;
  }

  static double headingText(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return height * 0.030;
  }

  static double subtitleText(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return height * 0.013;
  }

  static double normalText(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return height * 0.014;
  }

  static double normal2Text(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return height * 0.018;
  }

  static double buttonHeight(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return height * 0.07;
  }

  static double buttonText(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return height * 0.025;
  }

  static double inBetweenMaxDistance(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return height * 0.06;
  }

  static double inBetweenDistance(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return height * 0.025;
  }

  static double inBetweenMinimalDistance(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return height * 0.006;
  }

  static double inBottomButtoPading(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return height * 0.02;
  }

  static double deviceDefaultPadding(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return height * 0.02;
  }
}
