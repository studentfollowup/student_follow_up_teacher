


import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import 'colors.dart';

class LoadingDialog {
  String message;
  OverlayEntry entry;

  LoadingDialog({Key key, this.message});

  void show() {
    BuildContext _context = navigatorKey.currentState.overlay.context;

    if (entry == null) {
      entry = new OverlayEntry(builder: (BuildContext context) {
        return FunkyOverlay();
      });
    } else {
      hide();
    }

    try {
      Navigator.of(_context).overlay.insert(entry);
    } catch (e) {
      hide();
    }
  }

  void hide() {
    if (entry == null) return;

    try {
      entry.remove();
    } catch (e) {}
  }
}

class FunkyOverlay extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FunkyOverlayState();
}

class FunkyOverlayState extends State<FunkyOverlay>
    with SingleTickerProviderStateMixin {
  String message;

  @override
  void initState() {
    super.initState();

    BackButtonInterceptor.add((stopDefaultButtonEvent, routeInfo) => true);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove((stopDefaultButtonEvent, routeInfo) => true);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent) {
    print("BACK BUTTON!"); // Do some stuff.
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: Center(
        child: Container(
          width: 220,
          height: 100,
          padding: EdgeInsets.all(10),
          decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0))),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(
                    primaryColor),
              ),
              new Padding(padding: EdgeInsets.all(20)),
              Text(
                "Loading...",
                style: TextStyle(color: primaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
