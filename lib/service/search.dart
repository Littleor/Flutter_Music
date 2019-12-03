import 'package:http/http.dart' as http;
import 'dart:convert';


class SearchSongs{

  static Future<Map> get({String keyword,int limit = 30,int offset = 0}) async{
    //http://netease.sixming.com/api.php?order=search&&keyword=%E7%BA%B8%E7%9F%AD%E6%83%85%E9%95%BF
    String url = 'http://netease.sixming.com/api.php?order=search&&keyword=$keyword&&offset=$offset&&limit=$limit';
    try{
      var response = await http.get(url);
      Map data = jsonDecode(response.body);
      List songs = data["result"]["songs"];
      int total = data["result"]["songCount"];

      for(Map song in songs){
        song['play'] = false;
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