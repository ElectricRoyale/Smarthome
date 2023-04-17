import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:smarthome/layouts/discovery_page.dart';

import '../Model/UserData.dart';
import '../Model/weatherLocations.dart';
import '../utils/MySQLHelper.dart';
import '../utils/constants.dart';
import 'Login.dart';
import 'Register.dart';

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

    if (!mounted) return;
    if (Hive.box('Settings').get('host') == null) {
      await Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => const DiscoveryPage()));
    }

    bool isEmpty = await MySQLHelper().isEmpty();

    if (!mounted) return;
    Navigator.of(context).pushReplacement(PageRouteBuilder(
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (context, animation1, animation2) =>
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
