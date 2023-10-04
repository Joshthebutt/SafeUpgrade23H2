/*
 *  Created by Alfonso Leon on 10/17/22, 12:25 PM
 *    alfonso@popdigitaldesign.com/aleon@schrockinteractive.com
 *     Last modified 10/17/22, 12:25 PM
 *     Copyright (c) 2022.
 *     All rights reserved.
 */

import 'package:flutter/material.dart';
import '../models/constants.dart';

class BoxDecorationSchrockLogo extends StatelessWidget {
  final int _screenSize;

  BoxDecorationSchrockLogo(this._screenSize);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(0.0),
      padding: const EdgeInsets.all(0.0),
      width: (_screenSize - 434).toDouble(),
      // mainAxisSize: MainAxisSize.max,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(safeUpgradeImage),
        ),
      ),
    );
  }
}