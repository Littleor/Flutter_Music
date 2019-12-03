import 'package:http/http.dart' as http;
import 'dart:convert';


class Url{
  static Future<Map> get(int id) async{
    String url = 'http://netease.sixming.com/api.php?order=geturl&&id=$id';
    try{
      var response = await http.get(url);
      Map data = jsonDecode(response.body);
      data = data['data'][0];
      return data;
    }catch(e,s){
      print("There are error:$e\n$s");
      return null;
    }
  }
}