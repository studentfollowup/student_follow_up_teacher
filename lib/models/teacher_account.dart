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
  bool accepted = false;
  String clerkCode;
  String version;
  DateTime expiryDate;
  bool expired;

  TeacherAccount({
    this.userId,
    @required this.teacherCode,
    @required this.imageUrl,
    @required this.name,
    @required this.subject,
    @required this.description,
    @required this.numbers,
    @required this.educationLevels,
    this.accepted,
    @required this.clerkCode,
    @required this.version,
    this.expiryDate,
    this.expired,
  });

  toMap() {
    return {
      "name": name,
      "teacherCode": teacherCode,
      "imageUrl": imageUrl,
      "subject": subject,
      "description": description,
      "numbers": numbers,
      "educationLevels": educationLevels,
      "accepted": accepted == null ? false : accepted,
      "clerkCode": clerkCode,
      "version": version,
      "expiryDate": expiryDate == null ? null : expiryDate.toIso8601String(),
      "expired": expired == null ? false : expired,
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
        educationLevels = dataSnapshot.value["educationLevels"],
        accepted = dataSnapshot.value["accepted"],
        clerkCode = dataSnapshot.value["clerkCode"],
        version = dataSnapshot.value["version"],
        expiryDate = DateTime.parse(dataSnapshot.value["expiryDate"]),
        expired = dataSnapshot.value["expired"];
}
