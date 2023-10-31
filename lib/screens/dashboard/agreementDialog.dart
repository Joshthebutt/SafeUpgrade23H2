/*
 *  Created by Alfonso Leon on 10/10/22, 3:57 PM
 *    alfonso@popdigitaldesign.com/aleon@schrockinteractive.com
 *     Last modified 10/10/22, 3:57 PM
 *     Copyright (c) 2022.
 *     All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:safe_upgrade/main.dart';
import '../../models/settings.dart';
import '../../widgets/boxDecorationSchrockLogo.dart';

class CreateAgreement extends StatelessWidget {
  Settings _settings;
  bool _hasAgree;
  Function _agreeOrNot;

  CreateAgreement(this._settings, this._hasAgree, this._agreeOrNot);

  String textPdf() {
    return "This program is designed safely install the Windows 11 "
        "23H2  on your PC. "
        "\n\n"
        "You are entitled to a 30-day warranty on the work this program completes.  If your upgrade fails "
        "to install or your computer experiences  issues, please contact one of our Service Centers. "
        "\n\n"
        "By using this software you are exempting Schrock Innovations from "
        "any liability in excess of the cost paid to obtain this software.  Always back up your data. ";
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return SafeArea(
          child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: <Widget>[
              Expanded(
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: BoxDecorationSchrockLogo(screenSize.width.round()),
                      ),
                      Expanded(
                          child:
                          Padding(
                            padding: const EdgeInsets.all(25),
                            child: Text(
                              textPdf(),
                              style: (TextStyle(color: Colors.black87, fontSize: 16)),
                            ),
                          )
                      )
                    ],
                  ),
              ),
              Container(
                color: Color.fromRGBO(238, 238, 238, 1.0),
                padding: EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    ElevatedButton(
                        child: const Text('CANCEL'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.blue,
                          backgroundColor: Colors.white,
                          textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          print(_hasAgree);
                          _agreeOrNot(_hasAgree, false);
                          Navigator.of(context).pop();
                          Navigator.push(context, MaterialPageRoute(builder: (_)=> MyHomePage()));
                        }
                    ),
                     ElevatedButton(
                      child:  Text('ACCEPT'),
                      style:  ElevatedButton.styleFrom(
                        foregroundColor: Colors.blue,
                        backgroundColor: Colors.white,
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        _agreeOrNot(_hasAgree, true);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
    ));
  }
}
