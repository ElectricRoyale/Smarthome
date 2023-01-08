import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:smarthome/layouts/Login.dart';
import 'package:smarthome/layouts/Register.dart';

import '../Model/UserData.dart';
import '../Model/weatherLocations.dart';
import '../utils/MySQLHelper.dart';
import '../utils/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initializing();
  }

  void initializing() async {
    await Hive.initFlutter();
    Hive
      ..registerAdapter(WeatherLocationsAdapter())
      ..registerAdapter(UserDataAdapter());
    await Hive.openBox<UserData>('UserData');
    await Hive.openBox('LoginData');
    await Hive.openBox('Settings');
    await Hive.openBox<WeatherLocations>('WeatherLocations');
    bool isEmpty = await MySQLHelper().isEmpty();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) =>
            isEmpty ? const Register() : const Login()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              BACKGROUND_START,
              BACKGROUND_END,
            ],
          ),
        ),
        child: Image.asset(
          'icon/house_extracted.png',
          scale: 6.0,
        ));
  }
}
