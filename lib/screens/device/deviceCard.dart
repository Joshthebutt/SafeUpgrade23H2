/*
 *  Created by Alfonso Leon on 10/17/22, 2:26 PM
 *    alfonso@popdigitaldesign.com/aleon@schrockinteractive.com
 *     Last modified 10/17/22, 2:26 PM
 *     Copyright (c) 2022.
 *     All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:safe_upgrade/widgets/hardDriveInfo.dart';
import 'package:universal_disk_space/universal_disk_space.dart';
import '../../models/settings.dart';
import '../../models/constants.dart';

import '../../widgets/titleWid.dart';
import '../../widgets/subTitleWid.dart';


class DeviceCard extends StatefulWidget {
  Settings _settings;

  DeviceCard(this._settings);

  @override
  State<DeviceCard> createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> {
  final diskSpace = DiskSpace();
  late int _totalSpace  = 500;
  late int _freeSpace   = 1;
  late String _driveHealth = "";

  Settings get settings => widget._settings;
  int get freeSpace => _freeSpace;
  int get totalSpace => _totalSpace; // Scan for disks in the system.
  String get driveHealth => _driveHealth; //scans the health of the drive.

  @override
  initState() {
    getMainDriveAvailableSpace();
  }

  Future scanForDisk() async {
    await diskSpace.scan();
    return diskSpace.disks; // A list of disks in the system.
  }
  Future<int> getMainDriveAvailableSpace() async {
    print("getMainDriveAvailableSpace");
    var disks = await scanForDisk();
    for (final disk in disks) {
      if (disk.devicePath == "C:") {

        var x = ((disk.availableSpace / 1073741824).floor());
        setState(() {
          widget._settings.freeSpace = x.toDouble();
          // widget._settings.freeSpace(double.parse(x));
          _freeSpace = x;
          _totalSpace = ((disk.totalSize / 1073741824).floor());
        });
        return x;
      }
    }
    return 1;
  }
  Future<String> getMainDriveHealth() async {
    widget._settings.driveHealth = await driveHealthGetter().health(0);

    _driveHealth = await driveHealthGetter().health(0);

    return _driveHealth;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 4,
            child: Container(
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
                child: Card(
                  borderOnForeground: true,
                  elevation: 3,
                  child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            width: double.infinity,
                            // mainAxisSize: MainAxisSize.max,
                            alignment: Alignment.center,
                            decoration:  const BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(safeUpgradeImage),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 4,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                              child: SizedBox(
                                width: double.infinity,
                                height: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TitleWid("OS Information"),
                                    SubTitleWid('Computer Name: ${settings.machine['computerName']}'),
                                    SubTitleWid('Current OS: ${settings.machine['productName']}'),
                                    SubTitleWid(
                                        'Current Build: ${settings.machine['displayVersion']} (${settings.machine['buildNumber']})'
                                    ),
                                    const Divider(),
                                    TitleWid("Hard Drive Info"),
                                    SubTitleWid("C drive total space: $_totalSpace GB"),
                                    SubTitleWid("C drive free space: $_freeSpace GB"),
                                    (settings.neededSpace>=freeSpace) ?
                                    SubTitleWid("Min. available needed : ${settings.neededSpace} GB", Colors.red)
                                        :
                                    SubTitleWid("Min. available needed : ${settings.neededSpace} GB"),
                                    FutureBuilder(future: getMainDriveHealth(),
                                      builder:(context, snapshot) {
                                        Widget healthpresenter = SizedBox(height: 10,width: 10,child: CircularProgressIndicator());
                                        String health = "";
                                        if(snapshot.hasData){health = snapshot.data.toString();
                                        if(health == "100%"){healthpresenter =SubTitleWid("C Drive Health: "+health);
                                        _driveHealth = health;
                                        }
                                        else{healthpresenter =SubTitleWid("C Drive Health: "+health,Colors.red);}
                                        }
                                        return healthpresenter;
                                      },
                                    )
                                  ],
                                ),
                              ),
                            )
                        )
                      ]
                  ),
                ),
              ),
            )
        ),
      ],
    );
  }
}