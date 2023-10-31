/*
 *  Created by Alfonso Leon on 10/11/22, 3:02 PM
 *    alfonso@popdigitaldesign.com/aleon@schrockinteractive.com
 *     Last modified 10/11/22, 3:02 PM
 *     Copyright (c) 2022.
 *     All rights reserved.
 */

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:process_run/process_run.dart';
import 'package:safe_upgrade/widgets/hardDriveInfo.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/settings.dart';
import '../../models/api.dart';
import '../../models/download/download_provider.dart';
import '../../models/download/download_hash.dart';
import '../../models/download/download_extractFile.dart';
import '../../models/download/download_executeInstaller.dart';
import '../../models/download/download_setStartup.dart';
import '../../models/constants.dart';
import '../../screens/device/deviceCard.dart';
import '../../screens/device/userCard.dart';
import '../../widgets/statusBarWid.dart';
import '../../screens/programs/program.dart';



class DashboardLayout extends StatefulWidget {
  Settings _settings;

  DashboardLayout(this._settings, {super.key});

  Settings get settings => _settings;

  @override
  State<DashboardLayout> createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends State<DashboardLayout> {
  bool _isDownloading = false;
  int _downloadPercentage = 0;
  String _zipFilePath = "";
  int _hashResult = 0; // 0 - Validating, 1 - Wrong, 2 - Good
  String _driveHealth = "";
  String get zipFilePath => _zipFilePath;
  // late bool _hasDA = false;
  // late bool _hasSophos = false;

  @override
  initState() {
    getLicensesAvailable();


    // todo remove here
    // checkForSophosAndDa();
  }

  // checkForSophosAndDa() {
  //   DriveAdviser da = DriveAdviser();
  //   da.checkIfExists(da_realPath).then((value) {
  //     if (value) {
  //       _hasDA = value;
  //     }
  //   });
  //   da.checkIfExists(sophos_realPath).then((value) {
  //     if (value) {
  //       _hasSophos = value;
  //     }
  //   });
  // }

  progressPercentage(value) {
    setState(() {
      _downloadPercentage = value;
    });
  }

  launchURL(url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  downloadFile(String url, String file){
    var progress  = 1;
    var x = FileDownloaderProvider();
    print(url);
    print(file);
    return x.downloadFile(url,
        file,
        progress)
        .then((fileWhereDownloaded) {
      print(fileWhereDownloaded);
      installFile(fileWhereDownloaded);
      return fileWhereDownloaded;

    });
  }
  installFile(String run){
var shell=Shell();
shell.run(run);
  }

  Future<String> getMainDriveHealth() async {
    widget._settings.driveHealth = await driveHealthGetter().health(0);

    _driveHealth = await driveHealthGetter().health(0);

    return _driveHealth;
  }
  Future<bool> hashValidation() {
    DownloadHash _dh = DownloadHash();
    return _dh.getFileSha1(zipFilePath).then((value) {
      print(value);
      if ((value.toString()).toUpperCase() ==
          (widget._settings.zipHash).toUpperCase()) {
        setState(() {
          _hashResult = 2;
          extractFile();
        });
        return true;
      } else {
        setState(() {
          _hashResult = 1;
        });
        return false;
      }
    });
  }

  Future<int> getLicensesAvailable() async {
    var x = Api();
    await driveHealthGetter().health(0).then((value) {
      _driveHealth = value;
    });
    return await x
        .getLicense(
        widget._settings.token, widget._settings.machine['deviceId'])
        .then((response) {
      setState(() {
        widget._settings.licenseAvailable = response['data'];
        widget._settings.isReinstalling = response['reinstalling'];
      });
      return response['data'];
    });
  }

  Widget downloadProgress() {
    String status = "Downloading";
    if (_downloadPercentage > 99) {
      status = "Download Completed";
    } else {
      status = "Downloading .. $_downloadPercentage%";
    }
    return StatusBarWid(status, 'assets/lottie/downloading-animation.json');
  }

  Widget hashingFile() {
    final String r;
    if (_hashResult == 0) {
      r = "Validating ...";
    } else if (_hashResult == 1) {
      r = "Downloaded file is corrupt";
    } else {
      r = "File validation successful";
    }
    return StatusBarWid(r, 'assets/lottie/making-notes.json');
  }

  SnackBar SnackBarBottom(value, callback) {
    return SnackBar(
      content: Text(
        value,
        style: const TextStyle(fontSize: 20),
      ),
      action: SnackBarAction(
        label: 'close',
        textColor: Colors.white,
        onPressed: () {
          callback();
        },
      ),
    );
  }

  /*UNZIP FILE*/
  extractFile() async {
    var xx = DownloadExtractFile();
    if (zipFilePath == "") {
      return false;
    }
    var result = xx.extractFile(zipFilePath).then((response) {
      executeFile(response);
    });

    print(result);
  }

  /*  EXECUTE FILE  */
  executeFile(path) {
    var xx = DownloadExecuteInstaller();
    // xx.executefile(path, 'safeupgrade.exe').then((response) {
    xx.executefile(path, 'safeupgrade.exe').then((response) {
      if (response is List<ProcessResult>) {
        for (final e in response) {
          DownloadSetStartup x = DownloadSetStartup(false);
          // ExitCode 0 means that everything went fine and the installer
          // should be up at this point
          if (e.exitCode == 0) {
            (x.setData()).then((response) {
              x.handleEnable();
            });
          } else {
            x.handleDisable();
            print("Could not launch app - exitCode != 0");
            return false;
          }
        }
      } else {
        //means that something went wrong and we could start the windows installer
        final snackBar = SnackBarBottom("Installation aborted by user", () {});
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        _isDownloading = false;
        return false;
      }
    });
  }

  /* START DOWNLOADING PROCESS */
  startDownloadingProcess() {
    if (!widget.settings.isReinstalling) {
      Api _api = Api();
      _api
          .burnLicense(
          widget.settings.token, widget.settings.machine['deviceId'])
          .then((value) {
        widget.settings.isReinstalling = value['success'];
        widget.settings.licenseAvailable--;
      });
    }
    _zipFilePath = "";
    var x = FileDownloaderProvider();
    x
        // .downloadFile("https://schrockinnovations.com/downloads/OLD/",
        // "test.zip", progressPercentage).
        .downloadFile("https://safeupgrade.s3.us-east-2.amazonaws.com/",
        "Windows64.zip", progressPercentage)
        .then((onValue) {
      setState(() {
        _zipFilePath = onValue;
        hashValidation();
      });
    });
    setState(() {
      _isDownloading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,

              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: DeviceCard(widget._settings),
                ),
                Expanded(
                  flex: 3,
                  child: UserCard(widget._settings),
                ),
              ],
            ),
          ),
          !_isDownloading ?
          Container(
            height: 230,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0,0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Program(sophos_logo,
                        sophos_name,
                        sophos_desc,
                        sophos_realPath,
                        sophos_button,
                            (){launchURL(Uri.parse(sophos_link));}
                    ),
                  ),
                  Expanded(
                    child: Program(su_logo,
                        su_name,
                        su_desc,
                        su_realPath,
                        su_button,
                            (){launchURL(Uri.parse("https://www.secureupdater.com/download/"));}
                    ),
                  ),
                  Expanded(
                    child: Program(da_logo,
                        da_name,
                        da_desc,
                        da_realPath,
                        da_button,
                            (){
                          downloadFile(da_link['url'],da_link['file']);

                        }
                    ),
                  ),
                ],
              ),
            ),
          )
              : _downloadPercentage < 100 && _zipFilePath == "" ?
          Expanded(child: downloadProgress())
              :
          Expanded(child: hashingFile()),
          const Divider(),
          Row(children: [
            const Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child:
                  Text("@2023 - All rights reserved, Schrock Innovations "),
                )),
            const VerticalDivider(
              color: Colors.blueAccent,
            ),
            Expanded(
              child: Container(
                  decoration: const BoxDecoration(
                    // color: Colors.grey,
                  ),
                  alignment: AlignmentDirectional.bottomEnd,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          //to set border radius to button
                          borderRadius: BorderRadius.circular(5),
                        ),
                        textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () => {


                        (!widget.settings.isReinstalling)
                            ? showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Start Installation?'),
                            content: const Text(
                                'This installation takes one valid license from '
                                    'your available licenses.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, 'Cancel');
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  print(_driveHealth);
                                  /*NEED TO CHECK FOR AVAILABLE SPACE IN HARD DRIVE*/
                                  if (widget._settings.neededSpace >=
                                      widget._settings.freeSpace) {
                                    final snackBar = SnackBarBottom(
                                        "Sorry, you need an additional license",
                                            (_) {});
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  } else {
                                    if (widget.settings.licenseAvailable <
                                        1) {
                                      final snackBar = SnackBarBottom(
                                          "Sorry, you need an additional license",
                                              (_) {});
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                    else if(_driveHealth != "100%"){
                                      final snackBar = SnackBarBottom(
                                          "Sorry, your Hard drive is failing. It is not safe to Download this update without possible loosing data",
                                              (_) {});
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);}
                                    else {
                                      startDownloadingProcess();
                                    }
                                  }

                                  Navigator.pop(context, 'Continue');
                                },
                                child: const Text('Continue'),
                              ),
                            ],
                          ),
                        )
                            : startDownloadingProcess(),
                      },
                      child: const Text('Start Installation'),
                    ),
                  )),
            ),
          ]),
        ],
      ),
    );
  }
}