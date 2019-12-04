import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'dart:io';
import 'package:music/service/music_download.dart';
import 'package:permission_handler/permission_handler.dart';
class Load extends StatefulWidget {
  @override
  _LoadState createState() => _LoadState();
}
class _LoadState extends State<Load> {
  bool adShow = false;
  void getData() async{
    Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    // 申请结果
    PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
    if (permission == PermissionStatus.granted) {
      Map response;
      Dio dio = Dio();
      response =  jsonDecode((await dio.get("http://netease.sixming.com/flash.php")).data);
      Future.delayed(const Duration(seconds: 2),(){Navigator.pushNamedAndRemoveUntil(context, "/home", (Route<dynamic> route) => false);});
      if(response['ad']['show'] == true){
        File ad = new File("/sdcard/EasyMusic/Ad/${response['ad']['id']}");
        if(!(await ad.exists())){
          ad.createSync(recursive:true);
          Download image = new Download();
          await image.download(response['ad']['url'], "/sdcard/EasyMusic/Images/",'ad','png');
        }
        setState(() {
          this.adShow = true;
        });
    }
    }
    else{
      print("未获取到权限");
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Warning"),
            content: new Text("软件运行必须要文件读写权限来保存歌曲"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("确定"),
                onPressed: () {
                  getData();
                },
              ),
              new FlatButton(
                child: new Text("取消"),
                onPressed: () async {
                  await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
              ),
            ],
          );
        },
      );
    }
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
              image: !adShow ? AssetImage('assets/images/ad.png') : AssetImage('/sdcard/EasyMusic/Images/ad.png'),
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
                        color: Colors.transparent,
                      ),
                    ),
                  ))
            ],
          ),
      ),
    );
  }
}
