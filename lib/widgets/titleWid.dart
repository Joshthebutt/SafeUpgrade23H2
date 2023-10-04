/*
 *  Created by Alfonso Leon on 10/17/22, 4:40 PM
 *    alfonso@popdigitaldesign.com/aleon@schrockinteractive.com
 *     Last modified 10/17/22, 4:40 PM
 *     Copyright (c) 2022.
 *     All rights reserved.
 */

import 'package:flutter/material.dart';

class TitleWid extends StatelessWidget{

  final String _value;

  TitleWid(this._value);

  String get value => _value;

  Widget titleWidget() {
    return Text(
      value,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        fontStyle: FontStyle.italic,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return titleWidget();
  }
}