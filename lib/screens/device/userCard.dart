/*
 *  Created by Alfonso Leon on 10/17/22, 4:22 PM
 *    alfonso@popdigitaldesign.com/aleon@schrockinteractive.com
 *     Last modified 10/17/22, 4:22 PM
 *     Copyright (c) 2022.
 *     All rights reserved.
 */

import 'package:flutter/material.dart';
import '../../models/settings.dart';
import '../../widgets/titleWid.dart';
import '../../widgets/subTitleWid.dart';
import 'package:url_launcher/url_launcher.dart';

class UserCard extends StatefulWidget {
  Settings _settings;

  UserCard(this._settings);

  Settings get settings => _settings;

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 4,
            child: Container(
              child: Padding(
                padding: EdgeInsets.fromLTRB(5, 5, 10, 5),
                child: Card(
                  borderOnForeground: true,
                  elevation: 3,
                  child: Row(children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        children:  [
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                            child: Text( widget.settings.licenseAvailable.toString(),
                                style: const TextStyle(
                                    fontSize: 100,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Text("available \n licenses"),
                        ],
                      ),
                    ),
                    VerticalDivider(),
                    Expanded(
                        flex: 6,
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                          child: SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TitleWid("User Information"),
                                SubTitleWid("${widget.settings.firstName} ${widget.settings.lastName}"),
                                SubTitleWid("${widget.settings.username}"),



                                Divider(),
                                TitleWid("Support"),
                                ElevatedButton(
                                    onPressed: (){launchUrl(Uri.parse("https://schrockinnovations.com/product/schrock-safe-upgrade-windows-11-23h2-fall-update/"));},
                                    child: const Text('Buy License'),
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.blue,
                                      backgroundColor: Colors.white,
                                      textStyle: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    )
                                ),
                              ],
                            ),
                          ),
                        ))
                  ]),
                ),
              ),
            )),
      ],
    );
  }
}
