import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Centers {
  String id;
  String groupName;
  List<dynamic> teachers ;

  Centers({this.id, this.groupName, this.teachers});

  toMap() {
    return {
      "groupName": groupName,
      "teachers": teachers == null ? [] : teachers,
    };
  }

  Centers.fromSnapshot(DataSnapshot dataSnapshot)
      : id = dataSnapshot.key,
        groupName = dataSnapshot.value["groupName"],
        teachers = (dataSnapshot.value["teachers"]);
}
