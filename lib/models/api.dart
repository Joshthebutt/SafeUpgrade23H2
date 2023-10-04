/*

 */

// import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/constants.dart';


class Api {
  static const _url = 'schrockinnovations.com';
  static const _url2 = '/wp-json/api/v1/';
  // Settings _settings;

  get url => _url;

  Future checkAvailability(String os) async {

    var response  =  await  http
        .get(Uri.https(_url, '${_url2}checkingAvailabilitySafeUpgradeTest', { 'version' : os }));

    // var respose = {
    //   statusCode: 200,
    //   body: {
    //     "w10": {
    //       "canDoUpdate": true,
    //       "updateName": "Schrock Safe Upgrade for the Windows 10 22H2 Update",
    //       "releaseDate": "(Oct 2022)",
    //       "zipUrl32": "https://safeupgrade.s3.us-east-2.amazonaws.com/sisafeupgrade/Windows32.zip",
    //       "zip32Hash": "D63BBAB24103A9E1B334CB512E2C0D2708839262",
    //       "zipUrl64": "https://safeupgrade.s3.us-east-2.amazonaws.com/sisafeupgrade/Windows64.zip",
    //       "zip64Hash": "74f8aa70188043f50689b8b29f89f56f97e9c952",
    //       "clientVersion": "1.9.0.0",
    //       "clientUrl": "https://www.schrockinnovations.com/downloads/safeupgrade.exe",
    //       "targetOSVersion": "19045",
    //       "MinimumOsVersion": "10000",
    //       "neededSpace64": "4.3",
    //       "neededSpace32": "3.1"
    //     },
    //     "w11": {
    //       "canDoUpdate": true,
    //       "updateName": "Schrock Safe Upgrade for the Windows 11 22H2 Update",
    //       "releaseDate": "(Oct 2022)",
    //       "zipUrl32": "https://safeupgrade.s3.us-east-2.amazonaws.com/Windows11.zip",
    //       "zip32Hash": "FE1F79D26A5B6800DF8401B7E1EA33371ADA73E3",
    //       "zipUrl64": "https://safeupgrade.s3.us-east-2.amazonaws.com/Windows11.zip",
    //       "zip64Hash": "FE1F79D26A5B6800DF8401B7E1EA33371ADA73E3",
    //       "clientVersion": "1.3.0.0",
    //       "clientUrl": "https://www.schrockinnovations.com/downloads/safeupgrade.exe",
    //       "targetOSVersion": "10.0.22621.0",
    //       "MinimumOsVersion": "10.0.10240.0",
    //       "neededSpace64": "4.3",
    //       "neededSpace32": "3.1"
    //     }
    //   },
    // };

    if (response.statusCode == 200) {
      return {
        'success' :  true,
        'data'    :  jsonDecode(response.body) as Map<String, dynamic>,
      };
    }else {
      return {
        'success' :  false,
        'msg'     :  "Something is wrong fetching settings info",
      };
    }
  }

  Future login(String username, String password) async {
    String credentials = "$username:$password";
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(credentials);
    var response  =  await  http
        .post(Uri.https(_url, '${_url2}login2'),
              body:{
               'si':encoded,
              },
              headers: {
                'si':encoded,
                'x-api-key' : superTopSecretKey,
              }
    );
    if (response.statusCode == 200) {
      var x   = jsonDecode(response.body) as Map<String, dynamic>;

      print("A");
      print(x);
      if(x['success']){
        return {
          'success'   :   true,
          'token'     :   x['token'],
          'firstName' :   x['userData']['firstName'],
          'lastName' :    x['userData']['lastName'],
        };
      }else{
        return {
          'success' :  false,
          'msg'     :  x['msg'],
        };
      }
    }else {
      return {
        'success' :  false,
        'msg'     :  "Something is wrong fetching settings info",
      };
    }
  }

  Future getLicense(String token, String deviceId) async {
    var _isReinstalling  = false;
    var response  =  await  http
        .get(Uri.https(_url, '${_url2}getLicense2', {
          'wk' : deviceId
        }),
        headers: {
          'x-api-key' : token,
        });
    if (response.statusCode == 200) {
      var x   = jsonDecode(response.body) as Map<String, dynamic>;


      if(x['isReinstalling'] != null){
        _isReinstalling = x['isReinstalling'];
      }


      if(x['success']){

        return {
          'success' :  true,
          'data'    :  x['availableLicenses'],
          'reinstalling' :  _isReinstalling,
        };
      }else{
        return {
          'success' :  false,
          'msg'     :  x['msg'],
          'data'    :  x['availableLicenses'],
          'reinstalling' :  _isReinstalling,
        };
      }
    }else {
      return {
        'success' :  false,
        'msg'     :  "Something is wrong fetching settings info",
        'data'    :  0,
        'reinstalling' :  _isReinstalling,
      };
    }
  }

  Future burnLicense(String token, String deviceId) async{
    var response  =  await  http
        .post(Uri.https(_url, '${_url2}burnLicense'),
        body:{
          'wk' : deviceId
        },
        headers: {
          'x-api-key' : token,
        });
    print(response);
    if (response.statusCode == 200) {
      var x   = jsonDecode(response.body) as Map<String, dynamic>;
      if(x['success']){
        return {
          'success' :  true,
        };
      }else{
        return {
          'success' :  false,
          'msg' :  x['msg'],
        };
      }
    }else {
      return {
        'success' :  false,
        'msg' :  'We could not connect',
      };
    }
  }

  Future notifySuccessfulInstallation() async{

  }

}
