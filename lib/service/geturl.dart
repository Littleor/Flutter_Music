import 'package:dio/dio.dart';
import 'dart:convert';


class Url{
  static Future<Map> get(int id) async{
    Dio dio = new Dio();
    String url = 'http://netease.sixming.com/api.php?order=geturl&&id=$id';
    try{
      Map data =  jsonDecode((await dio.get(url)).data);
      data = data['data'][0];
      return data;
    }catch(e,s){
      print("There are error:$e\n$s");
      return null;
    }
  }
}