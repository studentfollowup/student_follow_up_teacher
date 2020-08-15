import 'package:flutter/material.dart';
import 'package:student_follow_up_teacher/screens/attendance.dart';
import '../colors/colors.dart';
import '../screens/add_center.dart';
class DrawerWidget extends StatelessWidget {
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
                color: accentColor,
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
                color: accentColor,
              ),
              title: Text("اضافة سنتر", style: TextStyle(fontSize: 15)),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AddCenter()));
              }),
          Divider(),
        ]));
  }
}
