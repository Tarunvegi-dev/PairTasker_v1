import 'package:flutter/material.dart';


class Helper {
  Helper._();

  static bool isDark(context) {
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark
            ? true
            : false;
    return isDarkMode;
  }
}

class BaseURL {
  static const url =
      'http://pairtasker-test.ap-south-1.elasticbeanstalk.com/api';
}
