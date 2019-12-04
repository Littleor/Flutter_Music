import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';

class Download {
// In this example we download a image and listen the downloading progress.
//  main() async {
//    var dio = Dio();
//    dio.interceptors.add(LogInterceptor());
//    var url =
//        "https://cdn.jsdelivr.net/gh/flutterchina/flutter-in-action@1.0/docs/imgs/book.jpg";
//    await download1(dio, url, "./example/book.jpg");
//    await download1(dio, url, (Headers headers) => "./example/book1.jpg");
//    await download2(dio, url, "./example/book2.jpg");
//  }
  CancelToken cancelToken = CancelToken();
  int progress = 0;
  Dio dio;
  Download(){
    dio = new Dio();
  }
  Future<void> download( String url, savePath,String name,[String fileType]) async {
    Directory path = new Directory(savePath);
    Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    // 申请结果
    PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
    if (permission == PermissionStatus.granted) {
      if( !path.existsSync()){
        path.create(recursive: true);
      }
      try {

        await dio.download(url,(fileType == null) ? savePath+name+url.substring(url.lastIndexOf(".")) : savePath + name + '.' + fileType,
            onReceiveProgress: showDownloadProgress, cancelToken: cancelToken);
      } catch (e) {
        print(e);
      }
    }
    else {
      print("Permission error");
    }
  }

//Another way to downloading small file
  Future download2(Dio dio, String url, String savePath,String name) async {
    var file = new File(savePath);
    if(!file.existsSync()){
      await file.create();
    }
    try {
      Response response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
        ),
      );
      print(response.headers);
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
    } catch (e) {
      print(e);
    }
  }

  void showDownloadProgress(int count, int total) {
    this.progress = (count*100) ~/ total;
  }
}
