import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import '../main.dart';


class Utils {

  static String dot = "\u2022";

  static String getDateString(DateTime date){
    if(date == null)
      return "";

    String str ="${date.year.toString()}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')}";
    return str;
  }

  static Future showErrorSnackbar(String msg) async {
    BuildContext context = navigatorKey.currentState.overlay.context;
    Flushbar(
      message: msg,
      animationDuration: Duration(milliseconds: 300),
      duration: Duration(seconds: 3),
      isDismissible: true,
      backgroundColor: Colors.red,
    ).show(context);
  }


  static Future showSuccessSnackbar(String msg) async {
    BuildContext context = navigatorKey.currentState.overlay.context;
    Flushbar(
      message: msg,
      animationDuration: Duration(milliseconds: 300),
      duration: Duration(seconds: 3),
      isDismissible: true,
      backgroundColor: Colors.green ,
    ).show(context);
  }

  static bool isDouble(String s){
    try{
      double.parse(s);
      return true;
    }
    catch(e){
      return false;
    }
  }




}