import 'dart:convert';
import 'dart:io';


class driveHealthGetter
{
Future<String> fetchWinID(
String executable,
List<String> arguments,
String regExpSource,
) async {
String id = '';
try {
final process = await Process.start(
executable,
arguments,
mode: ProcessStartMode.detachedWithStdio,
);
final result = await process.stdout.transform(utf8.decoder).toList();
for (var element in result) {
final item = element.replaceAll(RegExp('[\n | ^\w]'), '');
if (item.isNotEmpty) {
id = id + item;
}
}
} on Exception catch (_) {}

return id;
}

Future<String> runcmd(
String executable,
List<String> arguments,
String regExpSource,
) async {
String id = '';
try {
final process = await Process.start(
executable,
arguments,
mode: ProcessStartMode.normal,
);

final result = await process.stdout.transform(utf8.decoder).toList();
for (var element in result) {
final item = element.replaceAll(RegExp(""), '');
if (item.isNotEmpty) {
id = id + item;
}
}
} on Exception catch (_) {
id = "could not run";
}

return id;
}


Future<String> diskDrive1info(String sn) async {
  return runcmd(
    "powershell.exe",
    [
      ' Get-PhysicalDisk -serialnumber $sn | Get-StorageReliabilityCounter |Select-Object -Property wear, ReadErrorsTotal, ReadErrorsCorrected, WriteErrorsTotal, WriteErrorsUncorrected  | Format-List',
    ],
    'serialnumber',
  );
}
late String sn;
Future<String> health(int ind) async {

  await serailNumber(ind).then((value) {
    String serialNumber = value;
    sn = serialNumber.replaceAll("SerialNumber", "").trim();
  });


  late String drivehealth;
    await diskDrive1info(sn).then((value) async {
      List<String> alldata = value.split("\n");
      String wear = alldata[1];
      String rError = alldata[2];
      String rErrorC = alldata[3];
      String wError = alldata[4];
      String wErrorU = alldata[5];
      print(alldata);
      int wearE;
      int rErrorE;
      int rErrorCE;
      int wErrorE;
      int wErrorUE;
      int errorcount = 0;
      try{ wearE = int.parse(wear.replaceAll(
        RegExp(r"\D"), "",)
          .trim());}
      catch(e){
        wearE = 0;
        errorcount=errorcount++;
      }
      try{
        rErrorE = int.parse(rError.replaceAll(
          RegExp(r"\D"), "",)
            .trim());}
      catch(e){
        rErrorE = 0;
        errorcount=errorcount++;
      }
      try{
        rErrorCE =int.parse( rErrorC.replaceAll(
          RegExp(r"\D"), "",)
            .trim());}
      catch(e){
        rErrorCE=0;
        errorcount=errorcount++;
      }
      try{
        wErrorE = int.parse(wError.replaceAll(
          RegExp(r"\D"), "",)
            .trim());}
      catch(e){
        wErrorE = 0;
        errorcount=errorcount++;
      }
      try{
        wErrorUE = int.parse(wErrorU.replaceAll(
          RegExp(r"\D"), "",)
            .trim());}
      catch(e){
        wErrorUE = 0;
        errorcount=errorcount++;
      }
      String health = "";
      if (errorcount == 5){
        health = "There was an error";
      }
      else {
        health = "${100 - wearE - rErrorE - rErrorCE - wErrorE - wErrorUE }%";

      }
      print(health);
      drivehealth= health;
    });





  return drivehealth;
}

 Future<String> serailNumber(int i) async {

return fetchWinID(
'wmic',
['diskdrive', '$i', 'get', 'serialnumber'],
'processorid',
);
}
}