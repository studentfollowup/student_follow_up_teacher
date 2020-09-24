import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student_follow_up_teacher/screens/teacher_case.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile.dart';
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  String teacherId;

  @override
  void initState() {
    Timer(Duration(seconds: 5), () {
      autoLogin();
    });

    super.initState();
  }



  Future<String> autoLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (!pref.containsKey("teacherId")) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) => TeacherCase()));
      return null;
    }

    else {
      teacherId = pref.getString("teacherId");
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) => Profile(teacherId)));
    }
//    print("result ==> $teacherId");
    return teacherId;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: CircleAvatar(
              radius: 90,
              backgroundColor: Colors.pink,
              child: CircleAvatar(
                radius: 85,
                backgroundImage: AssetImage('images/learning.png'),
              ),
            )));
  }
}
