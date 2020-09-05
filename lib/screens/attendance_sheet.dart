import 'package:flutter/material.dart';
import 'package:student_follow_up_teacher/colors/colors.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/lecture_attendance.dart';

class AttendanceSheet extends StatefulWidget {
  LectureAttendance lectureAttendance;

  @override
  _AttendanceSheetState createState() => _AttendanceSheetState();

  AttendanceSheet(this.lectureAttendance);
}

class _AttendanceSheetState extends State<AttendanceSheet> {
  List<String> students;

  @override
  void initState() {
    // TODO: implement initState
    students = widget.lectureAttendance.students;
    print(students.length);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerRight,
          child: Text("سجل الحضور"),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 10),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "عدد الحضور :",
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Chip(
                        padding: EdgeInsets.all(5),
                        backgroundColor: primaryColor,
                        elevation: 3,
                        label: Text("${students.length}"),
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 3,
                        shadowColor: primaryColor,
                        child: ListTile(
                          trailing: Text(students[index]),
                          leading: Chip(
                            label: Text(
                              "45",
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.red,
                          ),
                        ),
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
