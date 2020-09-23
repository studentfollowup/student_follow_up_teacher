import 'package:firebase/firebase.dart';
//TODO:uncomment next statement

//import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'file:///C:/Users/10/Downloads/cashier/student_follow_up_teacher/lib/others/colors.dart';
import 'package:student_follow_up_teacher/models/new_center.dart';
import 'package:student_follow_up_teacher/screens/center_students.dart';
import 'package:student_follow_up_teacher/widgets/drawer.dart';
import '../others/helper.dart';

class AcceptedStudents extends StatefulWidget {
  @override
  _AcceptedStudentsState createState() => _AcceptedStudentsState();
}

class _AcceptedStudentsState extends State<AcceptedStudents> {
  List<NewCenter> _centers = [];
  String id;
//TODO:uncomment next statement
  /*var _firebaseRef = FirebaseDatabase().reference().child("teacher accounts");*/
  DatabaseReference _ref = database().ref("teacher accounts");

  Future<void> getTeacherId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    id = sharedPreferences.get("teacherId");
  }

  @override
  void initState() {
    super.initState();
    getTeacherId().then((value) {
      //TODO:uncomment next section for web
      /*
      _firebaseRef.child(id).child("centers").onChildAdded.listen((event) {
        setState(() {
          _centers.add(NewCenter.fromSnapshot(event.snapshot));
        });
      });*/
      _ref.child(id).child("centers").onChildAdded.listen((event) {
        setState(() {
          _centers.add(NewCenter.fromSnapshot(event.snapshot));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
            alignment: Alignment.centerRight,
            child: Text(
              "السناتر",
              style: titleText,
            )),
      ),
      drawer: DrawerWidget(),
      body: _centers.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ListView.builder(
                itemCount: _centers.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) =>
                              CenterStudents(_centers[index].centerName)));
                    },
                    child: Card(
                      elevation: 3,
                      shadowColor: primaryColor,
                      child: Container(
                        height: 70,
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(right: 10),
                        child: Text(
                          "سنتر ${_centers[index].centerName}",
                          textAlign: TextAlign.center,
                          style: contrastTextBoldBig,
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          : Center(child: Text("غير مسجل بأى سنتر ")),
    );
  }
}
