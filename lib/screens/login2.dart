// ignore_for_file: slash_for_doc_comments

/*
 *  Created by Alfonso Leon on 10/5/22, 11:15 AM
 *    alfonso@popdigitaldesign.com/aleon@schrockinteractive.com
 *     Last modified 10/5/22, 11:15 AM
 *     Copyright (c) 2022.
 *     All rights reserved.
 */
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

import '../models/settings.dart';
import '../models/constants.dart';
import '../models/api.dart';
import './dashboard.dart';
import '../widgets/boxDecorationSchrockLogo.dart';

class Login2 extends StatelessWidget {

  Settings _setting;
  Function _successfullLogin;



  Login2(this._setting, this._successfullLogin);


  /********************************
  ***    GETTERS   **************
  ********************************* */
  Duration get loginTime => const Duration(milliseconds: 2250);

  Settings get setting => _setting;

  /********************************
  ***    FUNCTIONS   **************
  ********************************* */
    // Future<String?> _authUser(LoginData data) {
    Future<String?> _authUser(LoginData data) async {
      Api _api  = Api();
      return  await _api.login(data.name, data.password).then((response){
        if(response['success']){
            _successfullLogin(  data.name,
                                data.password,
                                response['token'],
                                response['firstName'],
                                response['lastName'] );


          return null;
        }else{
          return response['msg'];
        }
      });
    }

    Future<String?> _signupUser(SignupData data) {
      debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
      return Future.delayed(loginTime).then((_) {
        return null;
      });
    }

    Future<String> _recoverPassword(String name) {
      debugPrint('Name: $name');
      return Future.delayed(loginTime).then((_) {
        if (!users.containsKey(name)) {
          return 'User not exists';
        }
        return 'null';
      });
    }

    String? validatePassword(pass){
      if(pass==''){
        return "Password is empty";
      }
      return null;
    }

  /* *******************************
  ***    WIDGETS - CUSTOM   ********
  ********************************* */




  /* *******************************
  ***    BUILD   **************
  **********************************/

    @override
    Widget build(BuildContext context) {
      final screenSize = MediaQuery.of(context).size;

      return Scaffold(
        body: Container(
          color: Colors.white,
          child: Row(

            children: [
              BoxDecorationSchrockLogo(screenSize.width.round()),
              Container(
                color: Colors.white,
                margin:  const EdgeInsets.all(0.0),
                padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
                width: 400,
                child: Stack(
                  children: [
                    FlutterLogin(
                      // title: 'ECORP',
                      logo: const AssetImage('assets/images/schrockInnovationsLogo.png' ),
                      onLogin: _authUser,
                      onSignup: _signupUser,
                      onSubmitAnimationCompleted: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => Dashboard(_setting),
                        ));


                      },
                      passwordValidator: validatePassword,
                      onRecoverPassword: _recoverPassword,
                      navigateBackAfterRecovery: true,
                      scrollable: false,
                      savedEmail:'',
                      savedPassword:'',

                      messages: LoginMessages(
                          userHint: "Email/Username",
                      ),
                      theme: LoginTheme(
                        primaryColor:   Colors.white,
                        accentColor:    Colors.blue,
                        errorColor:     Colors.red,
                        // titleStyle: TextStyle(
                        //   color: Colors.greenAccent,
                        //   fontFamily: 'Quicksand',
                        //   letterSpacing: 4,
                        // ),
                        // bodyStyle: TextStyle(
                          // fontStyle: FontStyle.italic,
                          // decoration: TextDecoration.underline,
                        // ),
                        textFieldStyle:
                          const TextStyle(
                            color: Colors.black,
                            shadows: [Shadow(color: Colors.grey, )],
                          ),
                        buttonStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                        ) ,
                        cardTheme:  CardTheme(
                          // color: Colors.yellow.shade100,
                          elevation: 4,
                          margin: const EdgeInsets.only(top: 15),
                          shape:  ContinuousRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                        ),
                      )
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
}