/*
 *  Created by Alfonso Leon on 10/13/22, 1:01 PM
 *    alfonso@popdigitaldesign.com/aleon@schrockinteractive.com
 *     Last modified 10/13/22, 1:01 PM
 *     Copyright (c) 2022.
 *     All rights reserved.
 */

import 'package:process_run/shell.dart';

class DownloadExecuteInstaller{

  Future executefile(String filePath,String fileName) async {
    try{
      var dir = filePath+fileName;
      var shell = Shell();
      var x = await shell.run('start $dir');
      return x;
    }catch (e) {
      return false;
    }
  }
}
