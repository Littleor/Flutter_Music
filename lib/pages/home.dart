import 'package:flutter/material.dart';
import 'package:music/service/search.dart';
import 'package:flutter_exoplayer/audioplayer.dart';
import 'package:music/components/MusicList.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:floating_search_bar/floating_search_bar.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:animated_text_kit/animated_text_kit.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map songs = {'limit': 0, 'songs': [], 'total': 0};
  final keyWordController = TextEditingController();
  FocusNode keyWordFocus = FocusNode();
  AudioPlayer audioPlayer = AudioPlayer();
  String version;
  List<String> words = [
    "老铁,来听歌？",
    "Search a music!",
    "Make music easy!",
    "一天好心情哦!"
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkUpdate();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));
    //statusBarColor: Colors.transparent,statusBarIconBrightness:Brightness.dark
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void searchMusic() async {
    String keyword = keyWordController.text;
    if (keyword != "") {
      Map result = await SearchSongs.get(keyword: keyword);
      setState(() {
        songs = result;
      });
    }
  }

  updateList(Map data) {
    setState(() {
      songs['songs'][data['index']]['color'] = data['color'];
    });
  }

  String getSingers(Map song) {
    List singers = song['artists'];
    String result;
    for (Map singer in singers) {
      result = "${(result == null) ? '' : result}${singer['name']}/";
    }
    return result.substring(0, result.length - 1);
  }

  void checkUpdate([c]) async {
    Dio dio = Dio();
    Map response = jsonDecode(
        (await dio.get("http://netease.sixming.com/flash.php")).data);
    Map data = response['update'];
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) async {
      if (packageInfo.version != data['version']) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title:
                  new Text("更新 ${packageInfo.version} -> ${data['version']}"),
              content:
                  new Text("更新内容: \n${data['desc'].replaceAll("\\n", "\n")}"),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("取消"),
                  onPressed: () async {
                    await SystemChannels.platform
                        .invokeMethod('SystemNavigator.pop');
                  },
                ),
                new FlatButton(
                  child: new Text("确定"),
                  onPressed: () async {
                    if (await canLaunch(data['url'])) {
                      await launch(data['url']);
                      await SystemChannels.platform
                          .invokeMethod('SystemNavigator.pop');
                    } else {
                      await SystemChannels.platform
                          .invokeMethod('SystemNavigator.pop');
                    }
                  },
                ),
              ],
            );
          },
        );
      } else {
        if (this.version == packageInfo.version) {
          Scaffold.of(c).showSnackBar(SnackBar(
            content: Text("当前已是最新版本:${packageInfo.version}"),
          ));
        } else {
          var streetsFromJson = response['words'];
          setState(() {
            this.version = packageInfo.version;
            this.words = new List<String>.from(streetsFromJson);
          });
        }
      }
    });
  }

  void showAbout(context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return AlertDialog(
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                    child: Text(
                  "极简音符\n",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )),
                Text(
                  "联系作者",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                FlatButton.icon(
                  icon: Icon(Icons.person),
                  onPressed: () async {
                    String url;
                    if (Platform.isAndroid) {
                      url = 'mqqwpa://im/chat?chat_type=wpa&uin=1763522572';
                    } else {
                      url =
                          'mqq://im/chat?chat_type=wpa&uin=1763522572&version=1&src_type=web';
                    }
                    if (await canLaunch(url)) {
                      await launch(url); // 启动QQ
                    } else {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text("无法启动QQ"),
                      ));
                    }
                  },
                  label: Text("Littleor - 逻辑设计开发"),
                ),
                FlatButton.icon(
                  icon: Icon(Icons.person),
                  onPressed: () async {
                    String url;
                    if (Platform.isAndroid) {
                      url = 'mqqwpa://im/chat?chat_type=wpa&uin=1203114693';
                    } else {
                      url =
                          'mqq://im/chat?chat_type=wpa&uin=1203114693&version=1&src_type=web';
                    }
                    if (await canLaunch(url)) {
                      await launch(url); // 启动QQ
                    } else {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text("无法启动QQ"),
                      ));
                    }
                  },
                  label: Text(
                    "Bubblegum&Lemonade - 图标设计",
                    softWrap: false,
                  ),
                ),
                FlatButton.icon(
                    onPressed: () async {
                      String url;
                      if (Platform.isAndroid) {
                        url =
                            'mqqopensdkapi://bizAgent/qm/qr?url=http%3A%2F%2Fqm.qq.com%2Fcgi-bin%2Fqm%2Fqr%3Ffrom%3Dapp%26p%3Dandroid%26k%3DnZQmgePBoWp8V8f92jmmRciI00oIWJQD';
                      } else {
                        url =
                            'mqqopensdkapi://bizAgent/qm/qr?url=http%3A%2F%2Fqm.qq.com%2Fcgi-bin%2Fqm%2Fqr%3Ffrom%3Dapp%26p%3Dandroid%26k%3DnZQmgePBoWp8V8f92jmmRciI00oIWJQD';
                      }
                      if (await canLaunch(url)) {
                        await launch(url); // 启动QQ
                      } else {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("无法启动QQ"),
                        ));
                      }
                    },
                    icon: Icon(Icons.people),
                    label: Text("加入群聊 - 826352486")),
                Text(
                  "软件简介\n",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                    "极简音符是一款基于Flutter的开源项目,旨在交流学习,切勿做任何商业用途！\n\n本软件仅供交流学习，请于下载后24h删除！\n\n本软件不提供储存服务，资源皆为网友整理所得!\n\n最后如果觉得软件不错可以请开发者喝杯奶茶."),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("开源地址"),
                onPressed: () async {
                  if (await canLaunch(
                      "https://github.com/Littleor/Flutter_Music")) {
                    await launch("https://github.com/Littleor/Flutter_Music");
                  } else {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text("无法启动浏览器-自行Github搜索Littleor"),
                    ));
                  }
                },
              ),
              FlatButton(
                child: Text("请喝奶茶"),
                onPressed: () async {
                  if (await canLaunch("https://pay.sixming.com/")) {
                    await launch("https://pay.sixming.com/");
                  } else {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text("无法启动浏览器"),
                    ));
                  }
                },
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("确定"),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FloatingSearchBar.builder(
        itemCount:
            (songs['limit'] == 0 || songs['total'] == 0) ? 1 : songs['limit'],
        itemBuilder: (BuildContext context, int index) {
          if (songs['limit'] == 0 && songs['total'] == 0) {
            return Column(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                ),
                ScaleAnimatedTextKit(
                    text: words,
                    textStyle:
                        TextStyle(fontSize: 50.0, fontFamily: "Canterbury"),
                    textAlign: TextAlign.center,
                    alignment:
                        AlignmentDirectional.center // or Alignment.topLeft
                    ),
              ],
            );
          } else if (songs['total'] == 0) {
            return Column(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                ),
                TyperAnimatedTextKit(
                    text: [
                      "没有找到:${keyWordController.text}",
                    ],
                    textStyle: TextStyle(fontSize: 30.0, fontFamily: "Bobbers"),
                    textAlign: TextAlign.start,
                    alignment:
                        AlignmentDirectional.topStart // or Alignment.topLeft
                    )
              ],
            );
          } else {
            return MusicList(
              songs: songs['songs'][index],
              index: index,
              callback: updateList,
              exit: (File("/sdcard/EasyMusic/Download/${songs['songs'][index]['name']}-${getSingers(songs['songs'][index]).replaceAll("/", "\\")}.flac")
                      .existsSync() ||
                  File("/sdcard/EasyMusic/Download/${songs['songs'][index]['name']}-${getSingers(songs['songs'][index]).replaceAll("/", "\\")}.mp3")
                      .existsSync()),
            );
          }
        },
        trailing: Builder(
          builder: (context) => IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                if (keyWordController.text == "") {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text("请输入搜索内容"),
                  ));
                } else {
                  searchMusic();
                }
              }),
        ),
        drawer: Builder(
          builder: (BuildContext context) => Drawer(
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(color: Colors.black12, offset: Offset(1.0, 1.0)),
                  ]),
                  child: Image(
                    image: AssetImage("assets/images/sidebar.jpg"),
                    fit: BoxFit.fitWidth,
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.cached),
                  onTap: () {
                    checkUpdate(context);
                  },
                  title: Padding(
                    padding: EdgeInsets.fromLTRB(10, 1, 0, 1),
                    child: Text("检查更新"),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.home),
                  onTap: () {
                    showAbout(context);
                  },
                  title: Padding(
                    padding: EdgeInsets.fromLTRB(10, 1, 0, 1),
                    child: Text("关于我们"),
                  ),
                ),
                Expanded(
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    overflow: Overflow.clip,
                    children: <Widget>[
                      Positioned(
                        child: Center(child: Text("极简音符 | $version")),
                        bottom: 2.0,
                      )
                    ],
                  ),
                )
              ],
            ),
            //侧滑
          ),
        ),
        onChanged: (String value) {},
        onTap: () {
//          keyWordController.
          FocusScope.of(context).requestFocus(keyWordFocus);
        },
        // focusNode: keyWordFocus,
        decoration: InputDecoration.collapsed(
          hintText: "Search...",
        ),
        controller: keyWordController,
        focusNode: keyWordFocus,
        onComplete: searchMusic,
      ),
    );
//    return Scaffold(
//        appBar: new AppBar(
//          title: (
//              Text("极简音符",
//                softWrap: true ,
//                style: TextStyle(
//                  fontWeight: FontWeight.bold,
//                ))
//          ),
//          centerTitle: true,
//          leading: IconButton(
//            icon: Icon(Icons.menu),
//            onPressed: (){
//
//            },
//          ),
//          bottom: new PreferredSize(
//            preferredSize: const Size.fromHeight(48.0),
//            child: Center(
//              child: Container(
//                child: TextField(
//
//                ),
//              )
//            ),
//          )
//        ),
//        body: Container(
//          decoration:BoxDecoration(
//          ),
//          child: Column(
//              children: <Widget>[
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: <Widget>[
//                    Expanded(
//                      child: TextField(
//                        controller: keyWordController,
//                        decoration: InputDecoration(
//                          labelText: '请输入歌曲名字',
//                        ),
//                      ),
//                    ),
//                    IconButton(
//                      icon: Icon(Icons.search),
//                      tooltip: '搜索',
//                      onPressed: () {
//                        if (keyWordController.text != "") {
//                          getData();
//                        } else {
//                          showDialog(
//                              context: context,
//                              barrierDismissible: true,
//                              builder: (BuildContext context) {
//                                return AlertDialog(
//                                  content: Align(
//                                      alignment: Alignment.center,
//                                      widthFactor: 2.0,
//                                      heightFactor: 1.0,
//                                      child: Text(
//                                        '请输入内容!',
//                                        style: TextStyle(fontSize: 30),
//                                      )),
//                                  title: Center(
//                                      child: Text(
//                                    'Waring',
//                                    style: TextStyle(
//                                        color: Colors.black,
//                                        fontSize: 20.0,
//                                        fontWeight: FontWeight.bold),
//                                  )),
//                                  actions: <Widget>[
//                                    FlatButton(
//                                        onPressed: () {
//                                          Navigator.of(context).pop();
//                                        },
//                                        child: Text('确定')),
//                                  ],
//                                );
//                              });
//                        }
//                      },
//                    ),
//                  ],
//                ),
//                Container(
//                    child: Expanded(
//                      child: ListView.builder(
//                  itemCount: songs['limit'],
//                  itemBuilder: (context, index) {
//                      return Card(
//                            child: Padding(
//                              padding: const EdgeInsets.fromLTRB(20, 30, 0, 30),
//                              child: Row(
//                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                  children: <Widget>[
//                                    Expanded(
//                                      flex:8,
//                                      child: Column(
//                                        crossAxisAlignment: CrossAxisAlignment.start,
//                                        children: <Widget>[
//                                          Text(
//                                            songs['songs'][index]['name'],
//                                            style: TextStyle(
//                                                fontWeight: FontWeight.bold,
//                                                fontSize: 16),
//                                          ),
//                                          SizedBox(height: 12.0),
//                                          Text(songs['songs'][index]['artists'][0]['name'])
//                                        ],
//                                      ),
//                                    ),
//                                    Expanded(
//                                      flex: 3,
//                                      child: Row(
//                                        children: <Widget>[
//                                          IconButton(
//                                              icon: songs['songs'][index]['play']
//                                                  ? Icon(Icons.pause)
//                                                  : Icon(Icons.play_arrow),
//                                              tooltip: '播放',
//                                              iconSize: 30,
//                                              onPressed: () async {
//                                                if (songs['songs'][index]['play'] == false) {
//                                                  Map result =
//                                                      await Url.get(songs['songs'][index]['id']);
//                                                  print("Play ${result['url']}");
//                                                  audioPlayer.play(result['url']);
//                                                  audioPlayer.setVolume(100);
//                                                  setState(() {
//                                                    songs['songs'][index]['play'] = true;
//                                                  });
//                                                } else {
//                                                  print("Pause");
//                                                  await audioPlayer.pause();
//                                                  setState(() {
//                                                    songs['songs'][index]['play'] = false;
//                                                  });
//                                                }
//                                              }),
//                                          IconButton(
//                                              icon: !(File("/sdcard/EasyMusic/Download/${songs['songs'][index]['name']}-${songs['songs'][index]['artists'][0]['name']}.flac").existsSync() || File("/sdcard/EasyMusic/Download/${songs['songs'][index]['name']}-${songs['songs'][index]['artists'][0]['name']}.mp3").existsSync())?Icon(Icons.file_download):Icon(Icons.autorenew),
//                                              tooltip: '下载',
//                                              iconSize: 30,
//                                              onPressed: () async {
//                                                Map result =
//                                                await Url.get(songs['songs'][index]['id']);
//                                                Download music =  new Download();
//                                                music.download( result['url'], "/sdcard/EasyMusic/Download/",songs['songs'][index]['name']+'-'+songs['songs'][index]['artists'][0]['name']);
//                                                Scaffold.of(context).showSnackBar(SnackBar(
//                                                  content:Text("正在下载 : ${songs['songs'][index]['name']}"),
//                                                  action: SnackBarAction(
//                                                      label: "取消",
//                                                      onPressed:(){
//                                                        music.cancelToken.cancel("cancelled");
//                                                        if(music.cancelToken.isCancelled){
//                                                          Scaffold.of(context).showSnackBar(
//                                                              SnackBar(
//                                                                content: Text("已取消下载${songs['songs'][index]['name']}"),
//                                                              )
//                                                          );
//                                                         }
//                                                      }
//                                                  ),
//                                                ));
//                                                Timer.periodic(Duration(milliseconds: 500),(timer){
//                                                  if(music.progress == 100){
//                                                    timer.cancel();
//                                                    timer = null;
//                                                    setState(() {
//
//                                                    });
//                                                    Scaffold.of(context).showSnackBar(SnackBar(
//                                                      content:Text("${songs['songs'][index]['name']}下载完成,已保存到/EasyMusic/Download/下."),
////                                                  action: SnackBarAction(
////                                                      label: "查看",
////                                                      onPressed:() async{
////                                                      }
////                                                  ),
//                                                    ));
//                                                  }
//                                                });
//
//                                              }),
//                                        ],
//                                      ),
//                                    ),
//
//                                  ]),
//                            ),
//                          );
//                  },
//                ),
//                    )),
//              ],
//            ),
//        ),
//        );
  }
}
