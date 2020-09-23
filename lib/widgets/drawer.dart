import 'dart:math';

import 'package:flutter/material.dart';
import 'package:student_follow_up_teacher/screens/accepted_students.dart';
import 'package:student_follow_up_teacher/screens/attendance.dart';
import 'package:student_follow_up_teacher/screens/choose_version.dart';
import 'package:student_follow_up_teacher/screens/new_students.dart';
import 'package:student_follow_up_teacher/screens/profile.dart';
import 'package:student_follow_up_teacher/screens/teacher_case.dart';
import '../others/colors.dart';
import '../screens/add_center.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../others/helper.dart';

class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  bool expanded = false;

  var teacherID;

  Future<void> logout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("teacherId", null);
    print("techerId =>${sharedPreferences.getString("teacherId")}");
  }

  Future<void> getTeacherId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    teacherID = sharedPreferences.get("teacherId");
    print("teacher id in attendance==> $teacherID}");
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        elevation: 5,
        child: SingleChildScrollView(
          child: Column(children: <Widget>[
            AppBar(
              backgroundColor: primaryColor,

              title: Text(
                "Follow Student",
                style: titleText,
              ),
              //to not put a back button
              automaticallyImplyLeading: false,
            ),
            //  Divider(),
            ListTile(
                leading: Icon(
                  Icons.person,
                  color: primaryColor,
                ),
                title: Text("الحساب الشخصي", style: contrastText),
                onTap: () {
                  getTeacherId().then((value) {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Profile(teacherID)));
                  });
                }),
            Divider(),
            ListTile(
                leading: Icon(
                  Icons.insert_drive_file,
                  color: primaryColor,
                ),
                title: Text("تسجيل الحضور", style: contrastText),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Attendance()));
                }),
            Divider(),
            ListTile(
                leading: Icon(
                  Icons.add_circle,
                  color: primaryColor,
                ),
                title: Text("اضافة سنتر", style: contrastText),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => AddCenter()));
                }),
            Divider(),

            ListTile(
                leading: !expanded
                    ? Icon(
                        Icons.expand_more,
                        color: primaryColor,
                      )
                    : Icon(
                        Icons.expand_less,
                        color: primaryColor,
                      ),
                title: Text("الطلاب", style: contrastText),
                onTap: () {
                  setState(() {
                    expanded = !expanded;
                  });
//                Navigator.of(context).pop();
//                Navigator.of(context)
//                    .push(MaterialPageRoute(builder: (context) => AddCenter()));
                }),
            AnimatedContainer(
                duration: Duration(milliseconds: 250),
                height: expanded ? min(4 * 30.0 + 20.0, 160) : 0,
                child: Container(
                    height: min(2 * 10.0, 50),
//                  padding:
//                      const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                    child: ListView(
                      children: [
                        ListTile(
                            leading: Icon(
                              Icons.person_add,
                              color: primaryColor,
                            ),
                            title: Text("الطلاب الجدد",
                                style: contrastText),
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => NewStudents()));
                            }),
                        Divider(),
                        ListTile(
                            leading: Icon(
                              Icons.perm_contact_calendar,
                              color: primaryColor,
                            ),
                            title: Text("الطلاب المسجلين",
                                style: contrastText),
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => AcceptedStudents()));
                            }),
                      ],
                    ))),

            Divider(),
            ListTile(
                leading: Icon(
                  Icons.arrow_back_ios,
                  color: primaryColor,
                ),
                title: Text("تسجيل الخروج", style: contrastText),
                onTap: () {
                  logout();
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => TeacherCase()));
                }),
            Divider(),
          ]),
        ));
  }
}
