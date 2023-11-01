/*
 *  Created by Alfonso Leon on 10/12/22, 9:15 AM
 *    alfonso@popdigitaldesign.com/aleon@schrockinteractive.com
 *     Last modified 5/13/20, 9:30 AM
 *     Copyright (c) 2022.
 *     All rights reserved.
 */

import 'dart:async';
import 'dart:ffi';
import 'dart:typed_data';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../constants.dart';

import 'package:dio/dio.dart';


enum DownloadStatus { NotStarted, Started, Downloading, Completed }

// class FileDownloaderProvider with ChangeNotifier {
class FileDownloaderProvider {
  late StreamSubscription _downloadSubscription;
  DownloadStatus _downloadStatus = DownloadStatus.NotStarted;
  int _downloadPercentage = 0;
  String _downloadedFile = "";


  int get downloadPercentage => _downloadPercentage;
  DownloadStatus get downloadStatus => _downloadStatus;
  String get downloadedFile => _downloadedFile;

  Future downloadFile(String url, String filename, progressPercentage) async {
    // bool _permissionReady = await _checkPermission();
    bool _permissionReady = true;
    final Completer completer = Completer();

    if (!_permissionReady) {
      // _checkPermission().then((hasGranted) {
      //   _permissionReady = hasGranted;
      // });
    } else {
      var httpClient = http.Client();
      var request = await http.Request('GET', Uri.parse(url+filename));
      var response = httpClient.send(request);

      String dir = Platform.isAndroid
          ? '/sdcard/download'
          : (await getTemporaryDirectory()).path;
      dir   = dir+'\\'+safeUpgradeFolder;
      bool directoryExist = await Directory(dir).exists();
      if(!directoryExist){
        Directory(dir).create(recursive: true);
      }
      List<List<int>> chunks =  [];
      dynamic downloaded = 0;

      updateDownloadStatus(DownloadStatus.Started);

      _downloadSubscription =
          response.asStream().listen((http.StreamedResponse r) {
        updateDownloadStatus(DownloadStatus.Downloading);

        r.stream.listen((List<int> chunk) async {

          chunks.add(chunk);
          downloaded += chunk.length;
          print(downloaded);
          print(r.contentLength);
          if(r.contentLength  ==  null){
            _downloadPercentage = 1;
          }else{
            _downloadPercentage = (downloaded / r.contentLength * 100).round();
            progressPercentage(_downloadPercentage);
          }

          // notifyListeners();
        },

            onDone: () async {
            // Display percentage of completion
              if(r.contentLength  ==  null){
                _downloadPercentage = 1;
              }else{
                _downloadPercentage = (downloaded / r.contentLength * 100).round();
              }
            // _downloadPercentage = (downloaded / r.contentLength * 100).round();
            // notifyListeners();
            print('downloadPercentage onDone: $_downloadPercentage');

            // Save the file
            File file =  File('$dir/$filename');

            _downloadedFile = '$dir/$filename';
            print(_downloadedFile);

            if(r.contentLength  !=  null){
              var x   = r.contentLength;
              x ??= 1;
              Uint8List? bytes = Uint8List(x);
              int offset = 0;
              for (List<int> chunk in chunks) {
                bytes.setRange(offset, offset + chunk.length, chunk);
                offset += chunk.length;
              }
              await file.writeAsBytes(bytes);
            }

            updateDownloadStatus(DownloadStatus.Completed);
            _downloadSubscription?.cancel();
            _downloadPercentage = 0;

            // notifyListeners();
            print('DownloadFile: Completed');
            completer.complete(_downloadedFile);
            return ;
          });
      });
    }
    return await completer.future;
  }

  void updateDownloadStatus(DownloadStatus status) {
    _downloadStatus = status;
    print('updateDownloadStatus: $status');
    // notifyListeners();
  }

  Future<String> getSafeUpgradeFolder() async{
    String dir = Platform.isAndroid
        ? '/sdcard/download'
        : (await getTemporaryDirectory()).path;
    return  (dir+'\\'+safeUpgradeFolder).toString();
  }

  void deleteSafeUpgradeFolder(String path){
    (Directory(path)).deleteSync(recursive: true);
  }

  Future<bool> checkDirectoryExist(path) async{
    return await Directory(path).exists();
  }



  Future<String> downloadFile1( progressPercentage ) async {


    Dio dio = Dio();
    try {

      String dir = Platform.isAndroid
          ? '/sdcard/download'
          : (await getTemporaryDirectory()).path;
      dir   = '$dir\\$safeUpgradeFolder';
      bool directoryExist = await Directory(dir).exists();
      if(!directoryExist){
        Directory(dir).create(recursive: true);
      }

      var path = '$dir\\windows64.zip';

      await dio.download('https://safeupgrade.s3.us-east-2.amazonaws.com/windows64.zip',
          path,
          onReceiveProgress: (rec, total) {
            progressPercentage(((rec / total) * 100).round());
      });
      return path;
    } catch (e) {
      print(e);
      progressPercentage(0);
      return "false";
    }
    // setState(() {
    //   downloading = false;
    //   progressString = "";
    // });
  }

}
