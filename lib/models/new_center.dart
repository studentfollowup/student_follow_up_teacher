import 'package:flutter/material.dart';
//import 'package:firebase_database/firebase_database.dart';
//TODO: uncomment next Statement
import 'package:firebase/firebase.dart';

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
  //TODO:uncomment for web version
/*
      centerName =dataSnapshot.value["centerName"],
        educationLevels =dataSnapshot.value["educationLevel"],
        lectureCost = ataSnapshot.value["lectureCost"]+0.0;
*/
      centerName = dataSnapshot.val()["centerName"],
        educationLevels =dataSnapshot.val()["educationLevel"] ,
        lectureCost = dataSnapshot.val()["lectureCost"]+0.0;
}
