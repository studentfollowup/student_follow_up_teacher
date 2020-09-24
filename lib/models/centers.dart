//import 'package:firebase_database/firebase_database.dart';
//TODO:uncomment next statement
import 'package:firebase/firebase.dart';
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
  //TODO:uncomment for web version
     /* : id = dataSnapshot.key,

      groupName =dataSnapshot.value["groupName"],
        teachers =(dataSnapshot.value["teachers"]);

      */

         : id = dataSnapshot.key,

      groupName = dataSnapshot.val()["groupName"],
        teachers = dataSnapshot.val()["teachers"];
}
