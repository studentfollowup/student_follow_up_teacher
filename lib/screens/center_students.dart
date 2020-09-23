import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_follow_up_teacher/models/student_account.dart';
import 'package:student_follow_up_teacher/models/teacher_account.dart';
import 'package:student_follow_up_teacher/others/colors.dart';
import 'package:student_follow_up_teacher/others/helper.dart';
import 'package:student_follow_up_teacher/widgets/drawer.dart';
import '../models/centers.dart';

class CenterStudents extends StatefulWidget {
  String center;

  @override
  _CenterStudentsState createState() => _CenterStudentsState();

  CenterStudents(this.center);
}

class _CenterStudentsState extends State<CenterStudents> {
  final scafoldKey = new GlobalKey<ScaffoldState>();
  List<String> studentsId;
  List<dynamic> teachers;
  List<dynamic> centerStudents = [];
  List<dynamic> searchList = [];
  var students = [];
  String stop = "تعطيل";

//  bool empty = true;
  bool isLoading = true;
  String id;
  List<String> centerName = [];
  List<dynamic> list = [];
  int counter = 0;
  List<int> choosenIndex = [];
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
//        centers.id="-khgohgodg26fhdi";

////        print(teacherName);
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
//                  print("${l.length} kaaaaaaaaam");
                  if (l.length > 1) {
                    l.removeAt(0);
                  }
                  l.forEach((element) {
                    counter = 0;

                    if (element.groupName == widget.center) {
                      element.teachers.forEach((g) {
//                        print(g);
////                    print(teachers.length);
                        // Map<dynamic,dynamic>.from(g);
                        if (g[teacherName] == true) {
//                          print("hena feh counter= $counter");
                          choosenIndex.add(counter);
//                          print(element.groupName);
                          choosenCenter.add(element);
                          centerName.add(element.groupName);
//                          print(centerName.length);
//                          print(element.teachers);
                          setState(() {
                            centerStudents.add(StudentAccount.fromSnapshot(
                                studentEvent.snapshot));
//                            print(centerStudents.length);
                            //empty = false;
                          });
                        } else {
                          counter++;
//                          print("counter is -> $counter");
                        }
                      });
                    }
                  });
                  setState(() {
                    isLoading = false;
                  });
                });
              }
            });
          }
          else{
            setState(() {
              isLoading
              =false;
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
      return new Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                Text(" :الكود"),
                Text(studentAccount.studentCode),
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
      backgroundColor: Colors.white,
      key: scafoldKey,
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerRight,
          child: Text(
            "الطلاب المسجلين",
            style: titleText,

            textAlign: TextAlign.right,
          ),
        ),
      ),

      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : (!isLoading && centerStudents.isEmpty)
              ? Center(
                  child: Text("لا يوجد طلاب مسجلين"),
                )
              : Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10, right: 10, left: 10),
                      child: TextField(
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.right,
                          decoration: new InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(20.0),
                                ),
                              ),
                              filled: true,
                              hintStyle: new TextStyle(color: Colors.grey[800]),
                              hintText: "بحث",
                              fillColor: Colors.white70),
//                  controller: searchController,
//
                          onChanged: (value) {
//
//                            print("value=> $value");
                            if (value != "") {
//                if (value.runtimeType == int) {
//                  teacherList.forEach((element) {
//                    if (element.teacherCode == value) {
//                      searchList.add(element);
//                    }
//                  });

//                              print("i'm here a string");

                              centerStudents.forEach((student) {
                                if (student.name.startsWith(value, 0) ||
                                    student.studentCode.startsWith(value, 0)) {
//                                  print("contains name");
                                  if (searchList.isEmpty) {
                                    setState(() {
                                      searchList.add(student);
                                    });
                                  } else {
                                    searchList.forEach((element) {
                                      if ((element.name != student.name) ||
                                          (element.studentCode !=
                                              student.studentCode)) {
                                        setState(() {
                                          searchList.add(student);
                                        });
                                      }
                                    });
                                  }
                                }

                                else if (!student.name.startsWith(value, 0) ||
                                    (!student.studentCode
                                        .startsWith(value, 0))) {
                                  searchList.forEach((element) {
                                    if (element.name == student.name ||
                                        (element.studentCode ==
                                            student.studentCode)) {
                                      setState(() {
                                        searchList.remove(element);
                                      });
                                    }
                                  });
                                }
                              });
                            } else {
//                              print("i'm null");
                              setState(() {
                                searchList.clear();
//                                print(
//                                    "searchList length => ${searchList.length}");
                              });
                            }
                          }),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ListView.builder(
                          itemCount: searchList.isNotEmpty
                              ? searchList.length
                              : centerStudents.length,
                          itemBuilder: (context, index) {
                            return Directionality(
                              textDirection: TextDirection.rtl,
                              child: GestureDetector(
                                onTap: () {
                                  searchList.isNotEmpty
                                      ? showBottomSheet(searchList[index])
                                      : showBottomSheet(centerStudents[index]);

////                            print(centerStudents[index].runtimeType);
                                },
                                child: Card(
                                  elevation: 3,
                                  child: Column(
                                    children: [
                                      ListTile(
                                        leading: searchList.isNotEmpty
                                            ? CircleAvatar(
                                                radius: 30,
                                                backgroundImage: searchList[
                                                                index]
                                                            .imageUrl ==
                                                        null
                                                    ? NetworkImage(
                                                        "https://c7.uihere.com/files/782/114/405/5bbc3519d674c-thumb.jpg")
                                                    : NetworkImage(
                                                        searchList[index]
                                                            .imageUrl))
                                            : CircleAvatar(
                                                radius: 30,
                                                backgroundImage: centerStudents[
                                                                index]
                                                            .imageUrl ==
                                                        null
                                                    ? NetworkImage(
                                                        "https://c7.uihere.com/files/782/114/405/5bbc3519d674c-thumb.jpg")
                                                    : NetworkImage(
                                                        centerStudents[index]
                                                            .imageUrl)),
                                        title: searchList.isNotEmpty
                                            ? Text(searchList[index].name)
                                            : Text(centerStudents[index].name),
                                        subtitle: Column(
                                          textDirection: TextDirection.rtl,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("سنتر  ${widget.center}"),
                                            searchList.isNotEmpty
                                                ? Text(searchList[index]
                                                    .educationalLevel)
                                                : Text(centerStudents[index]
                                                    .educationalLevel),
                                          ],
                                        ),
//                                          trailing: Container(
//                                              width: 70,
//                                              height: 40,
//                                              decoration: BoxDecoration(
//                                                  borderRadius:
//                                                      BorderRadius.circular(10),
//                                                  color: Colors.green),
//                                              margin: EdgeInsets.only(left: 10),
//                                              child: FlatButton(
//                                                  child: Text(
//                                                    "قبول",
//                                                    style: TextStyle(
//                                                        fontWeight: FontWeight.bold,
//                                                        fontSize: 18,
//                                                        color: Colors.white),
//                                                  ),
//                                                  onPressed: () {
//                                                    _firebase
//                                                        .child(centerStudents[index]
//                                                            .studentId)
//                                                        .child("centers")
//                                                        .child(
//                                                            choosenCenter[index].id)
//                                                        .child("teachers")
//                                                        .child(
//                                                            choosenIndex.toString())
//                                                        .child(teacherName)
//                                                        .set(true)
//                                                        .then((value) {
//                                                      setState(() {
//                                                        centerStudents
//                                                            .removeAt(index);
////                                                    if (centerStudents
////                                                        .isEmpty) {
////                                                      empty = true;
////                                                    }
//                                                      });
//                                                    });
//                                                  }))
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                              // width: 120,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: primaryColor),
                                              margin: EdgeInsets.only(left: 10),
                                              child: FlatButton(
                                                  child: Text(
                                                    "بيان الدرجات",
                                                    style: TextStyle(
//                                                        fontWeight:
//                                                            FontWeight.bold,
                                                        fontSize: 14,
                                                        color: Colors.white),
                                                  ),
                                                  onPressed: () {})),
                                          Container(
                                              //    width: 120,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: primaryColor),
                                              margin: EdgeInsets.only(left: 10),
                                              child: FlatButton(
                                                  child: Text(
                                                    "سجلات الحضور ",
                                                    style: TextStyle(
//                                                        fontWeight:
//                                                        FontWeight.bold,
                                                        fontSize: 14,
                                                        color: Colors.white),
                                                  ),
                                                  onPressed: () {})),
                                          Container(
                                              // width:70,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: primaryColor),
                                              margin: EdgeInsets.only(left: 10),
                                              child: FlatButton(
                                                  child: Text(
                                                    stop,
                                                    style: TextStyle(
//                                                        fontWeight:
//                                                        FontWeight.bold,
                                                        fontSize: 14,
                                                        color: Colors.white),
                                                  ),
                                                  onPressed: () {
//                                                    print(choosenIndex);
//                                                    print("i'm on t3tel ");
//                                                    print(widget.center);
//                                                    print(choosenCenter[index]
//                                                        .groupName);

                                                    if (searchList.isNotEmpty) {

                                                      _firebase
                                                          .child(
                                                              searchList[index]
                                                                  .studentId)
                                                          .child("centers")
                                                          .child(choosenCenter[
                                                                  index]
                                                              .id)
                                                          .child("teachers")
                                                          .child(choosenIndex[
                                                                  index]
                                                              .toString())
                                                          .child(teacherName)
                                                          .set(false);
                                                      setState(() {
                                                        searchList
                                                            .removeAt(index);
                                                      });
                                                    } else {
                                                      _firebase
                                                          .child(centerStudents[
                                                                  index]
                                                              .studentId)
                                                          .child("centers")
                                                          .child(choosenCenter[
                                                                  index]
                                                              .id)
                                                          .child("teachers")
                                                          .child(choosenIndex[
                                                                  index]
                                                              .toString())
                                                          .child(teacherName)
                                                          .set(false);
                                                      setState(() {
                                                        centerStudents
                                                            .removeAt(index);
                                                      });
                                                    }
                                                  }))
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
