import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

 abstract class Essentials{

  Future<String> getTeacherId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    min(9,8);
    return sharedPreferences.get("teacherId");
  }
}