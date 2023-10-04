/*
 *  Created by Alfonso Leon on 10/24/22, 3:07 PM
 *    alfonso@popdigitaldesign.com/aleon@schrockinteractive.com
 *     Last modified 10/24/22, 3:07 PM
 *     Copyright (c) 2022.
 *     All rights reserved.
 */

import 'dart:io';
import 'package:process_run/shell.dart';


class DriveAdviser{
   static const String _executablePath = '"" "C://Program Files (x86)//Drive Adviser//Drive Adviser.exe"';
   static const String _realPath = 'C://Program Files (x86)//Drive Adviser//Drive Adviser.exe';

   DriveAdviser();


   Future<bool> checkIfExists(String path) async{
      print(path);
      return await File(path).exists();
   }

   Future executeFile(String path, {String params = ''})  async {
      try{
         var shell = Shell();
         var x = await shell.run('start $path $params');
         return x;
      }catch (e) {
         return false;
      }
   }

}