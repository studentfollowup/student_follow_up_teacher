import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_follow_up_teacher/models/teacher_account.dart';
import 'package:student_follow_up_teacher/screens/create_account.dart';
import 'package:student_follow_up_teacher/widgets/drawer.dart';
import 'package:firebase_database/firebase_database.dart';
import 'file:///C:/Users/10/Downloads/cashier/student_follow_up_teacher/lib/others/colors.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ntp/ntp.dart';
import 'teacher_case.dart';
import '../others/helper.dart';
class Profile extends StatefulWidget {
  final String teacherId;

  @override
  _ProfileState createState() => _ProfileState();

  Profile(this.teacherId);
}

class _ProfileState extends State<Profile> {
  bool edit = false;
  DateTime _myTime;
  String weekNotification;
  String endNotification;
  TeacherAccount currentUser;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  final _firebaseRef = FirebaseDatabase().reference().child('teacher accounts');
  final _firebase = FirebaseDatabase()
      .reference()
      .child('admin msgs notification')
      .child("full version");

  Future<void> getTeacher(String teacherId) async {
    await _firebaseRef
        .child(teacherId)
        .once()
        .then((DataSnapshot dataSnapshot) {
      setState(() {
        currentUser = TeacherAccount.fromSnapshot(dataSnapshot);

      });
    });
  }

  Future<void> getTime() async {
    _myTime = await NTP.now();
  }

  Future onSelectNotification(String payload) {
    debugPrint("payload : $payload");
    return showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text(
          'تنبيه',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        content: new Text(
          '$payload',
          textAlign: TextAlign.center,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: FlatButton(
              child: Text(
                "موافق",
                style: TextStyle(color: primaryColor, fontSize: 20),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          )
        ],
      ),
    );
  }

  showNotification(String msg) async {
    var android = new AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        priority: Priority.High, importance: Importance.Max);
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(0, 'تنبيه', msg, platform,
        payload: msg);
  }

  Future<void> expiredUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("teacherId", null);
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => TeacherCase()));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getTeacher(widget.teacherId).then((value) {
      if (currentUser.expired == true) {
        expiredUser();
      }
      else{
        getTime().then((value) {
        }).then((value) {
          if (currentUser.expiryDate == _myTime ||
              _myTime.isAfter(currentUser.expiryDate)) {
            if (currentUser.version == "النسخة التجريبية") {
              currentUser.expired = true;
              _firebaseRef.child(widget.teacherId).child("expired").set(true);
              _firebaseRef.child(widget.teacherId).child("accepted").set(false);

            } else if (currentUser.version == "النسخة الكاملة") {
              showNotification(endNotification);
              _firebaseRef.child(widget.teacherId).child("expired").set(true);
              _firebaseRef.child(widget.teacherId).child("accepted").set(false);
            }
          } else {
            int days = currentUser.expiryDate.difference(_myTime).inDays;
            if (days >= 14 ) {
              _firebaseRef.child(widget.teacherId).child("expired").set(true);
              _firebaseRef.child(widget.teacherId).child("accepted").set(false);
              showNotification(weekNotification);
            }
          }

        });

      }

    });

    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(
      initSetttings,
      onSelectNotification: onSelectNotification,
    );
    _firebase.once().then((DataSnapshot dataSnapshot) {
      weekNotification = dataSnapshot.value["weekNotify"];
      endNotification = dataSnapshot.value["endNotify"];
    });
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
                "الحساب الشخصي",
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                style: titleText,
              )),
        ),
        drawer: DrawerWidget(),
        body: currentUser != null
            ? Container(
                height: double.maxFinite,
                width: double.infinity,
                color: Colors.teal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: deviceHeight * 0.06,
                          horizontal: deviceWidth * 0.06),
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
                                color: Colors.white,
                                border:
                                    Border.all(color: Colors.white, width: 2),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: (currentUser.imageUrl == null)
                                      ? AssetImage("images/profile.png")
                                      : NetworkImage(currentUser.imageUrl),
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
                                currentUser.name,
                                style: titleText,
                                textAlign: TextAlign.right,
                              ),
                              Container(
                                  //  margin: EdgeInsets.only(right: 30),
                                  child: currentUser.accepted == true
                                      ? Text(
                                          "الكود : ${currentUser.teacherCode}",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white70,
                                          ),
                                          textAlign: TextAlign.right,
                                        )
                                      : Text(
                                          "غير مفعل ",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white70,
                                          ),
                                          textAlign: TextAlign.right,
                                        )),
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
                        margin: EdgeInsets.symmetric(
                            horizontal: deviceWidth * 0.03),
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
                                        " المادة : ${currentUser.subject}",
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
                                        " المراحل التعليمية: ${currentUser.educationLevels}  ",
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
                                        " نبذة : ${currentUser.description}",
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
                                        " رقم التليفون :${currentUser.numbers} ",
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
                                        " ${currentUser.version} ",
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
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
                                              "تعديل",
                                              style: titleText,
                                            )),
                                        // color: Colors.pink,
                                        onPressed: () {
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (ctx) =>
                                                      CreateAccount(
                                                          currentUser)));
//                            _databaseRef
//                                .child(widget.teacherAccount.userId)
//                                .set(widget.teacherAccount);
                                        },
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          gradient: LinearGradient(
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                              colors: [
                                                accentColor.withBlue(120),
                                                accentColor.withGreen(20),
                                                accentColor.withRed(180)
                                              ])),
                                      child: FlatButton(
//                                elevation: 4,
                                        child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 5),
                                            child: Text(
                                              "كود الموظف",
                                              style: titleText,
                                            )),
                                        //     color: Colors.pink,
                                        onPressed: currentUser.accepted == false
                                            ? null
                                            : () {
//                                                showNotification(
//                                                    weekNotification);
                                                showDialog(
                                                    context: context,
                                                    builder: (ctx) => Container(
                                                          child: AlertDialog(
                                                            backgroundColor:
                                                                Colors.white,
                                                            elevation: 4,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .all(
                                                              Radius.circular(
                                                                  20),
                                                            )),
                                                            actionsPadding:
                                                                EdgeInsets.all(
                                                                    8),
                                                            content: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 15),
                                                              child: Text(
//                                          "test",
                                                                "كود الموظف : ${currentUser.clerkCode}",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                            ),
                                                            actions: [
                                                              FlatButton(
                                                                child: Text(
                                                                  "موافق",
                                                                  style: TextStyle(
                                                                      color:
                                                                          primaryColor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          20),
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ));
                                              },
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(
                  semanticsLabel: "loading ...",
                ),
              ));
  }
}
