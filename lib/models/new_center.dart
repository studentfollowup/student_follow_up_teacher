import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class NewCenter {
  final String centerId;
   String centerName;
   String educationLevels;
   double lectureCost;

  NewCenter(
      {this.centerId,
      @required this.centerName,
      @required this.educationLevels,
      @required this.lectureCost});

  toMap() {
    return {
      "centerName": centerName,
      "educationLevel": educationLevels,
      "lectureCost": lectureCost,
    };
  }

  NewCenter.fromSnapshot(DataSnapshot dataSnapshot)
      : centerId = dataSnapshot.key,
        centerName = dataSnapshot.value["centerName"],
        educationLevels = dataSnapshot.value["educationLevel"],
        lectureCost = dataSnapshot.value["lectureCost"]+0.0;
}
