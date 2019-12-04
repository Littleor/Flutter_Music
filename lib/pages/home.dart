import 'package:flutter/material.dart';
import 'package:music/service/search.dart';
import 'package:flutter_exoplayer/audioplayer.dart';
import 'package:music/service/geturl.dart';
import 'package:music/service/music_download.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map songs = {'limit': 0, 'songs': []};
  final keyWordController = TextEditingController();
  AudioPlayer audioPlayer = AudioPlayer();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top, SystemUiOverlay.bottom]);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  void getData() async {
    Map result = await SearchSongs.get(keyword: keyWordController.text);
    setState(() {
      songs = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//        appBar: new AppBar(
//          title: Center(
//            child: const Text("极简音符",
//                softWrap: true ,
//                style: TextStyle(
//                  fontSize: 25.0,
//                  fontWeight: FontWeight.bold,
//                )),
//          ),
//          leading: null,
//        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: keyWordController,
                      decoration: InputDecoration(
                        labelText: '请输入歌曲名字',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    tooltip: '搜索',
                    onPressed: () {
                      if (keyWordController.text != "") {
                        getData();
                      } else {
                        showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Align(
                                    alignment: Alignment.center,
                                    widthFactor: 2.0,
                                    heightFactor: 1.0,
                                    child: Text(
                                      '请输入内容!',
                                      style: TextStyle(fontSize: 30),
                                    )),
                                title: Center(
                                    child: Text(
                                  'Waring',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                )),
                                actions: <Widget>[
                                  FlatButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('确定')),
                                ],
                              );
                            });
                      }
                    },
                  ),
                ],
              ),
              Container(
                  child: Expanded(
                    child: ListView.builder(
                itemCount: songs['limit'],
                itemBuilder: (context, index) {
                    return Card(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 30, 0, 30),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    flex:8,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          songs['songs'][index]['name'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        SizedBox(height: 12.0),
                                        Text(songs['songs'][index]['artists'][0]['name'])
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Row(
                                      children: <Widget>[
                                        IconButton(
                                            icon: songs['songs'][index]['play']
                                                ? Icon(Icons.pause)
                                                : Icon(Icons.play_arrow),
                                            tooltip: '播放',
                                            iconSize: 30,
                                            onPressed: () async {
                                              if (songs['songs'][index]['play'] == false) {
                                                Map result =
                                                    await Url.get(songs['songs'][index]['id']);
                                                print("Play ${result['url']}");
                                                audioPlayer.play(result['url']);
                                                audioPlayer.setVolume(100);
                                                setState(() {
                                                  songs['songs'][index]['play'] = true;
                                                });
                                              } else {
                                                print("Pause");
                                                await audioPlayer.pause();
                                                setState(() {
                                                  songs['songs'][index]['play'] = false;
                                                });
                                              }
                                            }),
                                        IconButton(
                                            icon: !(File("/sdcard/EasyMusic/Download/${songs['songs'][index]['name']}-${songs['songs'][index]['artists'][0]['name']}.flac").existsSync() || File("/sdcard/EasyMusic/Download/${songs['songs'][index]['name']}-${songs['songs'][index]['artists'][0]['name']}.mp3").existsSync())?Icon(Icons.file_download):Icon(Icons.autorenew),
                                            tooltip: '下载',
                                            iconSize: 30,
                                            onPressed: () async {
                                              Map result =
                                              await Url.get(songs['songs'][index]['id']);
                                              Download music =  new Download();
                                              music.download( result['url'], "/sdcard/EasyMusic/Download/",songs['songs'][index]['name']+'-'+songs['songs'][index]['artists'][0]['name']);
                                              Scaffold.of(context).showSnackBar(SnackBar(
                                                content:Text("正在下载 : ${songs['songs'][index]['name']}"),
                                                action: SnackBarAction(
                                                    label: "取消",
                                                    onPressed:(){
                                                      music.cancelToken.cancel("cancelled");
                                                      if(music.cancelToken.isCancelled){
                                                        Scaffold.of(context).showSnackBar(
                                                            SnackBar(
                                                              content: Text("已取消下载${songs['songs'][index]['name']}"),
                                                            )
                                                        );
                                                       }
                                                    }
                                                ),
                                              ));
                                              Timer.periodic(Duration(milliseconds: 500),(timer){
                                                if(music.progress == 100){
                                                  timer.cancel();
                                                  timer = null;
                                                  setState(() {

                                                  });
                                                  Scaffold.of(context).showSnackBar(SnackBar(
                                                    content:Text("${songs['songs'][index]['name']}下载完成,已保存到/EasyMusic/Download/下."),
//                                                  action: SnackBarAction(
//                                                      label: "查看",
//                                                      onPressed:() async{
//                                                      }
//                                                  ),
                                                  ));
                                                }
                                              });

                                            }),
                                      ],
                                    ),
                                  ),

                                ]),
                          ),
                        );
                },
              ),
                  )),
            ],
          ),
        ));
  }
}
