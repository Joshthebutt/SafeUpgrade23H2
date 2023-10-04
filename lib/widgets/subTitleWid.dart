/*
 *  Created by Alfonso Leon on 10/17/22, 4:45 PM
 *    alfonso@popdigitaldesign.com/aleon@schrockinteractive.com
 *     Last modified 10/17/22, 4:45 PM
 *     Copyright (c) 2022.
 *     All rights reserved.
 */

import 'package:flutter/material.dart';

class SubTitleWid extends StatelessWidget{
  final String _value;
  final Color _color;


  SubTitleWid(this._value, [this._color = Colors.black87]  );

  String get value => _value;
  Color get color => _color;

  Widget subTitleWidget() {
    return Padding(
      padding: EdgeInsets.fromLTRB( 10.0, 0, 0, 0),
      child: Text(
        value,
        style:  TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 14,
          height: 1.5,
          color: color
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return subTitleWidget();
  }

}