/*
 *  Created by Alfonso Leon on 10/18/22, 1:28 PM
 *    alfonso@popdigitaldesign.com/aleon@schrockinteractive.com
 *     Last modified 10/18/22, 1:28 PM
 *     Copyright (c) 2022.
 *     All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
class StatusBarWid extends StatelessWidget{

  String _lottie;
  String _value;


  StatusBarWid( this._value, this._lottie);

  String get value => _value;
  String get lottie => _lottie;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
            flex: 1,
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: Lottie.asset(lottie),
                ),
              ),
            ),
        ),
        Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: const  TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            )
        )
      ],
    );
  }


}