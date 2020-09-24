import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student_follow_up_teacher/models/teacher_account.dart';
import 'package:student_follow_up_teacher/screens/choose_version.dart';
import 'package:student_follow_up_teacher/screens/sign_in.dart';
import '../others/colors.dart';
import 'create_account.dart';

class TeacherCase extends StatefulWidget {
  @override
  _TeacherCaseState createState() => _TeacherCaseState();
}

class _TeacherCaseState extends State<TeacherCase> {


  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => ChooseVersion()));
              },
              child: Container(
                width: deviceWidth * 0.8,
                height: deviceHeight * 0.1 + 40,
                // padding: const EdgeInsets.symmetric(vertical: 30,horizontal: 80),
                child: Card(
                  color: Colors.pink,
                  shadowColor: Colors.teal,
                  margin: EdgeInsets.all(10),
                  elevation: 4,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "معلم جديد",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
//            ),
            InkWell(
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => SignIn())),
              child: Container(
                width: deviceWidth * 0.8,
                height: deviceHeight * 0.1 + 40,
                // padding: const EdgeInsets.symmetric(vertical: 30,horizontal: 80),
                child: Card(
                  color: Colors.amber,
                  shadowColor: Colors.teal,
                  margin: EdgeInsets.all(10),
                  elevation: 4,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "معلم مسجل",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
