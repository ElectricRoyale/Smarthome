import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:smarthome/layouts/splashscreen.dart';
import 'package:smarthome/utils/biometricAuthentication.dart';

import 'generated/l10n.dart';
import 'layouts/controllpanels/air_conditioner.dart';
import 'layouts/controllpanels/heating_system.dart';
import 'layouts/controllpanels/irrigation.dart';
import 'layouts/controllpanels/kitchen_tool.dart';
import 'layouts/controllpanels/light.dart';
import 'layouts/controllpanels/shutter.dart';
import 'layouts/controllpanels/socket.dart';
import 'layouts/controllpanels/video_device.dart';
import 'layouts/controllpanels/washing_machine.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
        statusBarColor: Colors.transparent,
        // transparent status bar
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        // navigation bar color
        statusBarIconBrightness: Brightness.light,
        // status bar icons' color
        systemNavigationBarIconBrightness:
            Brightness.dark, //navigation bar icons' color
      ),
    );
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
        overlays: [SystemUiOverlay.top]);
    return MaterialApp(
      theme: ThemeData(
          colorScheme:
              ColorScheme.fromSwatch().copyWith(secondary: Colors.white)),
      routes: {
        'biometricAuthentication': (BuildContext ctx) =>
            const BiometricAuthentication(),
        'light': (BuildContext ctx) => const Light(),
        'switch': (BuildContext ctx) => const Socket(),
        'cover': (BuildContext ctx) => const Shutter(),
        'fan': (BuildContext ctx) => const AirConditioner(),
        'media_player': (BuildContext ctx) => const VideoDevice(),
        'heating_system': (BuildContext ctx) => const HeatingSystem(),
        'kitchen_tool': (BuildContext ctx) => const KitchenTool(),
        'washing_machine': (BuildContext ctx) => const WashingMachine(),
        'irrigation': (BuildContext ctx) => const Irrigation(),
      },
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: const SplashScreen(),
    );
  }
}
