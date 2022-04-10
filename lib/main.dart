import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smarthome/layouts/mainlayout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // transparent status bar
      systemNavigationBarColor: Colors.transparent, // navigation bar color
      statusBarIconBrightness: Brightness.dark, // status bar icons' color
      systemNavigationBarIconBrightness:
      Brightness.dark, //navigation bar icons' color
    ),);
    return MaterialApp(
      title: 'Smarthome',
      theme: ThemeData(),
      home:  MyHomePage(),
    );
  }
}
