// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

class Dark_mode_Provider with ChangeNotifier {
  var _thememode = ThemeMode.light;
  ThemeMode get thememode => _thememode;
  int _value = 0;
  int get value => _value;
  void settheme(thememode) {
    _thememode = thememode;
    notifyListeners();
  }
}
