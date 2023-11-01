/*
 *  Created by Alfonso Leon on 10/13/22, 11:48 AM
 *    alfonso@popdigitaldesign.com/aleon@schrockinteractive.com
 *     Last modified 10/13/22, 11:48 AM
 *     Copyright (c) 2022.
 *     All rights reserved.
 */
import 'dart:async';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class DownloadExtractFile  {

  extractFile(String zipFile) async {


    String dir = (await getTemporaryDirectory()).path;
    dir   = '$dir\\safeupgrade\\out\\';
    bool directoryExist = await Directory(dir).exists();
    if(!directoryExist){
      Directory(dir).create(recursive: true);
    }

    print(dir);


    extractFileToDisk(zipFile, dir);
    print("11111");
    return dir;

// Use an InputFileStream to access the zip file without storing it in memory.
    final inputStream = InputFileStream(zipFile);
// Decode the zip from the InputFileStream. The archive will have the contents of the
// zip, without having stored the data in memory.
    final archive1 = ZipDecoder().decodeBuffer(inputStream);
    extractArchiveToDisk(archive1, dir);

    print("11111");
    return dir;

    final bytes = File(zipFile).readAsBytesSync();

    // Decode the Zip file
    final archive = ZipDecoder().decodeBytes(bytes);

    // Extract the contents of the Zip archive to disk.
    for (final file in archive) {
      final filename = file.name;
      if (file.isFile) {
        final data = file.content as List<int>;
        // ignore: prefer_interpolation_to_compose_strings
        File(dir + filename)
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      } else {
        // ignore: prefer_interpolation_to_compose_strings
        Directory(dir + filename).create(recursive: true);
      }
    }
    return dir;

}

}