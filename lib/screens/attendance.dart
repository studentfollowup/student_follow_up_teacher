import 'package:flutter/material.dart';
import 'package:student_follow_up_teacher/colors/colors.dart';
import 'package:barcode_scan/barcode_scan.dart';

class Attendance extends StatefulWidget {
  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  List<String> _centers = ["الاوائل", "اجيال", "بداية"];
  String _selectedCenter;
  String result = "مسح";
  bool scan = false;

  Future _qrResult() async {
    var scanRes = await BarcodeScanner.scan();

    //   print("qr content : ${scanRes.rawContent}");
    setState(() {
      // scan=true;
      result = scanRes.rawContent;
    });
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(
        "تم تسجيل الحضور ",
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.green,
    ));
  }

  @override
  Widget build(BuildContext context) {
    print("rebuild ");
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("تسجيل الحضور "),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        //  mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              width: deviceWidth * 0.6,
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
                    style: TextStyle(color: accentColor, fontSize: 18),
                  ),
                  value: _selectedCenter,
                  onChanged: (value) {
                    setState(() {
                      _selectedCenter = value;
                    });
                  },
                  items: _centers.map((center) {
                    return DropdownMenuItem(
                      child: Text(
                        center,
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        style: TextStyle(color: accentColor, fontSize: 18),
                      ),
                      value: center,
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          GestureDetector(
            onTap: _qrResult,
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
                            style: TextStyle(fontSize: 18, color: accentColor),
                          )
                        ],
                      )),
          ),
          SizedBox(
            height: 30,
          ),
          FlatButton(
            textColor: Colors.white,
            color: accentColor,
            shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Text(
              "مسح اخر",
              style: TextStyle(fontSize: 18),
            ),
            onPressed: !(result=="مسح")?() {
              setState(() {
                _qrResult();
              });
            }:null
          ),
        ],
      ),
    );
  }
}
