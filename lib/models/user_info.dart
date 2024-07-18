import 'package:flutter/material.dart';

class UserInfoModel extends ChangeNotifier {
  DateTime birthDate = DateTime(1900, 1, 1);
  var gender = "";

  void setBirthDate(int year, int month, int day) {
    birthDate = DateTime(year, month, day);
    notifyListeners();
  }
}
