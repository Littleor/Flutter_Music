import 'package:flutter/material.dart';

class Load extends StatefulWidget {
  @override
  _LoadState createState() => _LoadState();
}
class _LoadState extends State<Load> {
  void getData(){
    Future.delayed(const Duration(seconds: 1),(){Navigator.pushNamedAndRemoveUntil(context, "/home", (Route<dynamic> route) => false);});
  }
  void initState() {
    super.initState();
    getData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SafeArea(
        child: Container(
          child: Text("Loading"),
        ),
      ),
    );
  }
}
