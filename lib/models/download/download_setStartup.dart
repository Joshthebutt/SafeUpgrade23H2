/*
 *  Created by Alfonso Leon on 10/13/22, 4:30 PM
 *    alfonso@popdigitaldesign.com/aleon@schrockinteractive.com
 *     Last modified 10/13/22, 4:30 PM
 *     Copyright (c) 2022.
 *     All rights reserved.
 */
import 'dart:io';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:package_info_plus/package_info_plus.dart';
class DownloadSetStartup{
  late  bool _isEnabled;
  late PackageInfo packageInfo;
  late LaunchAtStartup xxxx = launchAtStartup;

  DownloadSetStartup (isEnabled) {
    _isEnabled  = isEnabled;
  }


  bool get isEnabled => _isEnabled;

  setData() async{
    packageInfo = await PackageInfo.fromPlatform();
    return xxxx.setup(
      appName: packageInfo.appName,
      appPath: Platform.resolvedExecutable,
    );

  }

  init() async {
     _isEnabled = await xxxx.isEnabled();
     return _isEnabled;
  }

  handleEnable() async {
    await xxxx.enable();
    return await init();
  }

  handleDisable() async {
    await xxxx.disable();
    return await init();
  }

}