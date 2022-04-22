import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mysql1/mysql1.dart';
import 'package:smarthome/Model/UserData.dart';
import 'package:smarthome/layouts/mainlayout.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserDataAdapter());
  var userData = await Hive.openBox<UserData>('UserData');
  setUserData(userData);
  runApp(const MyApp());
}

void setUserData(Box userData){
  var settings = ConnectionSettings(
      host: '192.168.0.51',
      port: 3308,
      user: 'Pascal',
      password: 'Electric Royale',
      db: 'UserData'
  );
  //var conn = await MySqlConnection.connect(settings);
  //var results = await conn.query('select * from logindata where Name = \'Pascal Michael Reinmuth\'');
  final data = UserData(profileImage: , name: 'Pascal Michael Reinmuth', email: 'Pascal.Reinmuth@web.de', birthday: '27.02.2005', handyNumber: '+49 176 42656218', address: 'Wilhelm-Herz-Str. 21');
  userData.add(data);
  print('${userData.values.first} hallo');
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
