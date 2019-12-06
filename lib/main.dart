import 'package:flutter/material.dart';
import 'package:music/pages/home.dart';
//import 'package:music/pages/loading.dart';
void main() => runApp(MaterialApp(
  theme:ThemeData(
//    brightness: Brightness.dark,
//    primaryColor: Colors.lightBlue[800],
//    accentColor: Colors.cyan[600],
  ),
  initialRoute: '/',
  routes: {
//    "/":(context) => Load(),
    "/": (context) => Home(),
  },
));