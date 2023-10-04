/*
 *  Created by Alfonso Leon on 10/14/22, 3:40 PM
 *    alfonso@popdigitaldesign.com/aleon@schrockinteractive.com
 *     Last modified 10/14/22, 3:40 PM
 *     Copyright (c) 2022.
 *     All rights reserved.
 */
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
class LottieAndMessage extends StatelessWidget {

  late String _message;
  late String _jsonValue;

  LottieAndMessage(this._message, this._jsonValue);


  String get message => _message;
  String get jsonValue => _jsonValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child:  Stack(
              fit: StackFit.expand,
              children:   <Widget>[
                Container(
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage('https://cdn.schrockinnovations.com/wp-content/uploads/2022/10/14141647/safeupgradeOpacity80.jpg'),
                    ),
                  ),
                ),
                Container(
                  child: Center(
                    child: Lottie.asset(jsonValue),
                  ),
                ),
              ]),
        ),
        Expanded(
          child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children:   [
                  Padding(
                    padding:  EdgeInsets.all(70.0),
                    child:    Image.asset('assets/images/schrockInnovationsLogo.png'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                          message,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                      ),
                    ),
                  ),
                ],
              )),
        )
      ],
    );
  }


}