import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_follow_up_teacher/models/student_account.dart';
import 'package:student_follow_up_teacher/models/teacher_account.dart';
import 'package:student_follow_up_teacher/others/helper.dart';
import 'package:student_follow_up_teacher/widgets/drawer.dart';
import '../models/centers.dart';

class NewStudents extends StatefulWidget {
  @override
  _NewStudentsState createState() => _NewStudentsState();
}

class _NewStudentsState extends State<NewStudents> {
  final scafoldKey = new GlobalKey<ScaffoldState>();
  List<String> studentsId;
  List<dynamic> teachers;
  List<dynamic> newStudents = [];
  var students = [];
  bool isLoading = true;
  String id;
  List<String> centerName = [];
  List<dynamic> list = [];
  int counter = 0;
  int choosenIndex;
  List<Map<dynamic, dynamic>> check = [];
  String teacherName;
  List<Centers> l = [];
  Centers centers = new Centers();
  List<Centers> choosenCenter = [];

  var _firebaseRef = FirebaseDatabase().reference().child("teacher accounts");
  final _firebase = FirebaseDatabase().reference().child("student accounts");
  var _firebaseObject =
      FirebaseDatabase().reference().child("student accounts");

  Future<void> getTeacherId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    id = sharedPreferences.get("teacherId");
  }

  @override
  void initState() {
    getTeacherId().then((value) {
      _firebaseRef.child(id).once().then((DataSnapshot dataSnapshot) {
        teacherName = dataSnapshot.value["name"];
      });
      _firebaseRef.child(id).once().then((DataSnapshot dataSnapshot) {
        students = dataSnapshot.value["students"];
      }).then((value) {
        _firebase.onChildAdded.listen((studentEvent) {
           if(students!=null) {
             students.forEach((element) {
               if (studentEvent.snapshot.key == element) {
                 _firebaseObject
                     .child(element)
                     .child("centers")
                     .onChildAdded
                     .listen((event) {
                   l.add(Centers.fromSnapshot(event.snapshot));
                   print("${l.length} kaaaaaaaaam");
                   if (l.length > 1) {
                     l.removeAt(0);
                   }
                   l.forEach((element) {
                     counter = 0;
                     element.teachers.forEach((g) {
                       print(g);
//                    print(teachers.length);
                       // Map<dynamic,dynamic>.from(g);
                       if (g[teacherName] == false) {
                         choosenIndex = counter;
                         print(element.groupName);
                         choosenCenter.add(element);
                         centerName.add(element.groupName);
                         print(centerName.length);
                         print(element.teachers);
                         setState(() {
//                        isLoading=true;
                           newStudents.add(
                               StudentAccount.fromSnapshot(
                                   studentEvent.snapshot));
                           print(newStudents.length);
                         });
                       } else {
                         setState(() {
                           counter++;
                           print("counter is -> $counter");
                         });
                       }
                     });
                   });

                   setState(() {
                     isLoading = false;
                   });
//                list.add(event.snapshot.value["teachers"]);
//                print(list.length);
//                if (list.length > 1) {
//                  list.removeAt(0);
//                }
//                list.forEach((listCheck) {
//                  print("ht3dy->${Map<dynamic, dynamic>.from(listCheck[1])}");
//                  print(list.length);
//                  print(listCheck[1]);
//                  check.add(Map<dynamic, dynamic>.from(listCheck[1]));
//                  print("check = ${check.length}");
//                });
//                if (check.length > 1) {
//                  check.removeAt(0);
//                }
//
//                check.forEach((e) {
//                  print(e);
//                  if (e[teacherName] == false) {
//
//
//                  }
//                });
                 });
               }
             });
           }
           else{
             setState(() {
                 isLoading=false;
               });
           }
        });
      });
    });

    // TODO: implement initState
    super.initState();
  }

  void showBottomSheet(StudentAccount studentAccount) {
    scafoldKey.currentState.showBottomSheet((context) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        height: MediaQuery.of(context).size.height * 0.3,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(15), topLeft: Radius.circular(15)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
//              mainAxisAlignment: MainAxisAlignment.start,
              textDirection: TextDirection.rtl,
              children: [
                Text(" :الاسم"),
                Text(studentAccount.name),
              ],
            ),
            SizedBox(
              height: 10,
            ),

            Row(
              textDirection: TextDirection.rtl,
              children: [
                Text("  :المرحلة الدراسية"),
                Text(studentAccount.educationalLevel),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              textDirection: TextDirection.rtl,
              children: [
                Text(" :اسم المدرسة "),
                Text(studentAccount.schoolName),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              textDirection: TextDirection.rtl,

              children: [
                Text(" :رقم الهاتف"),
                Text(studentAccount.studentPhone),
              ],
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scafoldKey,

      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerRight,
          child: Text(
            "الطلاب الجدد",
            textAlign: TextAlign.right,
              style: titleText
          ),
        ),
      ),
      drawer: DrawerWidget(),

      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : (!isLoading&&newStudents.isEmpty)
              ? Center(
                  child: Text("لا يوجد طلاب جدد"),
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ListView.builder(
                    itemCount: newStudents.length,
                    itemBuilder: (context, index) {
                      return Directionality(
                        textDirection: TextDirection.rtl,
                        child: GestureDetector(
                          onTap: (){
                            showBottomSheet(newStudents[index]);
                          },
                          child: Card(
                            elevation: 3,
                            child: ListTile(
                                leading: CircleAvatar(
                                    radius: 30,
                                    backgroundImage: newStudents[index]
                                                .imageUrl ==
                                            null
                                        ? NetworkImage(
                                            "https://c7.uihere.com/files/782/114/405/5bbc3519d674c-thumb.jpg")
                                        : NetworkImage(
                                            newStudents[index].imageUrl)),
                                title: Text(newStudents[index].name),
                                subtitle: Column(
                                  textDirection: TextDirection.rtl,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("سنتر  ${centerName[index]}"),
                                    Text(newStudents[index].educationalLevel),
                                  ],
                                ),
                                trailing: Container(
                                    width: 70,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.green),
                                    margin: EdgeInsets.only(left: 10),
                                    child: FlatButton(
                                        child: Text(
                                          "قبول",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Colors.white),
                                        ),
                                        onPressed: () {
                                          _firebase
                                              .child(newStudents[index].studentId)
                                              .child("centers")
                                              .child(choosenCenter[index].id)
                                              .child("teachers")
                                              .child(choosenIndex.toString())
                                              .child(teacherName)
                                              .set(true)
                                              .then((value) {
                                            setState(() {
                                              newStudents.removeAt(index);
                                              Scaffold.of(context).showSnackBar(SnackBar(content: Text("تم القبول",textAlign: TextAlign.right,style: TextStyle(fontSize: 15),),backgroundColor: Colors.green,duration: Duration(seconds: 2),));
//                                              if (newStudents.isEmpty) {
//                                                empty = true;
//                                              }
                                            });
                                            _firebase.child(newStudents[index].studentId).child("accepted").set(true);
                                          });
                                        }))),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
