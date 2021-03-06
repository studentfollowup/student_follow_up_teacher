import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student_follow_up_teacher/models/teacher_account.dart';
import 'package:student_follow_up_teacher/screens/profile.dart';
import '../others/colors.dart';
//TODO : uncomment next statement
//import 'package:firebase_database/firebase_database.dart';
import 'package:firebase/firebase.dart';
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../others/helper.dart';
class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final codeController = TextEditingController();

  List<TeacherAccount> _teachers = [];
  DatabaseReference _firebaseRef = database().ref("teacher accounts");
//TODO : uncomment next statement

  //var _firebaseRef = FirebaseDatabase().reference().child('teacher accounts');
  TeacherAccount teacher ;
  int index;

  TeacherAccount getTeacher(String code) {
    index = _teachers.indexWhere((element) => (element.teacherCode == code||element.clerkCode==code));
    if (index == -1) {
      Toast.show("كود خاطىء ، حاول مرة اخرى", context,
          duration: 3, gravity: Toast.CENTER);
      return null;
    }

    else{
      if(_teachers[index].expired!=true){
      saveTeacherId(index);
      return _teachers[index];

      }
      else{
        Toast.show("كود خاطىء ، حاول مرة اخرى", context,
            duration: 3, gravity: Toast.CENTER);
        return null;
      }
  }}


  Future<void> saveTeacherId(int index) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("teacherId",_teachers[index].userId);
  }
  @override
  void initState() {

    _firebaseRef.remove();
    //TODO : uncomment next word

    onChildAdded(/*Event*/ event) {
      if(event.snapshot.value["expiryDate"]!=null){
      _teachers.add(TeacherAccount.fromSnapshot(event.snapshot));
    }}
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
          title: Align(
              alignment: Alignment.centerRight,
              child: Text("تسجيل الدخول ",style: titleText,)),
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
                height: MediaQuery.of(context).size.height*0.2+20,
                width: MediaQuery.of(context).size.width*0.6,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Card(
                      elevation: 5,
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
                              textDirection: TextDirection.rtl,
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                            fillColor: Colors.white60,
                            filled: true,
                            //TODO : uncomment next statement
                            contentPadding:EdgeInsets.symmetric(vertical: 20,horizontal: 5) /*EdgeInsets.symmetric(horizontal: 5)*/,
                            labelText: "كود المعلم",
                            labelStyle:
                                TextStyle(fontSize: 17),
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
                //TODO : uncomment next statement

                padding: EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width*0.04,vertical: 30)/*EdgeInsets.symmetric(vertical: 5, horizontal: 30)*/,
                color: accentColor,
                child: Text(
                  "دخول",
                  style: titleText,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                onPressed: () {
                   teacher = getTeacher(codeController.text);

                  if (teacher != null) {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (ctx) => Profile(teacher.userId)));
                  }
                },
              )
            ],
          ),
        ));
  }
}
