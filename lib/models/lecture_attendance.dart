//import 'package:firebase_database/firebase_database.dart';
//TODO: uncomment next Statement
import 'package:firebase/firebase.dart';
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
   /* id=dataSnapshot.key;
    //TODO:uncomment for web version
    time=dataSnapshot.value["time"];
    lectureName=dataSnapshot.value["lectureName"];
    lectureNumber=dataSnapshot.value["lectureNumber"];
    students=dataSnapshot.value["students"];



    */
 id=dataSnapshot.key;
    time=dataSnapshot.val()["time"];
    lectureName=dataSnapshot.val()["lectureName"];
    lectureNumber=dataSnapshot.val()["lectureNumber"];
    students=dataSnapshot.val()["students"];

  }
}
