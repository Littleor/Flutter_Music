import 'dart:convert';
import 'package:dio/dio.dart';

class SearchSongs{

  static Future<Map> get({String keyword,int limit = 30,int offset = 0}) async{
    //http://netease.sixming.com/api.php?order=search&&keyword=%E7%BA%B8%E7%9F%AD%E6%83%85%E9%95%BF
    Dio dio = Dio();
    String url = 'http://netease.sixming.com/api.php?order=search&&keyword=$keyword&&offset=$offset&&limit=$limit';
    try{
      Map data =  jsonDecode((await dio.get(url)).data);
      List songs = data["result"]["songs"];
      int total = data["result"]["songCount"];
      for(Map song in songs){
        song['play'] = false;
        song['color'] = -1;
      }
        Map result = {
          'songs' : songs,
          'total' : total,
          'offset' : offset,
          'limit' : limit,
        };
      return result;
    }catch(e,s){
      print("There are error:$e\n$s");
      return null;
    }
  }
}