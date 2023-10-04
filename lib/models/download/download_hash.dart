/*
 *  Created by Alfonso Leon on 10/12/22, 3:56 PM
 *    alfonso@popdigitaldesign.com/aleon@schrockinteractive.com
 *     Last modified 10/12/22, 3:56 PM
 *     Copyright (c) 2022.
 *     All rights reserved.
 */
import 'dart:io';
import 'package:async/async.dart';
import 'package:crypto/crypto.dart';
import 'package:convert/convert.dart';
class DownloadHash{
  Future<Digest> getFileSha1(String path) async {
    final reader = ChunkedStreamReader(File(path).openRead());
    const chunkSize = 4096;
    var output = AccumulatorSink<Digest>();
    var input = sha1.startChunkedConversion(output);

    try {
      while (true) {
        final chunk = await reader.readChunk(chunkSize);
        if (chunk.isEmpty) {
          // indicate end of file
          break;
        }
        input.add(chunk);
      }
    } finally {
      // We always cancel the ChunkedStreamReader,
      // this ensures the underlying stream is cancelled.
      reader.cancel();
    }
    input.close();
    return output.events.single;
  }
}