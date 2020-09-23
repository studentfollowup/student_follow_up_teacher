import 'package:flutter/material.dart';
import 'package:ntp/ntp.dart';
import 'file:///C:/Users/10/Downloads/cashier/student_follow_up_teacher/lib/others/colors.dart';
import 'package:barcode_scan/barcode_scan.dart';
//TODO: uncomment next statement
//import 'package:firebase_database/firebase_database.dart';
import 'package:firebase/firebase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_follow_up_teacher/models/centers.dart';
import 'package:student_follow_up_teacher/models/new_center.dart';
import 'package:student_follow_up_teacher/models/student_account.dart';
import 'package:student_follow_up_teacher/others/helper.dart';
import 'package:student_follow_up_teacher/screens/attendance_sheet.dart';
import 'package:student_follow_up_teacher/widgets/drawer.dart';
import 'package:toast/toast.dart';
import '../models/lecture_attendance.dart';
import '../models/student_attendance.dart';

class Attendance extends StatefulWidget {
  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  List<NewCenter> _centers = [];
  LectureAttendance lectureAttendance = new LectureAttendance(students: []);
  List<LectureAttendance> attendanceList = [];


  bool newLec = false;
  bool finished = false;
  bool existLec = false;
  String teacherName;
  String _selectedCenter;
  String _selectedLec;
  String result = "مسح";
  bool scan = false;
  var students = [];
  List<Centers> choosenCenter = [];
  StudentAttendance studentAttendance = new StudentAttendance();

  List<Centers> l = [];
  List<dynamic> centerStudents = [];

  final lecController = TextEditingController();
  final lecNumController = TextEditingController();
  DatabaseReference _firebaseRef = database().ref("teacher accounts");
  DatabaseReference _firebase = database().ref("teacher accounts");
  DatabaseReference _firebaseObject = database().ref("teacher accounts");
//TODO: uncomment next section
  /*
  var _firebaseRef = FirebaseDatabase().reference().child("teacher accounts");
  final _firebase = FirebaseDatabase().reference().child("student accounts");
  var _firebaseObject =
      FirebaseDatabase().reference().child("student accounts");
*/
  String teacherID;
  int pressed = 0;
  String noEmpty = "لا يوجد محاضرات";
  List<StudentAccount> studentsAttendance = [];
  List<String> centerName = [];

  int counter = 0;

  int choosenIndex;

  bool isLoading = true;
  DateTime _myTime;

  Future<void> getTeacherId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    teacherID = sharedPreferences.get("teacherId");
  }


  Future<void> getTime() async {
    _myTime = await NTP.now();
  }

  Future _qrResult() async {
    var scanRes = await BarcodeScanner.scan();

    setState(() {
      result = scanRes.rawContent;

    });


  }

  void recordAttendance(String student, String centerNameString,String lecNum) {
    getTime().then((value) {
      _firebase.onChildAdded.listen((studentEvent) {
        students.forEach((element) {
          if (studentEvent.snapshot.key == element) {
            _firebaseObject
                .child(element)
                .child("centers")
                .onChildAdded
                .listen((event) {
              l.add(Centers.fromSnapshot(event.snapshot));
              if (l.length > 1) {
                l.removeAt(0);
              }
              l.forEach((element) {
                counter = 0;

                if (element.groupName == centerNameString) {
                  element.teachers.forEach((g) {
                    if (g[teacherName] == true) {
                      choosenIndex = counter;
                      choosenCenter.add(element);
                      centerName.add(element.groupName);
                      //TODO: uncomment next statement
                      if (/*studentEvent.snapshot.value["name"] == student*/studentEvent.snapshot.val()["name"] == student) {
                        studentAttendance.teacherName = teacherName;
                        studentAttendance.attendanceTime = _myTime;
                        studentAttendance.centerName = centerNameString;
                        studentAttendance.lectureNumber=lecNum;
                        studentAttendance.isAbsence=false;
                        _firebaseObject
                            .child(studentEvent.snapshot.key)
                            .child("attendance")
                            .push()
                            .set(studentAttendance.toMap());
                      }
                      setState(() {

//TODO: uncomment next statement
                        /*students
                            .remove(studentEvent.snapshot.value["studentId"]);*/
                        students
                            .remove(studentEvent.snapshot.val()["studentId"]);
                      });
                    } else {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text(
                          "حساب هذا الطالب معطل حاليا ",
                          textAlign: TextAlign.right,
                          style: TextStyle(fontSize: 15),
                        ),
                        backgroundColor: Colors.red,
                      ));
                      setState(() {
                        counter++;
                      });
                    }
                  });
                } else {
                  //TODO: uncomment next statement

                  if (/*students.isNotEmpty &&(studentEvent.snapshot.value["name"] == student*/students.isNotEmpty &&(studentEvent.snapshot.val()["name"] == student)) {
                    element.teachers.forEach((e) {
                      if (e[teacherName] == false) {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text(
                            "حساب هذا الطالب معطل حاليا ",
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 15),
                          ),
                          backgroundColor: Colors.red,
                        ));
                      } else {
                        studentAttendance.teacherName = teacherName;
                        studentAttendance.attendanceTime = _myTime;
                        studentAttendance.centerName = centerNameString;
                        studentAttendance.sameCenter=false;
                        studentAttendance.lectureNumber=lecNum;
                        studentAttendance.isAbsence=false;

                        _firebaseObject
                            .child(studentEvent.snapshot.key)
                            .child("attendance")
                            .push()
                            .set(studentAttendance.toMap());
                      }

                    });
                  }
                  else{
                    centerStudents.add(
                        StudentAccount.fromSnapshot(studentEvent.snapshot));
                  }

                }
              });
              setState(() {
                isLoading = false;
              });
            });
          }
        });
      });
    });
  }

  void getAttendanceList(String value) {
    setState(() {
      int index = _centers.indexWhere((element) {
        return element.centerName == value;
      });

      _firebaseRef
          .child(teacherID)
          .child("centers")
          .child(_centers[index].centerId)
          .child("attendance")
          .onChildAdded
          .listen((event) {
        //TODO: uncomment next statement

        if (/*event.snapshot.value["students"] != null*/event.snapshot.val()["students"] != null) {
        } else {
          setState(() {
            attendanceList.add(LectureAttendance.fromSnapshot(event.snapshot));
          });
          Toast.show(
              "attendanceList = ${attendanceList.length.toString()}", context);
        }
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    lecNumController.dispose();
    lecController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getTeacherId().then((value) {
      //TODO: uncomment next block

    /*  _firebaseRef.child(teacherID).once().then((DataSnapshot dataSnapshot) {
        // teacherName = dataSnapshot.value["name"];
        // students = dataSnapshot.value["students"];
      });*/

      _firebaseRef.child(teacherID).once("value").then((value) {
        // teacherName = dataSnapshot.value["name"];
        // students = dataSnapshot.value["students"];
      });
      //TODO: uncomment next block

    /*  onChildAdded(Event e) {
        setState(() {
          _centers.add(NewCenter.fromSnapshot(e.snapshot));
        });
      }

      _firebaseRef
          .child(teacherID)
          .child("centers")
          .onChildAdded
          .listen(onChildAdded);
    });*/
      _firebaseRef
          .child(teacherID)
          .child("centers")
          .onChildAdded
          .listen((event) {
        setState(() {
          _centers.add(NewCenter.fromSnapshot(event.snapshot));
        });
      });
      });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerRight,
          child: Text(
            "تسجيل الحضور ",
            style: titleText,
          ),
        ),
      ),
          drawer: DrawerWidget(),
      body: _centers.isEmpty
          ? Center(

              child: Text("غير مسجل فى اى سنتر"),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                //  mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: deviceWidth * 0.5,
                        margin: EdgeInsets.only(top: 25),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: primaryColor, width: 2)),
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: DropdownButton(
                            hint: Text(
                              "اختر سنتر",
                              style: TextStyle(fontSize: 18),
                            ),
                            value: _selectedCenter,
                            onChanged: (value) {
                              setState(() {
                                _selectedCenter = value;
                                getAttendanceList(_selectedCenter);
                              });
                            },
                            items: _centers.map((center) {
                              return DropdownMenuItem(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    center.centerName,
                                    textDirection: TextDirection.rtl,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                value: center.centerName,
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 150,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: FlatButton(
                              textColor: Colors.black,
                              child: Text(
                                "محاضرة جديدة",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              onPressed: _selectedCenter == null
                                  ? null
                                  : () {
                                      setState(() {
                                        newLec = true;
                                        existLec = false;
                                      });
                                    }),
                        ),
                        Container(
                          width: 150,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey[400]),
                          child: FlatButton(
                              textColor: Colors.black,
                              child: Text(
                                "محاضرة موجودة",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              onPressed: _selectedCenter == null
                                  ? null
                                  : () {
                                      setState(() {
                                        pressed++;
                                        newLec = false;
                                        existLec = true;
                                      });
                                      if (pressed == 1) {
                                        // getAttendanceList();

                                      }
                                    }),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if (existLec && attendanceList.isNotEmpty)
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: DropdownButton(
                        hint: Text(
                          "اختر محاضرة",
                          style: TextStyle(fontSize: 18),
                        ),
                        value: _selectedLec,
                        onChanged: (value) {
                          setState(() {
                            _selectedLec = value;
                          });
                        },
                        items: attendanceList.map((attendance) {
                          return DropdownMenuItem(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                attendance.lectureName,
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.right,
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            value: attendance.lectureName,
                          );
                        }).toList(),
                      ),
                    ),
                  if (newLec)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
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

                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                            fillColor: Colors.white60,
                            filled: true,
                            contentPadding: EdgeInsets.only(right: 15),
                            labelText: "اسم المحاضرة",
                            labelStyle: TextStyle(fontSize: 17),
                            // helperText: "hello"
                          ),
                          controller: lecController,
                        ),
                      ),
                    ),
                  if (existLec == true && attendanceList.isEmpty)
                    Text("لا يوجد محاضرات"),
                  SizedBox(
                    height: 10,
                  ),
                  if (newLec == true)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
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

                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                            fillColor: Colors.white60,
                            filled: true,
                            contentPadding: EdgeInsets.only(right: 15),
                            labelText: "رقم المحاضرة",
                            labelStyle: TextStyle(fontSize: 17),
                            // helperText: "hello"
                          ),
                          controller: lecNumController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                  SizedBox(
                    height: 10,
                  ),
                  if (newLec == true)
                    Container(
                      width: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                primaryColor.withGreen(160),
                                primaryColor.withRed(30),
                                primaryColor.withBlue(190),
                              ])),
                      child: FlatButton(
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            "حفظ",
                            style: TextStyle(fontSize: 18),
                          ),
                          onPressed: () {
                            Toast.show("تم الحفظ", context,
                                duration: 3, gravity: Toast.CENTER);
                            lectureAttendance.lectureName = lecController.text;
                            lectureAttendance.lectureNumber =
                                int.parse(lecNumController.text.toString());

                            lectureAttendance.students = [];
//                            lectureAttendance.time = null;
                            _centers.forEach((element) {
                              if (element.centerName != _selectedCenter) {
                                _firebaseRef
                                    .child(teacherID)
                                    .child("centers")
                                    .child(element.centerId)
                                    .child("attendance")
                                    .push()
                                    .set(lectureAttendance.toMap());
                              }
                            });

//                  _firebaseRef
//                      .child(teacherID).child("centers").child(
//                      _centers[index].centerId).child("attendance")
//                      .push()
//                      .child(DateTime.now()
//                      .toIso8601String()) //                      .child("attendance")
////                      .child(_selectedCenter)
//                      .child(lecController.text)
//                      .child(lecNumController.text);
                          }),
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  if (_selectedCenter != null &&
                      (lectureAttendance.lectureNumber != null ||
                          _selectedLec != null))
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _qrResult().then((value) {
                            lectureAttendance.students.add(result.toString());
                            Toast.show(
                                lectureAttendance.students.length.toString(),
                                context);
                          });
                        });
                      },
                      child: Container(
                          width: deviceWidth * 0.9 - 10,
                          height: 250,
                          decoration: BoxDecoration(
                              border: Border.all(color: primaryColor, width: 2),
                              borderRadius: BorderRadius.circular(15)),
                          child: !(result == "مسح")
                              ? Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    result,
                                    textAlign: TextAlign.center,
                                  ))
                              : Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.camera_alt),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      result,
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    )
                                  ],
                                )),
                    ),
                  SizedBox(
                    height: 30,
                  ),
                  if (_selectedCenter != null &&
                      (lectureAttendance.lectureNumber != null ||
                          _selectedLec != null))
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
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
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 5),
                                    child: Text(
                                      "مسح اخر",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    )),
                                // color: Colors.pink,

                                onPressed: !(result == "مسح")
                                    ? () {
                                        setState(() {
                                          _qrResult().then((value) {
                                            Toast.show(result, context);
                                            lectureAttendance.students
                                                .add(result.toString());

                                          });
                                        });
                                      }
                                    : null),
                          ),
                          if (lectureAttendance.students != null)
                            Container(
                                width: 150,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          primaryColor.withGreen(160),
                                          primaryColor.withRed(30),
                                          primaryColor.withBlue(190),
                                        ])),
                                child: FlatButton(
                                    textColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Text(
                                      "انتهاء التسجيل",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    onPressed: () {
                                      lectureAttendance.time = DateTime.now();
                                      int index =
                                          _centers.indexWhere((element) {
                                        return element.centerName ==
                                            _selectedCenter;
                                      });
                                      if (newLec == true) {
                                        _firebaseRef
                                            .child(teacherID)
                                            .child("centers")
                                            .child(_centers[index].centerId)
                                            .child("attendance")
                                            .push()
                                            .set(lectureAttendance.toMap())
                                            .then((value) {
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (ctx) =>
                                                      AttendanceSheet(
                                                          lectureAttendance)));
                                        });
                                      }
                                      if (existLec == true &&
                                          _selectedLec != null) {
                                        lectureAttendance.lectureName =
                                            _selectedLec;
                                        int attendanceIndex = attendanceList
                                            .indexWhere((element) =>
                                                element.lectureName ==
                                                _selectedLec);
                                        lectureAttendance.lectureNumber =
                                            attendanceList[attendanceIndex]
                                                .lectureNumber;
                                        _firebaseRef
                                            .child(teacherID)
                                            .child("centers")
                                            .child(_centers[index].centerId)
                                            .child("attendance")
                                            .child(
                                                attendanceList[attendanceIndex]
                                                    .id)
                                            .set(lectureAttendance.toMap())
                                            .then((value) {
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (ctx) =>
                                                      AttendanceSheet(
                                                          lectureAttendance)));
                                        });
                                      }
                                    }))
                        ],
                      ),
                    ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
    );
  }
}
