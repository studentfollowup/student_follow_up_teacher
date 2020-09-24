import '../models/teacher_account.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:student_follow_up_teacher/screens/profile.dart';
import '../models/teacher_account.dart';
//TODO: uncomment next statement
//import 'package:firebase_database/firebase_database.dart';
import 'package:firebase/firebase.dart';
import '../others/colors.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:true_time/true_time.dart';
import 'package:ntp/ntp.dart';
import '../others/helper.dart';
import 'dart:io' as io;
import 'package:student_follow_up_teacher/others/BaseState.dart';
import 'package:student_follow_up_teacher/others/LoadingDialog.dart';
// TODO: uncomment next block
 import 'package:universal_html/prefer_universal/html.dart' as html;
 import 'package:firebase/firebase.dart' as fb;
import 'dart:html';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';

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
  DatabaseReference _firebaseRef = database().ref("teacher accounts");
//TODO: uncomment next statement
//  var _firebaseRef = FirebaseDatabase().reference().child('teacher accounts');
  String titleText = "انشاء حساب جديد";
  String buttonText = "انشاء حساب";

  io.File _image;
  bool isPickImage = false;

  String selectedImageUrl = "";

  final picker = ImagePicker();


  TeacherAccount teacherAccount = new TeacherAccount(
      teacherCode: null,
      imageUrl: null,
      name: null,
      subject: null,
      description: null,
      numbers: null,
      educationLevels: null,
      clerkCode: null,
      version: null);
  DateTime _myTime;


  Future<void> saveTeacherId(String id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("teacherId", id);
//    print("teacherId in shared ${pref.getString("teacherId")}");
  }

  //save function of form
  Future<void> onSave() async {
    print("i'm here onSave");
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if (titleText == "تعديل الحساب الشخصى") {
//        print("ana b3dl el profile");
//        print("${widget._teacher.userId}");
        teacherAccount.teacherCode = widget._teacher.teacherCode;
        teacherAccount.userId = widget._teacher.userId;
        teacherAccount.accepted = widget._teacher.accepted;
        teacherAccount.clerkCode = widget._teacher.clerkCode;
        teacherAccount.expiryDate=widget._teacher.expiryDate;
        teacherAccount.expired=widget._teacher.expired;
//        print("this is accept => ${widget._teacher.accepted}");
        teacherAccount.version=widget._teacher.version;

        _firebaseRef.child(widget._teacher.userId).set(teacherAccount.toMap());
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (ctx) => Profile(teacherAccount.userId)));
      } else {
        _myTime = await NTP.now();
//print("i'm a new Teacher");
        teacherAccount.teacherCode = randomNumeric(5);
        teacherAccount.clerkCode = randomNumeric(5);
        teacherAccount.version = widget._teacher.version;
        if (teacherAccount.version == "النسخة التجريبية") {
          teacherAccount.expiryDate = _myTime.add(Duration(days: 7));
          teacherAccount.accepted=true;
        }
        _firebaseRef = _firebaseRef.push();
        String id = _firebaseRef.key;
//        print("id is >>>> $id");
        _firebaseRef.set(teacherAccount.toMap());
//        print("version >>> ${widget._teacher.version}");
        saveTeacherId(id);
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (ctx) => Profile(id)));

//        Navigator.of(context).pushReplacement(MaterialPageRoute(
//            builder: (ctx) => Profile(teacherAccount.userId)));
      }
    }
  }

  Future<void> getTime() async {
//    print("i'm on time zone");
    _myTime = await NTP.now();
    DateTime _ntpTime;

    /// Or you could get NTP current (It will call DateTime.now() and add NTP offset to it)
//    print("from date time .now ${DateTime.now()}");

    /// Or get NTP offset (in milliseconds) and add it yourself
    final int offset = await NTP.getNtpOffset(localTime: DateTime.now());
    _ntpTime = _myTime.add(Duration(milliseconds: offset));

//    print('My time: $_myTime');
//    print('NTP time: $_ntpTime');
//    print('Difference: ${_myTime.difference(_ntpTime).inMilliseconds}ms');
  }



  @override
  void dispose() {
    // TODO: implement dispose
    imageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
//    print("_teacher ${imageController.text}");
//    print("Teacher ID: --> ${widget._teacher.userId}");
    if (widget._teacher.name != null) {
      setState(() {
          titleText = "تعديل الحساب الشخصى";
          buttonText = "حفظ";
          //TODO:uncomment next section
       /* _firebaseRef
            .child(widget._teacher.userId)
            .once()
            .then((DataSnapshot dataSnapshot) {
          teacherAccount = TeacherAccount.fromSnapshot(dataSnapshot);
        });

        */
          _firebaseRef
              .child(widget._teacher.userId)
              .once("value")
              .then((event) {
            teacherAccount = TeacherAccount.fromSnapshot(event.snapshot);
          });
        teacherAccount.imageUrl = widget._teacher.imageUrl;
      });
    }
    getTime();
//  _auth = FirebaseAuth.instance;
//  _getCurrentUser();
////  print("this is current user: $mCurrentUser");
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
                      //TODO:uncomment next line
//                      margin: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                             child: Container(
                                margin: EdgeInsets.all(10),
                                width: double.infinity,
                                decoration: new BoxDecoration(
                                    border: new Border.all(
                                        color: primaryColor),
                                    borderRadius: BorderRadius.circular(7.0)),
                                height: 200,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: isPickImage
                                  // TODO: uncomment next statement

                                      ? kIsWeb?Image.memory(uploadedWebImage):CachedNetworkImage(
                                    placeholder: (context, url) =>
                                        Opacity(
                                          opacity: 0.5,
                                          child: Image.asset(
                                            'images/learning.png',
                                            width: 100,
                                            height: MediaQuery
                                                .of(context)
                                                .size
                                                .height,
                                          ),
                                        ),
                                    imageUrl:
                                    '$selectedImageUrl',
                                    width: 100,
                                    height: MediaQuery
                                        .of(context)
                                        .size
                                        .height,
                                    fit: BoxFit.contain,
                                  )
                                      : (titleText == "تعديل الحساب الشخصى")?
                                  CachedNetworkImage(imageUrl:
                                  '${widget._teacher.imageUrl}',
                                    width: 100,
                                    height: MediaQuery
                                        .of(context)
                                        .size
                                        .height,
                                    fit: BoxFit.contain,)
                                  :Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add_a_photo,
                                        color: primaryColor,
                                      ),
                                      SizedBox(height: 10,),
                                      Text("اختر صورة", style: contrastText,)
                                    ],
                                  ),
                                ),
                              ),
                              onTap: () {
                                // TODO: uncomment next statement

                              /*  kIsWeb?*/pickImageFromComputer()/*:showImageModal()*/;
                              },
                            ),
                        SizedBox(
                          height: 10,
                        ),
//
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
                                          color: primaryColor,
                                          textDirection: TextDirection.rtl,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                        ),
                                        fillColor: Colors.white60,
                                        filled: true,
                                        contentPadding:
                                            //TODO: uncomment next line
                                            //EdgeInsets.symmetric(horizontal: 5),
                                        EdgeInsets.symmetric(horizontal: 5,vertical: 25),
                                        labelText: "اسم المعلم",
                                        labelStyle: TextStyle(fontSize: 17),
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
                                        prefixIcon: Icon(
                                          Icons.subject,
                                          color: primaryColor,
                                          textDirection: TextDirection.rtl,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                        ),
                                        fillColor: Colors.white60,
                                        filled: true,
                                        contentPadding:
                                        //TODO: uncomment next line

//                                            EdgeInsets.symmetric(horizontal: 5),
                                        EdgeInsets.symmetric(horizontal: 5,vertical: 25),
                                        labelText: "المادة",
                                        labelStyle: TextStyle(fontSize: 17),
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
                                            color: primaryColor,
                                            textDirection: TextDirection.rtl,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15)),
                                          ),
                                          fillColor: Colors.white60,
                                          filled: true,
                                          contentPadding:
                                          //TODO: uncomment next line
//                                              EdgeInsets.symmetric(horizontal: 8),

                                          EdgeInsets.symmetric(horizontal: 5,vertical: 25),
                                          labelText: "المراحل الدراسية ",
                                          labelStyle: TextStyle(fontSize: 17),
                                          helperText:
                                              "مثال: الصف الاول الثانوى ، الصف الثانى الثانوى "),
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
                                          color: primaryColor,
                                          textDirection: TextDirection.rtl,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                        ),
                                        fillColor: Colors.white60,
                                        filled: true,
                                        contentPadding:
                                        //TODO: uncomment next line

//                                            EdgeInsets.symmetric(horizontal: 5),
                                        EdgeInsets.symmetric(horizontal: 5,vertical: 25),
                                        labelText: "نبذة",
                                        labelStyle: TextStyle(fontSize: 17),
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
                                          color: primaryColor,
                                          textDirection: TextDirection.rtl,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                        ),
                                        fillColor: Colors.white60,
                                        filled: true,
                                        contentPadding:

                                        //TODO: uncomment next line

//                                            EdgeInsets.symmetric(horizontal: 5),
                                        EdgeInsets.symmetric(horizontal: 5,vertical: 25),
                                        labelText: "ارقام التليفون",
                                        labelStyle: TextStyle(fontSize: 17),
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
                                  builder: (ctx) =>  RaisedButton(
                                        color: primaryColor,
                                        textColor: Colors.white,
                                        padding:
                                            //TODO: uncommennt next line
                                        /*EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 15),*/
                                        EdgeInsets.symmetric(vertical: 20,horizontal: deviceWidth*0.06+10),
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
                                  ),
                                )
                          ],
                        ),
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
  //TODO:uncomment next block

  /* showImageModal() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
              height: 100,
              color: Colors.white,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      IconButton(
                          onPressed: () =>
                              pickImageFromGallery(ImageSource.camera),
                          icon: Icon(
                            Icons.camera_alt,
                            size: 30,
                            color: primaryColor,
                          )),
                      Text(
                        'Camera',
                        style: TextStyle(
                            fontSize: 15.0,
//                            fontFamily: 'Poppins',
                            color: primaryColor),
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      IconButton(
                          onPressed: () =>
                              pickImageFromGallery(ImageSource.gallery),
                          icon: Icon(
                            Icons.photo_album,
                            size: 30,
                            color: primaryColor,
                          )),
                      Text(
                        'Gallery',
                        style: TextStyle(
                            fontSize: 15.0,
//                            fontFamily: 'Poppins',
                            color: primaryColor),
                      )
                    ],
                  )
                ],
              ));
        });
  }

  */
  //TODO:uncomment next block

  /* pickImageFromGallery(ImageSource source) async {
    final pickedFile =
    await picker.getImage(source: source, maxWidth: 500, maxHeight: 500);
    _image = io.File(pickedFile.path);
    Navigator.pop(context);
    _uploadImage();
  }
  _uploadImage() async {

    LoadingDialog loadingDialog = LoadingDialog();
    loadingDialog.show();

    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('teacher_images/${DateTime.now()}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
//    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        selectedImageUrl = fileURL;
      });
      if(selectedImageUrl!=null){
       teacherAccount.imageUrl=selectedImageUrl;
//       print(selectedImageUrl);
      }
      loadingDialog.hide();
     // showSuccessMsg("Image Uploaded successfully");
      isPickImage = true;
      setState(() {});

    }).catchError((){
     // showErrorMsg("Error, check internet connection and try again");
    });
  }
  */

  //TODO:uncomment next block

  Uint8List uploadedWebImage;
  File pickedImageWebFile;
  pickImageFromComputer() async {
    InputElement uploadInput = FileUploadInputElement();
    uploadInput.click();
    uploadInput.onChange.listen((e) {
      // read file content as dataURL
      final files = uploadInput.files;
      if (files.length == 1) {
        pickedImageWebFile = files[0];
        FileReader reader =  FileReader();
        reader.onLoadEnd.listen((e) {
          setState(() {
            uploadedWebImage = reader.result;
            isPickImage=true;
//            showProgress();
            uploadImageFileWeb(pickedImageWebFile, imageName: DateTime.now().millisecondsSinceEpoch.toString());
          });
        });
        reader.onError.listen((fileEvent) {
          setState(() {
//            showErrorMsg("Error, please try again later");
          });
        });
        reader.readAsArrayBuffer(pickedImageWebFile);
      }
    });
  }
  Future<Uri> uploadImageFileWeb(File image,
      {String imageName}) async {
    fb.StorageReference storageRef = fb.storage().ref('images/$imageName');
    fb.UploadTaskSnapshot uploadTaskSnapshot = await storageRef.put(image).future;
    Uri imageUri = await uploadTaskSnapshot.ref.getDownloadURL();
    selectedImageUrl = imageUri.toString();
//    hideProgress();
//    showSuccessMsg("تم اضافة الصورة بنجاح");
    //print("Success:--> ${imageUri.toString()}");
    return imageUri;
  }
}
