import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class StudentAttendance {
  String id;
  String teacherName;
  String lectureNumber;
  DateTime attendanceTime;
  bool sameCenter;
  String centerName;
  bool isAbsence;

  StudentAttendance(
      {this.id,
      this.teacherName,
      this.attendanceTime,
      this.sameCenter,
      this.centerName,
      this.lectureNumber,
      this.isAbsence});

  toMap() {
    return {
      "teacherName": teacherName,
      "attendanceTime": attendanceTime,
      "sameCenter": sameCenter == null ? true : sameCenter,
      "centerName": centerName,
      "lectureNumber": lectureNumber,
      "isAbsence": isAbsence,
    };
  }

  StudentAttendance.fromSnapshot(DataSnapshot dataSnapshot) {
    id = dataSnapshot.value["id"];
    teacherName = dataSnapshot.value["teacherName"];
    attendanceTime = dataSnapshot.value["attendanceTime"];
    sameCenter = dataSnapshot.value["sameCenter"];
    centerName = dataSnapshot.value["centerName"];
    lectureNumber = dataSnapshot.value["lectureNumber"];
    isAbsence = dataSnapshot.value["isAbsence"];
  }
}
