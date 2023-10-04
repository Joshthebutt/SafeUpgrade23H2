/*
 *  Created by Alfonso Leon on 10/5/22, 1:19 PM
 *    alfonso@popdigitaldesign.com/aleon@schrockinteractive.com
 *     Last modified 10/5/22, 1:19 PM
 *     Copyright (c) 2022.
 *     All rights reserved.
 */

import 'package:flutter/material.dart';
import '../../models/settings.dart';
import '../../widgets/loading.dart';
import '../../widgets/fail.dart';

class FailSettings extends StatelessWidget{

  Settings _settings;

  FailSettings(this._settings);


  // Widget loading(){
  //   return const Text("Sorry, update is not ready");
  // }
  // Widget noWindows(){
  //   return const Text("Sorry, you are not running windows");
  // }
  Widget updateNoReady(){
    return  Fail("Sorry, update is not ready");
  }
  // Widget alreadyHaveUpdate(){
  //   return const Text("Yeah, you have the right version of windows");
  // }
  // Widget minimumVersion(){
  //   return const Text("Sorry, Current Version of windows is not supported");
  // }



  @override
  Widget build(BuildContext context) {

    /*LOADING*/
    if(_settings.targetOSVersion==""){
      print("a");
      print(_settings.machine);
      return const Loading();
    }

    if(!_settings.isWindows){
      return  Fail("Sorry, this installer is only available for devices running Windows 10 or "
          "Windows 11 operating system.");
    }

    if(!_settings.canDoUpdate){
      return  Fail("Micorsoft has not released the new update yet. Please, stand by "
          "that we will let you know as soon as the upgrade is available for your "
          " Microsoft Windows version");
    }

    if(_settings.machine['buildNumber'] >= _settings.targetOSVersion){
      return  Fail("a");
    }


    /*NO WINDOWS*/
    return updateNoReady();

    /* DEFAULT */
    return Fail("Sorry, update is not ready");


    /*MINIMUM VERSION */

    /*ALREADY UPDATE*/

    // if(!_settings.isWindows){
    //   return noWindows();
    // }else if (!_settings.canDoUpdate) {
    //   return updateNoReady();
    // }else if (_settings.getOsVersion() >= _settings.targetOSVersion){
    //   return alreadyHaveUpdate();
    // }else{  // Minimum version don't met
    //   return minimumVersion();
    // }
  }
}
