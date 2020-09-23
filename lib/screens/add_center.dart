import 'package:flutter/material.dart';
import 'file:///C:/Users/10/Downloads/cashier/student_follow_up_teacher/lib/others/colors.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:student_follow_up_teacher/models/new_center.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_follow_up_teacher/others/helper.dart';
import 'package:student_follow_up_teacher/widgets/drawer.dart';
import 'package:toast/toast.dart';

class AddCenter extends StatefulWidget {
  //use it until the autoLogin works;
  @override
  _AddCenterState createState() => _AddCenterState();
}

class _AddCenterState extends State<AddCenter> {
  String currentUserId;

  NewCenter _newCenter =
      new NewCenter(centerName: null, educationLevels: null, lectureCost: null);
  String _selectedEducationLevel;
  List<String> _educationalLevel = [
    "الصف الاول الاعدادى",
    "الصف الثانى الاعدادى",
    "الصف الثالث الاعدادى",
    "الصف الاول الثانوى",
    "الصف الثانى الثانوى",
    "الصف الثالث الثانوى"
  ];

  final _formKey = GlobalKey<FormState>();

  final _firebase = FirebaseDatabase().reference().child("teacher accounts");

  Future<void> onSave() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      currentUserId = sharedPreferences.get("teacherId");
      Toast.show("تم اضافة السنتر", context,
          duration: 3, gravity: Toast.CENTER);

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
                style: titleText,

              )),
        ),
        drawer: DrawerWidget(),

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
                              color: primaryColor,
                              textDirection: TextDirection.rtl,
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                            fillColor: Colors.white60,
                            filled: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 5),
                            labelText: "اسم السنتر",
//
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
          Container(width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: primaryColor),
              color: Colors.white,
            ),
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: DropdownButton(
              hint: Text(
                "اختر المرحلة الدراسية",
                style: TextStyle(fontSize: 16),
              ),
              value: _selectedEducationLevel,
              onChanged: (value) {
                setState(() {
                  _selectedEducationLevel = value;
                  _newCenter.educationLevels=value;
//                  getTeacher(value);
                });
              },
              items: _educationalLevel.map((center) {
                return DropdownMenuItem(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      center,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: Colors.black, fontSize: 18),
                    ),
                  ),
                  value: center,
                );
              }).toList(),
            ),
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
                                borderSide: BorderSide(color: primaryColor)),
                            prefixIcon: Icon(
                              Icons.payment,
                              color: primaryColor,
                              textDirection: TextDirection.rtl,
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                            fillColor: Colors.white60,
                            filled: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 5),
                            labelText: "قيمة المحاضرة",
//
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
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                accentColor.withBlue(120),
                                accentColor.withGreen(20),
                                accentColor.withRed(180)
                              ])),
                          child: FlatButton(
                           // elevation: 4,
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                                child: Text(
                                  "اضافة",
                                  style:titleText,
                                )),
                            //color: Colors.pink,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            onPressed: onSave,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )),
        ));
  }
}
