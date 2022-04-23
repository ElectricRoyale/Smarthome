import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mysql1/mysql1.dart';
import 'package:smarthome/Model/UserData.dart';
import 'package:smarthome/layouts/Login.dart';
import 'package:smarthome/layouts/mainlayout.dart';

import 'layouts/Register.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserDataAdapter());
  var userData = await Hive.openBox<UserData>('UserData');
  setUserData(userData);
  runApp(const MyApp());
}

void setUserData(Box<UserData> userData) async{
  var settings = ConnectionSettings(
      host: '192.168.0.51',
      port: 3308,
      user: 'Pascal',
      password: 'Electric Royale',
      db: 'UserData'
  );
  var conn = await MySqlConnection.connect(settings);
  var results = await conn.query('select Profilbild,Name,EmailAddresse,Birthday,Telephonenumber,Addresse from UserData.logindata where Name = \'Pascal Michael Reinmuth\';');
  Blob profilbild = results.first.fields['Profilbild'];
  final data = UserData(profileImage: Uint8List.fromList(profilbild.toBytes()), name: results.first.fields['Name'], email: results.first.fields['EmailAddresse'], birthday: results.first.fields['Birthday'], handyNumber: results.first.fields['Telephonenumber'], address: results.first.fields['Addresse']);
  userData.add(data);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // transparent status bar
      systemNavigationBarColor: Colors.transparent, // navigation bar color
      statusBarIconBrightness: Brightness.light, // status bar icons' color
      systemNavigationBarIconBrightness:
      Brightness.dark, //navigation bar icons' color
    ),);
    return MaterialApp(
      theme: ThemeData(),
      home:  const Login(),
    );
  }
}
