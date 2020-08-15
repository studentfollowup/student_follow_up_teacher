import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

class TeacherAccount {
  String userId;
  String teacherCode;

  String imageUrl;
  String name;
  String subject;
  String description;
  String numbers;
  String educationLevels;

  TeacherAccount(
      {this.userId,
      @required this.teacherCode,
      @required this.imageUrl,
      @required this.name,
      @required this.subject,
      @required this.description,
      @required this.numbers,
      @required this.educationLevels});

  toMap() {
    return {
      "teacherCode": teacherCode,
      "imageUrl": imageUrl,
      "name": name,
      "subject": subject,
      "description": description,
      "numbers": numbers,
      "educationLevels": educationLevels
    };
  }

  TeacherAccount.fromSnapshot(DataSnapshot dataSnapshot)
      : userId = dataSnapshot.key,
        teacherCode = dataSnapshot.value["teacherCode"],
        imageUrl = dataSnapshot.value["imageUrl"],
        name = dataSnapshot.value["name"],
        subject = dataSnapshot.value["subject"],
        description = dataSnapshot.value["description"],
        numbers = dataSnapshot.value["numbers"],
        educationLevels = dataSnapshot.value["educationLevels"];
}
