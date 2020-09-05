import 'package:flutter/material.dart';
import 'package:student_follow_up_teacher/screens/attendance.dart';
import 'package:student_follow_up_teacher/screens/choose_version.dart';
import 'package:student_follow_up_teacher/screens/teacher_case.dart';
import '../colors/colors.dart';
import '../screens/add_center.dart';
import 'package:shared_preferences/shared_preferences.dart';
class DrawerWidget extends StatelessWidget {
  Future<void> logout() async {
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    sharedPreferences.setString("teacherId",null);
    print("techerId =>${sharedPreferences.getString("teacherId")}");

  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
        elevation: 5,
        child: Column(children: <Widget>[
          AppBar(
            backgroundColor: primaryColor,

            title: Text(
              "Follow Student",
              style: TextStyle(fontSize: 20),
            ),
            //to not put a back button
            automaticallyImplyLeading: false,
          ),
          //  Divider(),
          ListTile(
              leading: Icon(
                Icons.insert_drive_file,
                color: primaryColor,
              ),
              title: Text("تسجيل الحضور", style: TextStyle(fontSize: 15)),
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
              title: Text("اضافة سنتر", style: TextStyle(fontSize: 15)),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AddCenter()));
              }),
          Divider(),
          ListTile(
              leading: Icon(
                Icons.arrow_back_ios,
                color: primaryColor,
              ),
              title: Text("تسجيل الخروج", style: TextStyle(fontSize: 15)),
              onTap: () {
                logout();
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => TeacherCase()));
              }),
          Divider(),
        ]));
  }
}
