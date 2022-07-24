import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smarthome/Model/UserData.dart';
import 'package:smarthome/utils/biometricAuthentication.dart';

import 'layouts/Login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserDataAdapter());
  await Hive.openBox<UserData>('UserData');
  await Hive.openBox('LoginData');

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
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarContrastEnforced: true,
        statusBarColor: Colors.transparent, // transparent status bar
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor:
            Colors.transparent, // navigation bar color
        statusBarIconBrightness: Brightness.light, // status bar icons' color
        systemNavigationBarIconBrightness:
            Brightness.dark, //navigation bar icons' color
      ),
    );
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
        overlays: [SystemUiOverlay.top]);
    return MaterialApp(
      theme: ThemeData(),
      routes: {
        'biometricAuthentication': (BuildContext ctx) =>
            const BiometricAuthentication()
      },
      home: const Login(),
    );
  }
}
