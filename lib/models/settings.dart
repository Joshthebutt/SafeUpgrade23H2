// ignore_for_file: invalid_required_positional_param, slash_for_doc_comments

/*
 *  Created by Alfonso Leon on 10/4/22, 4:18 PM
 *    alfonso@popdigitaldesign.com/aleon@schrockinteractive.com
 *     Last modified 10/4/22, 4:18 PM
 *     Copyright (c) 2022.
 *     All rights reserved.
 */
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';


class Settings {
  String _driveHealth;
  bool    _canDoUpdate;
  String  _updateName;
  String  _releaseDate;
  String  _zipUrl;
  String  _zipHash;


  String  _clientVersion;
  String  _clientUrl;
  String  _targetOSVersion;
  String  _minimumOsVersion;

  String  _windowsVersion;
  String  _windowsBuild;
  bool    _isWindows;

  double  _neededSpace  = 4.1;
  double _freeSpace     = 5.0;

  /*MACHINE*/
  late Map<String, dynamic> _machine =   new Map();

  /*USER*/
  String _username      = "";
  String _password      = "";
  String _token         = "";
  String _firstName     = "";
  String _lastName      = "";
  int _licenseAvailable = 0;
  bool  _isReinstalling = false;

  Settings(
    @required this._canDoUpdate,
    @required this._isWindows,
    @required this._windowsVersion,
    @required this._windowsBuild, [
    this._updateName        = "",
    this._releaseDate       = "",
    this._zipUrl          = "",
    this._zipHash         = "",


    this._clientVersion     = "",
    this._clientUrl         = "",
    this._targetOSVersion   = "",
    this._minimumOsVersion  = "",
        this._driveHealth = "",
  ]);

  /****************
   **    getters   *
   ****************/

  double get freeSpace => _freeSpace;
  bool   get isReinstalling => _isReinstalling;
  double get neededSpace => _neededSpace;
  Map    get machine =>  _machine;
  int    get licenseAvailable => _licenseAvailable;
  String get username =>  _username;
  String get password =>  _password;
  String get token    =>  _token;
  String get firstName    =>  _firstName;
  String get lastName    =>  _lastName;
  bool   get isWindows => _isWindows;
  String get windowsBuild => _windowsBuild;
  String get windowsVersion => _windowsVersion;
  String get minimumOsVersion => _minimumOsVersion;
  String get targetOSVersion => _targetOSVersion;
  String get clientUrl => _clientUrl;
  String get clientVersion => _clientVersion;
  String get zipHash => _zipHash;
  String get zipUrl => _zipUrl;
  String get releaseDate => _releaseDate;
  String get updateName => _updateName;
  bool   get canDoUpdate => _canDoUpdate;
  String get driveHealth => _driveHealth;

  /****************
  **    setters   *
  ****************/

  set driveHealth(String value){
    _driveHealth = value;
  }
  set freeSpace(double value) {
    _freeSpace = value;
  }
  set isReinstalling(bool value) {
    _isReinstalling = value;
  }
  set neededSpace(double value) {
    _neededSpace = value;
  }
  set licenseAvailable(int value) {
    _licenseAvailable = value;
  }
  set username(String value) {
    _username = value;
  }
  set password(String value) {
    _password = value;
  }
  set token(String value) {
    _token = value;
  }
  set firstName(String value) {
    _firstName = value;
  }
  set lastName(String value) {
    _lastName = value;
  }
  set isWindows(bool value) {
    _isWindows = value;
  }
  set minimumOsVersion(String value) {
    _minimumOsVersion = value;
  }
  set targetOSVersion(String value) {
    _targetOSVersion = value;
  }
  set clientUrl(String value) {
    _clientUrl = value;
  }
  set clientVersion(String value) {
    _clientVersion = value;
  }
  set zipHash(String value) {
    _zipHash = value;
  }
  set zipUrl(String value) {
    _zipUrl = value;
  }
  set releaseDate(String value) {
    _releaseDate = value;
  }
  set updateName(String value) {
    _updateName = value;
  }
  set windowsBuild(String value) {
    _windowsBuild = value;
  }
  set windowsVersion(String value) {
    _windowsVersion = value;
  }
  set canDoUpdate(bool value) {
    _canDoUpdate = value;
  }


  void setPropertiesA( Settings objeto,    response ) {
    objeto.canDoUpdate      = ( response['canDoUpdate'] );
    objeto.updateName       = ( response['updateName'] );
    objeto.releaseDate      = ( response['releaseDate'] );
    objeto.clientVersion    = ( response['clientVersion'] );
    objeto.clientUrl        = ( response['clientUrl'] );
    objeto.targetOSVersion  = ( response['targetOSVersion'] );
    objeto.minimumOsVersion = ( response['MinimumOsVersion'] );

    var xxx = getStringMiddle( "windows_x" ,   '"', Platform.version);
    if(xxx == '64'){
      objeto.zipUrl     = response['zipUrl64'];
      objeto.zipHash    = response['zip64Hash'];
      objeto.neededSpace= double.parse(response['neededSpace64']);
    }else{
      objeto.zipUrl   = response['zipUrl32'];
      objeto.zipHash  = response['zip32Hash'];
      objeto.neededSpace= double.parse(response['neededSpace32']);
    }
  }

  void setPropertiesMachine(Map response){

    _machine['computerName']  = response['computerName'];
    _machine['majorVersion']  = response['majorVersion'];
    _machine['minorVersion']  = response['minorVersion'];
    _machine['buildNumber']   = response['buildNumber'];
    _machine['displayVersion']= response['displayVersion'];
    _machine['editionId']     = response['editionId'];
    _machine['deviceId']      = response['deviceId'];
    _machine['userName']      = response['userName'];
    _machine['productName']   = response['productName'];
  }


  /****************
   **    METHODS   *
   ****************/

    getOsVersion(){
      String str =   windowsBuild;
      String start = "(Build";
      String end = ")";
      final startIndex = str.indexOf(start);
      final endIndex = str.indexOf(end, startIndex + start.length);
      return str.substring(startIndex + start.length, endIndex);
    }

    getStringMiddle(String start, String end, String value){
      final startIndex = value.indexOf(start);
      final endIndex = value.indexOf(end, startIndex + start.length);
      return value.substring(startIndex + start.length, endIndex);
    }

    Future<Map> getPropertiesMachine() async {
      final deviceInfoPlugin =  DeviceInfoPlugin();
      final deviceInfo = await deviceInfoPlugin.deviceInfo;
      return deviceInfo.toMap();
    }


}
