import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student_follow_up_teacher/models/teacher_account.dart';
import 'package:student_follow_up_teacher/screens/create_account.dart';
import 'package:student_follow_up_teacher/widgets/drawer.dart';
import 'package:firebase_database/firebase_database.dart';

class Profile extends StatefulWidget {
  final TeacherAccount teacherAccount;

  @override
  _ProfileState createState() => _ProfileState();

  Profile(this.teacherAccount);
}

class _ProfileState extends State<Profile> {
  bool edit = false;
  final _formKey = GlobalKey<FormState>();
  final _databaseRef =
      FirebaseDatabase.instance.reference().child("teacher accounts");

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Align(
            alignment: Alignment.centerRight,
            child: Text(
              "الحساب الشخصي",
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
            )),
      ),
      drawer: DrawerWidget(),
      body: Container(
        height: double.maxFinite,
        width: double.infinity,
        color: Colors.teal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: deviceHeight * 0.08, horizontal: deviceWidth * 0.1),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                textDirection: TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.deepOrange,
                        border: Border.all(color: Colors.white, width: 2),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(widget.teacherAccount.imageUrl),
                        )),

//                backgroundImage: NetworkImage(
//                    "https://i.pinimg.com/236x/9d/76/3d/9d763dea735c7f42e0f50e28d4e5ba71.jpg"),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.teacherAccount.name,
                        style: TextStyle(color: Colors.white, fontSize: 25),
                        textAlign: TextAlign.right,
                      ),
                      Container(
                        //  margin: EdgeInsets.only(right: 30),
                        child: Text(
                          "الكود : ${widget.teacherAccount.teacherCode}",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
//            edit
//                ? EditForm(_formKey, widget.teacherAccount)
//                :
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: deviceWidth * 0.06),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: Padding(
                  padding: const EdgeInsets.only(top: 30.0, bottom: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          child: Card(
                            elevation: 4,
                            shadowColor: Colors.teal,
                            margin: EdgeInsets.only(bottom: 5),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 8),
                              child: Text(
                                " المادة : ${widget.teacherAccount.subject}",
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: double.infinity,
//                          height: deviceHeight*0.02,
                          child: Card(
                            elevation: 4,
                            shadowColor: Colors.teal,
                            margin: EdgeInsets.only(bottom: 5),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 8),
                              child: Text(
                                " المراحل التعليمية: ${widget.teacherAccount.educationLevels}  ",
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black),
                                maxLines: 3,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: double.infinity,
                          child: Card(
                            elevation: 4,
                            shadowColor: Colors.teal,
                            margin: EdgeInsets.only(bottom: 5),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 8),
                              child: Text(
                                " نبذة : ${widget.teacherAccount.description}",
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: double.infinity,
                          child: Card(
                            elevation: 4,
                            shadowColor: Colors.teal,
                            margin: EdgeInsets.only(bottom: 5),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 8),
                              child: Text(
                                " رقم التليفون :${widget.teacherAccount.numbers} ",
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        RaisedButton(
                          elevation: 4,
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              child: Text(
                                "تعديل",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 24),
                              )),
                          color: Colors.pink,
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (ctx) => CreateAccount(widget.teacherAccount)));
//                            _databaseRef
//                                .child(widget.teacherAccount.userId)
//                                .set(widget.teacherAccount);
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
