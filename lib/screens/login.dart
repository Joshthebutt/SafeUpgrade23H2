import 'package:flutter/material.dart';

import '../models/api.dart';
import '../models/settings.dart';

class Login extends StatefulWidget {

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Settings? _settings;
  // void aaa(){
  //   Api api = Api();
  //   api.checkAvailability().then((response) {
  //     if (!response['success']) {
  //       setState(() {
  //         _settings = Settings(false);
  //       });
  //     } else {
  //       setState(() {
  //         _settings = Settings(
  //             response['data']['canDoUpdate'],
  //             response['data']['updateName'].toString(),
  //             response['data']['releaseDate'].toString(),
  //             response['data']['zipUrl32'].toString(),
  //             response['data']['zip32Hash'].toString(),
  //             response['data']['zipUrl64'].toString(),
  //             response['data']['zip64Hash'].toString(),
  //             response['data']['clientVersion'].toString(),
  //             response['data']['clientUrl'].toString(),
  //             response['data']['targetOSVersion'].toString(),
  //             response['data']['minimumOsVersion'].toString()
  //         );
  //       });
  //     }
  //     print('...');
  //   });
  //   print("AAAAAAAAAAAA");
  // }
  //
  // print(_settings);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Welcome to SCHROCK SAFE UPGRADE installer",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              )),
          flexibleSpace: Image(
            image: const AssetImage('assets/images/appBarBg.png'),
            fit: BoxFit.cover,
          ),
          backgroundColor: Colors.transparent,
        ),
        body:
        _settings!=null ?
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 450,
                  color: const Color.fromARGB(140, 140, 24, 1),
                ),
                Container(
                  width: 314,
                  color: const Color.fromARGB(255, 255, 255, 1),
                ),
              ],
            )
        :
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                color: Color.fromARGB(210, 210, 210, 1),
                child: Text("aaaaaaaaaaa"),
              )
            ],
          )
    );
  }
}

