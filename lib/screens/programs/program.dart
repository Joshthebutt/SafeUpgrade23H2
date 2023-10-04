/*
 *  Created by Alfonso Leon on 10/24/22, 4:59 PM
 *    alfonso@popdigitaldesign.com/aleon@schrockinteractive.com
 *     Last modified 10/24/22, 4:59 PM
 *     Copyright (c) 2022.
 *     All rights reserved.
 */
import 'dart:io';
import 'package:flutter/material.dart';



class Program extends StatefulWidget {
  final String _icon;
  final String _title;
  final String _desc;
  final String _realPath;
  final String _buttonText;
  final  _callback;

  Program(this._icon,
      this._title,
      this._desc,
      this._realPath,
      this._buttonText,
      this._callback);

  @override
  State<Program> createState() => _ProgramState();


  Future get callback => _callback;
  String get buttonText => _buttonText;
  String get icon => _icon;
  String get title => _title;
  String get desc => _desc;
  String get realPath => _realPath;
}

class _ProgramState extends State<Program> {
  bool _exist = false;

  set exist(bool value) {
    _exist = value;
  }

  bool get exist => _exist;

  @override
  void initState() {
    super.initState();
    setState(() {
      checkIfExists(widget.realPath).then((response) {
        exist = response;
      });
    });
  }

  Future<bool> checkIfExists(String path) async {
    return await File(path).exists();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      borderOnForeground: true,
      elevation: 3,
      child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                ),
                color: Colors.white24,
              ),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.center,
                children: [
                  Image.network(widget.icon, width: 25),
                  Text(widget.title.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )),
                  const Divider(),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(widget.desc),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: (exist) ? null : () {widget._callback();},
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black87,
                    backgroundColor: Colors.white,
                    minimumSize: Size(280, 40),
                  ),
                  child:
                  (exist) ? Text("Already Installed") : Text(widget.buttonText),
                ),
              ),
            )
          ]),
    );
  }
}