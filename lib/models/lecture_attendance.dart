import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class LectureAttendance {
  DateTime time;
  String id;
  String lectureName;
  int lectureNumber;
  List<String> students=[];

  LectureAttendance({this.time,this.lectureName, this.lectureNumber, this.students});

  toMap(){
    return {
      "time":time==null?null:time.toIso8601String(),
      "lectureName": lectureName,
      "lectureNumber": lectureNumber,
      "students": students==null?[]:students,

    };
  }

  LectureAttendance.fromSnapshot(DataSnapshot dataSnapshot){
    id=dataSnapshot.key;
    time=dataSnapshot.value["time"];
    lectureName=dataSnapshot.value["lectureName"];
    lectureNumber=dataSnapshot.value["lectureNumber"];
    students=dataSnapshot.value["students"];

  }
}
