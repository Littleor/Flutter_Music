import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'dart:io';
import 'package:music/service/music_download.dart';

class Load extends StatefulWidget {
  @override
  _LoadState createState() => _LoadState();
}
class _LoadState extends State<Load> {
  bool adExist = false;
  void getData() async{
    this.adExist = await File("/sdcard/EasyMusic/Images/ad.png").exists();
    Map response;
    Dio dio = Dio();
    response =  jsonDecode((await dio.get("http://netease.sixming.com/flash.php")).data);
    Download image = new Download();
    await image.download( response['ad'], "/sdcard/EasyMusic/Images/",'ad','png');
    setState(() {
      print("下载完成");
    });
    Future.delayed(const Duration(milliseconds: 3000),(){Navigator.pushNamedAndRemoveUntil(context, "/home", (Route<dynamic> route) => false);});
  }
  void initState() {
    //SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
    getData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: !adExist ? AssetImage('assets/ad.jpg') : AssetImage('/sdcard/EasyMusic/Images/ad.png'),
              fit: BoxFit.cover,
          ),
        ),
        child: Stack(
            fit: StackFit.expand,
            overflow: Overflow.clip,
            children: <Widget>[
              Positioned(
                  bottom: 0,
                  left: 0,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: Opacity(
                    opacity: 0.5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.amber,
                      ),
                    ),
                  ))
            ],
          ),
      ),
    );
  }
}
