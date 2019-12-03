import 'package:flutter/material.dart';
import 'package:music/pages/home.dart';
import 'package:music/pages/loading.dart';
void main() => runApp(MaterialApp(
  initialRoute: '/',
  routes: {
    "/":(context) => Load(),
    "/home": (context) => Home(),
  },
));