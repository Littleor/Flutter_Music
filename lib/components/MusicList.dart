import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:music/service/music_download.dart';
import 'dart:async';
import 'package:music/service/geturl.dart';


class MusicList extends StatelessWidget {
  final Map songs;
  final int index;
  final ValueChanged<Map> callback;
  final bool exit;
  MusicList({Key key,this.songs,this.index,this.callback,this.exit}):super(key:key);

  String getSingers(Map song){
    List singers = song['artists'];
    String result;
    for(Map singer in singers){
      result = "${(result == null)?'':result}${singer['name']}/";
    }
    return result.substring(0,result.length-1);
  }

  void downloadMusic(Map song,context) async{
    if(exit){
      if(song['color'] == 600 || song['color'] == -1){
        Scaffold.of(context).showSnackBar(SnackBar(
          content:Text("歌曲已下载到/EasyMusic/Download/"),
        ));
      }else{
        Scaffold.of(context).showSnackBar(SnackBar(
          content:Text("歌曲正在下载中ing"),
        ));
      }
    }
    else{
      Map result =await Url.get(song['id']);
      if(result['url'] != null){
        Download music =  new Download();
        music.download( result['url'], "/sdcard/EasyMusic/Download/",song['name'].replaceAll("/", "\\")+'-'+getSingers(song).replaceAll("/", "\\"));
        Scaffold.of(context).showSnackBar(SnackBar(
          content:Text("正在下载 : ${song['name']}"),
          action: SnackBarAction(
              label: "取消",
              onPressed:(){
                music.cancelToken.cancel("cancelled");
                if(music.cancelToken.isCancelled){
                  Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text("已取消下载${song['name']}"),
                      )
                  );
                }
              }
          ),
        ));
        Timer.periodic(Duration(milliseconds: 300),(timer){
          if(music.progress == 100) {
            timer.cancel();
            timer = null;
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text("${song['name']}下载完成,已保存到/EasyMusic/Download/下."),
//                                                  action: SnackBarAction(
//                                                      label: "查看",
//                                                      onPressed:() async{
//                                                      }
//                                                  ),
            )
            );
          }
          Map result = {
            'index': this.index,
            'color': ((music.progress != 100) ? (music.progress/20).ceil()*100 : 600),
          };
          callback(result);
        });
      }
      else{
        Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  "获取歌曲链接失败-请在侧滑栏-关于我们-联系作者-Littleor反馈！"),
            )
        );
      }

    }

  }

  @override
  Widget build(BuildContext context){
    return AnimationLimiter(
      child: AnimationConfiguration.staggeredList(
        position: index,
        duration: const Duration(milliseconds: 250),
        child: SlideAnimation(
          verticalOffset: 50.0,
          child: FadeInAnimation(
            child: ListTile(
              title: Text(songs['name']),
              subtitle: Text(getSingers(songs)),
              trailing: IconButton(
                icon: (exit &&( songs['color'] == 600 || songs['color'] == -1)) ? Icon(Icons.check) : Icon(Icons.arrow_downward),
                color: Colors.pink[(songs['color'] == -1 ) ? ( exit ? 600 : 0) : songs['color'] ],
                onPressed: () async{
                  downloadMusic(songs,context);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}


