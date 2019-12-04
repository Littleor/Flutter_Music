import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';

class Download {
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
  void showDownloadProgress(int count, int total) {
    this.progress = (count*100) ~/ total;
  }
}
