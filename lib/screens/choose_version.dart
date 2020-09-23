import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student_follow_up_teacher/models/teacher_account.dart';
import 'package:student_follow_up_teacher/screens/create_account.dart';
import '../others/colors.dart';
import 'profile.dart';
import 'package:firebase_database/firebase_database.dart';

class ChooseVersion extends StatefulWidget {
  @override
  _ChooseVersionState createState() => _ChooseVersionState();
}

class _ChooseVersionState extends State<ChooseVersion> {
  TeacherAccount teacherAccount = new TeacherAccount(
      teacherCode: null,
      imageUrl: null,
      name: null,
      subject: null,
      description: null,
      numbers: null,
      educationLevels: null,
      clerkCode: null,
      version: null);

  String fullVersionMsg;
  var _firebaseRef =
      FirebaseDatabase().reference().child('admin msgs notification');

  @override
  void initState() {
    // TODO: implement initState
    _firebaseRef.child("full version").once().then((DataSnapshot dataSnapshot) {
      setState(() {
        fullVersionMsg = dataSnapshot.value["fullVersionMessage"];
        print("msg => $fullVersionMsg");
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: deviceWidth * 0.8,
              height: deviceHeight * 0.1 + 20,
              // padding: const EdgeInsets.symmetric(vertical: 30,horizontal: 80),
              child: GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (ctx) => Container(
                            child: AlertDialog(
                              backgroundColor: Colors.white,
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              )),
                              actionsPadding: EdgeInsets.all(8),
                              title: Text(
                                "تنبيه",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 26),
                              ),
                              content: Text(
                                "النسخة التجريبية لمدة أسبوع واحد فقط ويمكن عمل اختبار واحد لا تزيد أسئلته عن 5 أسئلة  ",
                                style: TextStyle(fontSize: 18),
                                textAlign: TextAlign.center,
                              ),
                              actions: [
                                FlatButton(
                                  child: Text(
                                    "الغاء",
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                FlatButton(
                                  child: Text(
                                    "موافق",
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  onPressed: () {
                                    teacherAccount.version = "النسخة التجريبية";
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (ctx) =>
                                                CreateAccount(teacherAccount)));
                                  },
                                ),
                              ],
                            ),
                          ));
                },
                child: Card(
                  color: Colors.pink,
                  shadowColor: Colors.teal,
                  margin: EdgeInsets.all(10),
                  elevation: 4,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "النسخة التجريبية",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (ctx) => Container(
                          child: AlertDialog(
                            backgroundColor: Colors.white,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            )),
                            actionsPadding: EdgeInsets.all(8),
                            title: Text(
                              "تنبيه",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 26),
                            ),
                            content: Text(
                              fullVersionMsg,
                              style: TextStyle(fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                            actions: [
                              FlatButton(
                                child: Text(
                                  "الغاء",
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              FlatButton(
                                child: Text(
                                  "موافق",
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                onPressed: () {
                                  teacherAccount.version = "النسخة الكاملة";
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (ctx) =>
                                              CreateAccount(teacherAccount)));
                                },
                              ),
                            ],
                          ),
                        ));
              },
              child: Container(
                width: deviceWidth * 0.8,
                height: deviceHeight * 0.1 + 20,
                // padding: const EdgeInsets.symmetric(vertical: 30,horizontal: 80),
                child: Card(
                  color: Colors.amber,
                  shadowColor: Colors.teal,
                  margin: EdgeInsets.all(10),
                  elevation: 4,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "النسخة الكاملة",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
