import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student_follow_up_teacher/models/teacher_account.dart';
import 'package:student_follow_up_teacher/screens/profile.dart';
import '../colors/colors.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final codeController = TextEditingController();

  List<TeacherAccount> _teachers = [];

  var _firebaseRef = FirebaseDatabase().reference().child('teacher accounts');

  int index;

  TeacherAccount getTeacher(String code) {
    print("teachers number =${_teachers.length}");
    index = _teachers.indexWhere((element) => element.teacherCode == code);
    if (index == -1) {
      Toast.show("كود خاطىء ، حاول مرة اخرى", context,
          duration: 3, gravity: Toast.CENTER);
      return null;
    }
    // print("index is = $index");

    else{
      saveTeacherId(index);
      return _teachers[index];
  }}


  Future<void> saveTeacherId(int index) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("teacherId",_teachers[index].userId);}
  @override
  void initState() {
    // TODO: implement initState

    onChildAdded(Event event) {
      _teachers.add(TeacherAccount.fromSnapshot(event.snapshot));
      print("teachers number onChild added=${_teachers.length}");
    }
    _firebaseRef.onChildAdded.listen(onChildAdded);

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("تسجيل الدخول "),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: primaryColor),
                margin: EdgeInsets.symmetric(horizontal: 30),
                height: 150,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Card(
                      elevation: 4,
                      shadowColor: accentColor,
                      child: Container(
                        alignment: Alignment.center,
                        margin:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        child: TextField(
                          textAlign: TextAlign.right,
                          // textDirection: TextDirection.rtl,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                                //  gapPadding: 5,
                                borderSide: BorderSide(color: primaryColor)),
                            prefixIcon: Icon(
                              Icons.person,
                              color: accentColor,
                              textDirection: TextDirection.rtl,
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                            fillColor: Colors.white60,
                            filled: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 5),
                            labelText: "كود المعلم",
                            labelStyle:
                                TextStyle(color: accentColor, fontSize: 17),
                            // helperText: "hello"
                          ),
                          controller: codeController,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              RaisedButton(
                elevation: 4,
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                color: accentColor,
                child: Text(
                  "دخول",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                onPressed: () {
                  TeacherAccount teacher = getTeacher(codeController.text);
                  print(teacher);

                  if (teacher != null) {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (ctx) => Profile(teacher)));
                  }
                },
              )
            ],
          ),
        ));
  }
}
