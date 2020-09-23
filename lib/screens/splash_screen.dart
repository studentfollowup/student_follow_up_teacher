import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student_follow_up_teacher/models/teacher_account.dart';
import 'package:student_follow_up_teacher/screens/teacher_case.dart';
import 'create_account.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile.dart';
import 'package:firebase_database/firebase_database.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
//  final _firebaseRef = FirebaseDatabase().reference().child('teacher accounts');
  TeacherAccount currentUser;
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
