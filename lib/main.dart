import 'dart:io' show Platform, exit;
import 'dart:convert';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:auto_updater/auto_updater.dart';
import 'package:desktop_window/desktop_window.dart';

import './models/settings.dart';
import './models/api.dart';
import './models/constants.dart';
import './models/download/download_setStartup.dart';
import './models/download/download_provider.dart';
import './screens/fail/failSettings.dart';
import './screens/login2.dart';
import 'widgets/LottieAndMessage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String feedURL = 'https://schrockinnovations.com/downloads/appcast.xml';
  await autoUpdater.setFeedURL(feedURL);
  await autoUpdater.checkForUpdates(inBackground: true); //{inBackground: true}
  // await autoUpdater.setScheduledCheckInterval(3600);
  runApp(MyApp());

  doWhenWindowReady(() {
    const initialSize = Size(800, 600);
    appWindow.minSize = initialSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.show();
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Schrock Safe Upgrade',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: kBackgroundColor,
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: kPrimaryColor,
            ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Settings _settings = Settings(false, Platform.isWindows,
      Platform.operatingSystem, Platform.operatingSystemVersion);

  /********************************
  ***    FUNCTIONS   **************
  **********************************/

  @override
  void initState() {
    super.initState();
    fetchSettingsFromApi(_settings);
    var x = _settings.getPropertiesMachine();
    x.then((response) {
      _settings.setPropertiesMachine(response);
    });
  }

  void fetchSettingsFromApi(Settings setting) {
    Api _api = Api();

    String os = "w10";
    if (int.parse(_settings.getOsVersion()) >= 20000) {
      os = "w11";
    }

    _api.checkAvailability(os).then((response) {
      if (response['success']) {
        print(response);
        setState(() {
          setting.setPropertiesA(setting, response['data']);
          var x = _settings.getPropertiesMachine();
          x.then((response) {
            _settings.setPropertiesMachine(response);
          });
        });
      }
    });
  }

  void successfullLogin(String username, String password, String token,
      String firstName, String lastName) {
    setState(() {
      _settings.username = username;
      _settings.password = password;
      _settings.token = token;
      _settings.firstName = firstName;
      _settings.lastName = lastName;
    });
  }

  disableLaunchAtStartup() async {
    DownloadSetStartup xx = DownloadSetStartup(false);
    xx.setData().then((response) {
      xx.handleDisable();
    });

    /* notify installation was success*/
    Api api = Api();
    api.notifySuccessfulInstallation();

    /* remove files in temp */
    FileDownloaderProvider dp = FileDownloaderProvider();
    String _dir = await dp.getSafeUpgradeFolder();
    bool directoryExist = await dp.checkDirectoryExist(_dir);
    if (directoryExist) {
      dp.deleteSafeUpgradeFolder(_dir);
    }
  }

  Widget matchesTargetVersion(width) {
    print(_settings.machine['buildNumber']);
    if (_settings.machine['buildNumber'] >=
        (int.parse(_settings.targetOSVersion))) {
      /* here  we should remove any launch_at_startup that it is happening */
      var cc = disableLaunchAtStartup();
      cc.then((response) {
        print(1);
        print(response);
      });

      return LottieAndMessage(
          "Congratulations, you have successfully installed the newest upgrade"
              " ${_settings.machine['displayVersion']} (${_settings.machine['buildNumber']})  in this device (${_settings.machine['computerName']} ) ",
          'assets/lottie/success2.json');
    } else if (_settings.machine['buildNumber'] <
        (int.parse(_settings.minimumOsVersion))) {
      return LottieAndMessage(
          "Unfortunately, your Microsoft Windows version "
              " ${_settings.machine['displayVersion']} (Build Version: ${_settings.machine['displayVersion']} ) is not compatible for this upgrade ",
          'assets/lottie/transactionFailed.json');
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: width,
            margin: EdgeInsets.all(0.0),
            padding: EdgeInsets.all(0.0),
            child: Login2(_settings, successfullLogin),
          ),
        ],
      );
    }
  }

  /* *******************************
  ***    BUILD   **************
  **********************************/
  final buttonColors = WindowButtonColors(
      iconNormal: Colors.blueGrey,
      mouseOver: Colors.blueGrey,
      mouseDown: Colors.black12,
      iconMouseOver: Colors.black,
      iconMouseDown: Colors.black);

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Schrock Safe Upgrade Installer'),
        flexibleSpace: Container(child: MoveWindow()),
        actions: [
          MinimizeWindowButton(colors: buttonColors),
      CloseWindowButton(colors:buttonColors),
    ]
      ),
      body: _settings.canDoUpdate
          ? matchesTargetVersion(screenSize.width)
          : FailSettings(_settings),
    );
  }
}
