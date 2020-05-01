import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'Student.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Splash(),
  ));
}

class Splash extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      'assets/splash.flr',
        (_) => StudentApp(),
      startAnimation: 'intro',
      backgroundColor: Color.fromARGB(255, 57, 167, 249),
      isLoading: false,
    );
  }
}
