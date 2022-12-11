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
      'http://node-express-env.eba-p9xtnay4.ap-south-1.elasticbeanstalk.com/api';
}
