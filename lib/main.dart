import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/create_account.dart';
import 'screens/profile.dart';
void main() {

  initializeApp(
      apiKey: "AIzaSyBR_xfNOECWLtt9dcPUfuGHamxKcsStgQg",
      authDomain: "student-followup-3c342.firebaseapp.com",
      databaseURL: "https://student-followup-3c342.firebaseio.com",
      projectId: "student-followup-3c342",
      storageBucket: "student-followup-3c342.appspot.com");

  runApp(MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
    );
  }
}