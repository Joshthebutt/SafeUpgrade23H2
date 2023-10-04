/*
 *  Created by Alfonso Leon on 10/14/22, 11:47 AM
 *    alfonso@popdigitaldesign.com/aleon@schrockinteractive.com
 *     Last modified 10/14/22, 11:47 AM
 *     Copyright (c) 2022.
 *     All rights reserved.
 */
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: Center(
          child: Lottie.asset('assets/lottie/loading.json'),
          ),
        ),
        // Text("Loading..."),
     ],
    );
  }
}