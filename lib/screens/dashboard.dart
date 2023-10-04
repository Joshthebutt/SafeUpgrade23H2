/*
 *  Created by Alfonso Leon on 10/6/22, 4:20 PM
 *    alfonso@popdigitaldesign.com/aleon@schrockinteractive.com
 *     Last modified 10/6/22, 4:20 PM
 *     Copyright (c) 2022.
 *     All rights reserved.
 */

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

import '../models/settings.dart';
import '../models/api.dart';
import 'dashboard/agreementDialog.dart' as fullDialog;
import 'dashboard/dashboardLayout.dart' as dashboarLayout;

class Dashboard extends StatefulWidget{

  Settings _settings;
  Dashboard(this._settings, {super.key});




  Settings get settings => _settings;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  late bool  _licenseAvailable  = false;
  bool _hasAgree                = false;

  fetchAvailableLicenses(){
    final api =  Api();
    var x   =      api.getLicense(widget.settings.token, widget.settings.machine['deviceId']);
    x.then((response){
      setState(){
        _licenseAvailable = response['success'];
      }
    });
  }

  void updateHasAgreeT(currentStatus, newStatus){
    setState(() {
      _hasAgree = newStatus;
    });
  }
  final buttonColors = WindowButtonColors(
      iconNormal: Colors.blueGrey,
      mouseOver: Colors.blueGrey,
      mouseDown: Colors.black12,
      iconMouseOver: Colors.black,
      iconMouseDown: Colors.black);
  /* *******************************
  ***    BUILD   **************
  **********************************/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:  Text('Welcombe Back '+widget.settings.firstName),
          flexibleSpace: Container(child: MoveWindow()),
          actions: [
            MinimizeWindowButton(colors: buttonColors),
            CloseWindowButton(colors:buttonColors),
          ]
      ),
      body: _hasAgree ?
          dashboarLayout.DashboardLayout(widget.settings)
          :
          fullDialog.CreateAgreement( widget.settings,
                                      _hasAgree,
                                      updateHasAgreeT)
    );
  }




}