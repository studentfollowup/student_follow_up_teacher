import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:student_follow_up_teacher/screens/choose_version.dart';
import 'package:student_follow_up_teacher/screens/profile.dart';
import '../models/teacher_account.dart';
import 'package:firebase_database/firebase_database.dart';
import '../colors/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class CreateAccount extends StatefulWidget {
  final TeacherAccount _teacher;

  @override
  _CreateAccountState createState() => _CreateAccountState();

  CreateAccount(this._teacher);
}

class _CreateAccountState extends State<CreateAccount> {
  //This uniquely identifies the Form, and allows validation of the form
  final _formKey = GlobalKey<FormState>();
  final imageController = TextEditingController();
  bool saved = false;
  var _firebaseRef = FirebaseDatabase().reference().child('teacher accounts');
  String titleText = "انشاء حساب جديد";
  String buttonText = "انشاء حساب";

  TeacherAccount teacherAccount = new TeacherAccount(
      imageUrl: null,
      teacherCode: null,
      name: null,
      subject: null,
      description: null,
      numbers: null,
      educationLevels: null);
  FirebaseUser mCurrentUser;
  FirebaseAuth _auth;

  //save function of form
  Future<void> onSave() async {
    print("i'm here onSave");
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if (titleText == "تعديل الحساب الشخصى") {
//        print("ana b3dl el profile");
//        print(teacherAccount.imageUrl);
//        print(teacherAccount.teacherCode);
//        print(teacherAccount.name);
//        print(teacherAccount.userId);
//        print(teacherAccount.educationLevels);
//        print(teacherAccount.description);
//        print(teacherAccount.numbers);
//        print(teacherAccount.subject);

        teacherAccount.teacherCode = widget._teacher.teacherCode;
        teacherAccount.userId=widget._teacher.userId;
        _firebaseRef.child(widget._teacher.userId).set(teacherAccount.toMap());
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (ctx) => Profile(teacherAccount)));
      } else {
        teacherAccount.teacherCode = randomNumeric(5);
        _firebaseRef.push().set(teacherAccount.toMap());
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (ctx) => Profile(teacherAccount)));
      }
    }
  }

//  _getCurrentUser() async {
//    mCurrentUser = await _auth.currentUser();
//  }

  @override
  void dispose() {
    // TODO: implement dispose
    imageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    print("_teacher ${imageController.text}");
    print("Teacher ID: --> ${widget._teacher.userId}");
    if (widget._teacher.name != null) {
      setState(() {
        teacherAccount.imageUrl=widget._teacher.imageUrl;
        titleText = "تعديل الحساب الشخصى";
        buttonText = "حفظ";
      });
    }

//  _auth = FirebaseAuth.instance;
//  _getCurrentUser();
//  print("this is current user: $mCurrentUser");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          title: Align(
            alignment: Alignment.centerRight,
            child: Text(
              titleText,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
                minHeight: deviceHeight, maxHeight: deviceHeight + 35),
            child: Column(
              // textDirection: TextDirection.rtl,
              children: [
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: Container(
                      margin: EdgeInsets.all(10),
                      //padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//                    child: SingleChildScrollView(
                      child: Column(
                        //    textDirection: TextDirection.rtl,
                        // crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                        content: Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: TextFormField(
                                            //   initialValue: widget._teacher.imageUrl,
                                            controller: imageController
                                              ..text = widget._teacher.imageUrl,
                                            decoration: InputDecoration(
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(15),
                                                  ),
                                                  //  gapPadding: 5,
                                                  borderSide: BorderSide(
                                                      color: primaryColor)),
                                              prefixIcon: Icon(
                                                Icons.photo,
                                                color: accentColor,
                                                textDirection:
                                                    TextDirection.rtl,
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15)),
                                              ),
                                              fillColor: Colors.white60,
                                              filled: true,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 5),
                                              labelText: "رابط الصورة",
                                              labelStyle: TextStyle(
                                                  color: accentColor,
                                                  fontSize: 17),
                                              // helperText: "hello"
                                            ),
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return "اضف رابط للصورة";
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        actions: [
                                          FlatButton(
                                            child: Text("حفظ"),
                                            onPressed: () {
                                              widget._teacher.imageUrl =
                                                  imageController.text;
                                              teacherAccount.imageUrl =
                                                  widget._teacher.imageUrl;
                                              print(
                                                  "image = ${teacherAccount.imageUrl}");
                                              Navigator.of(context).pop();
                                            },
                                          )
                                        ],
                                      ));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              //color: Colors.redAccent,
                              width: deviceWidth * 0.6 + 20,
                              height: deviceHeight * 0.3,
                              alignment: Alignment.center,
                              //padding: EdgeInsets.all(8),
                              margin: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  child: (widget._teacher.imageUrl != null)
                                      ? Image.network(
                                          widget._teacher.imageUrl,
                                          fit: BoxFit.fill,
                                        )
                                      : Center(
                                          child: Text(
                                            "انقر هنا لوضع رابط الصورة ",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        )),
                            ),
                          ),
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Column(
                                children: [
                                  TextFormField(
                                    initialValue: widget._teacher.name,
                                    textAlign: TextAlign.right,
                                    // textDirection: TextDirection.rtl,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(15),
                                          ),
                                          //  gapPadding: 5,
                                          borderSide:
                                              BorderSide(color: primaryColor)),
                                      prefixIcon: Icon(
                                        Icons.person,
                                        color: accentColor,
                                        textDirection: TextDirection.rtl,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                      ),
                                      fillColor: Colors.white60,
                                      filled: true,
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      labelText: "اسم المعلم",
                                      labelStyle: TextStyle(
                                          color: accentColor, fontSize: 17),
                                      // helperText: "hello"
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "اسم خاطىء";
                                      }
                                      return null;
                                    },
                                    //keyboardType: TextInputType.text,
                                    onSaved: (value) {
                                      teacherAccount.name = value;
                                    },
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    onSaved: (value) {
                                      teacherAccount.subject = value;
                                    },
                                    textAlign: TextAlign.right,
                                    // textDirection: TextDirection.rtl,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(15),
                                          ),
                                          //  gapPadding: 5,
                                          borderSide:
                                              BorderSide(color: primaryColor)),
                                      // hintText: "اسم المعلم",
                                      //  hintStyle: TextStyle(fontSize: 15),
                                      prefixIcon: Icon(
                                        Icons.subject,
                                        color: accentColor,
                                        textDirection: TextDirection.rtl,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                      ),
                                      fillColor: Colors.white60,
                                      filled: true,
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      labelText: "المادة",
                                      labelStyle: TextStyle(
                                          color: accentColor, fontSize: 17),
                                      // helperText: "hello"
                                    ),
                                    keyboardType: TextInputType.text,
                                    initialValue: widget._teacher.subject,

                                    validator: (value) {
                                      if (value.isEmpty ||
                                          value.runtimeType == int) {
                                        return "قيمة خاطئة";
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    initialValue:
                                        widget._teacher.educationLevels,
                                    onSaved: (value) {
                                      teacherAccount.educationLevels = value;
                                    },
                                    textAlign: TextAlign.right,
                                    decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(15),
                                            ),
                                            borderSide: BorderSide(
                                                color: primaryColor)),
                                        prefixIcon: Icon(
                                          Icons.school,
                                          color: accentColor,
                                          textDirection: TextDirection.rtl,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                        ),
                                        fillColor: Colors.white60,
                                        filled: true,
                                        contentPadding:
                                            EdgeInsets.symmetric(horizontal: 8),
                                        labelText: "المراحل الدراسية ",
                                        labelStyle: TextStyle(
                                            color: accentColor, fontSize: 17),
                                        helperText:
                                            "مثال: الصف الاول ، الصف الثانى  "),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "قيمة خاطئة";
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.text,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    initialValue: widget._teacher.description,

                                    textAlign: TextAlign.right,
                                    // textDirection: TextDirection.rtl,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(15),
                                          ),
                                          //  gapPadding: 5,
                                          borderSide:
                                              BorderSide(color: primaryColor)),
                                      prefixIcon: Icon(
                                        Icons.description,
                                        color: accentColor,
                                        textDirection: TextDirection.rtl,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                      ),
                                      fillColor: Colors.white60,
                                      filled: true,
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      labelText: "نبذة",
                                      labelStyle: TextStyle(
                                          color: accentColor, fontSize: 17),
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "قيمة خاطئة";
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      teacherAccount.description = value;
                                    },
                                    keyboardType: TextInputType.multiline,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    initialValue: widget._teacher.numbers,

                                    textAlign: TextAlign.right,
                                    // textDirection: TextDirection.rtl,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(15),
                                          ),
                                          //  gapPadding: 5,
                                          borderSide:
                                              BorderSide(color: primaryColor)),
                                      prefixIcon: Icon(
                                        Icons.phone,
                                        color: accentColor,
                                        textDirection: TextDirection.rtl,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                      ),
                                      fillColor: Colors.white60,
                                      filled: true,
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      labelText: "ارقام التليفون",
                                      labelStyle: TextStyle(
                                          color: accentColor, fontSize: 17),
                                      // helperText: "hello"
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "قيمة خاطئة";
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      teacherAccount.numbers = value;
                                    },
                                    keyboardType: TextInputType.phone,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              child: Builder(
                                builder: (ctx) => RaisedButton(
                                    color: primaryColor,
                                    textColor: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 15),
                                    elevation: 3,
                                    child: Text(
                                      buttonText,
                                      style: TextStyle(fontSize: 18),
                                      textAlign: TextAlign.center,
                                      textDirection: TextDirection.rtl,
                                    ),
                                    onPressed: () {
                                      onSave();
//                                      if(saved==true){
//                                        Scaffold.of(context).showSnackBar(SnackBar(
//                                          content: Text(
//                                            "... جارى انشاء حسابك",
//                                            textAlign: TextAlign.center,
//                                          ),
//                                        ));
                                    }),
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
//              ),
              ],
            ),
          ),
        ));
  }
}
