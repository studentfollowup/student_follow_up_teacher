import 'package:flutter/material.dart';
import 'package:student_follow_up_teacher/colors/colors.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:student_follow_up_teacher/models/new_center.dart';

class AddCenter extends StatelessWidget {
  //use it until the autoLogin works;
  final String currentUserId = "-MElsttvXvZEPESeqOSn";
  NewCenter _newCenter=new NewCenter(centerName: null, educationLevels: null, lectureCost: null);
  final _formKey = GlobalKey<FormState>();
  final _firebase = FirebaseDatabase().reference().child("teacher accounts");

  void onSave() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _firebase.child(currentUserId).child("centers").push().set(_newCenter.toMap());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "اضافة سنتر",
              )),
        ),
        body: Center(
          child: Form(
              key: _formKey,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                                //  gapPadding: 5,
                                borderSide: BorderSide(color: primaryColor)),
                            prefixIcon: Icon(
                              Icons.business_center,
                              color: accentColor,
                              textDirection: TextDirection.rtl,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                            ),
                            fillColor: Colors.white60,
                            filled: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 5),
                            labelText: "اسم السنتر",
                            labelStyle:
                                TextStyle(color: accentColor, fontSize: 17),
                            // helperText: "hello"
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "قيمة خاطئة";
                            }
                            return null;
                          },
                          onSaved: (val) {
                            _newCenter.centerName = val;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                                //  gapPadding: 5,
                                borderSide: BorderSide(color: primaryColor)),
                            prefixIcon: Icon(
                              Icons.business_center,
                              color: accentColor,
                              textDirection: TextDirection.rtl,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                            ),
                            fillColor: Colors.white60,
                            filled: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 5),
                            labelText: "المرحلة الدراسية",
                            labelStyle:
                                TextStyle(color: accentColor, fontSize: 17),
                            // helperText: "hello"
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "قيمة خاطئة";
                            }
                            return null;
                          },
                          onSaved: (val) {
                            _newCenter.educationLevels = val;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                                //  gapPadding: 5,
                                borderSide: BorderSide(color: primaryColor)),
                            prefixIcon: Icon(
                              Icons.payment,
                              color: accentColor,
                              textDirection: TextDirection.rtl,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                            ),
                            fillColor: Colors.white60,
                            filled: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 5),
                            labelText: "قيمة المحاضرة",
                            labelStyle:
                                TextStyle(color: accentColor, fontSize: 17),
                            // helperText: "hello"
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "قيمة خاطئة";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          onSaved: (val) {
                            _newCenter.lectureCost = double.parse(val);
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        RaisedButton(
                          elevation: 4,
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              child: Text(
                                "اضافة",
                                style:
                                    TextStyle(color: Colors.white, fontSize: 24),
                              )),
                          color: Colors.pink,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          onPressed: onSave,
                        )
                      ],
                    ),
                  ),
                ),
              )),
        ));
  }
}
