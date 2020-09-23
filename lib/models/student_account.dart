import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'centers.dart';

class StudentAccount {
  String studentId;
  String studentCode;
  String name;
  String imageUrl;
  String schoolName;
  String studentPhone;
  String parentPhone;
  String educationalLevel;
  Map<dynamic,dynamic>centers={};
  String groupName;
  bool accepted;

  StudentAccount(
      {this.studentId,
      this.studentCode,
      @required this.name,
      @required this.imageUrl,
      @required this.schoolName,
      @required this.studentPhone,
      @required this.parentPhone,
      @required this.educationalLevel,
      @required this.groupName,
      this.accepted});

  toMap() {
    return {
      "name": name,
      "imageUrl": imageUrl,
      "schoolName": schoolName,
      "studentPhone": studentPhone,
      "parentPhone": parentPhone,
      "educationalLevel": educationalLevel,
      "groupName": groupName,
      "studentCode": studentCode,
      "accepted": accepted == null ? false : accepted,
    };
  }

  StudentAccount.fromSnapshot(DataSnapshot dataSnapshot)
      : studentId = dataSnapshot.key,
        studentCode = dataSnapshot.value["studentCode"],
        imageUrl = dataSnapshot.value["imageUrl"],
        name = dataSnapshot.value["name"],
        //  subject = dataSnapshot.value["subject"],
        schoolName = dataSnapshot.value["schoolName"],
        studentPhone = dataSnapshot.value["studentPhone"],
        educationalLevel = dataSnapshot.value["educationalLevel"],
        parentPhone = dataSnapshot.value["parentPhone"],
        groupName = dataSnapshot.value["groupName"],
        accepted = dataSnapshot.value["accepted"],
        centers =Map<dynamic,dynamic>.from(dataSnapshot.value["centers"] == null
            ? []
            : dataSnapshot.value["centers"]);
}
