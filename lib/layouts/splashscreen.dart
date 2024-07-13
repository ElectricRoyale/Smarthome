import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/adapters.dart';

import '../Model/user_data.dart';
import '../Model/weather_locations.dart';
import '../generated/l10n.dart';
import '../layouts/discovery_page.dart';
import '../utils/constants.dart';
import '../utils/my_sql_helper.dart';
import 'login.dart';
import 'register.dart';

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

    await connection();
  }

  Future<void> connection() async {
    if (!mounted) return;
    if (Hive.box('Settings').get('host') == null) {
      await Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => const DiscoveryPage()));
    }

    if (!(await MySQLHelper().canConnect())) {
      onConnectionFailed();
      return;
    }

    bool isEmpty = await MySQLHelper().isEmpty();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(PageRouteBuilder(
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (context, animation1, animation2) =>
            isEmpty ? const Register() : const Login()));
  }

  void onConnectionFailed() {
    final delegate = S.of(context);
    Size screenSize = MediaQuery.sizeOf(context);
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => WillPopScope(
              onWillPop: () async => false,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                child: Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/error.svg',
                          width: screenSize.width * 0.2916666,
                          height: screenSize.width * 0.2916666,
                          fit: BoxFit.cover,
                        ),
                        Text(
                          delegate.connectionerrorTitle,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 26),
                        ),
                        Text(
                          delegate.connectionerrorMessage,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        TextButton(
                            onPressed: () {
                              _closeConnectionErrorDialog();
                              connection();
                            },
                            style: TextButton.styleFrom(
                                // padding: EdgeInsets.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                minimumSize: const Size(
                                    double.minPositive, double.minPositive)),
                            child: Text(delegate.retry)),
                        TextButton(
                            onPressed: () {
                              _closeConnectionErrorDialog();
                              Hive.box('Settings').delete('host');
                              connection();
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              minimumSize: const Size(
                                  double.minPositive, double.minPositive),
                            ),
                            child: Text(delegate.changeServerAddress)),
                      ]),
                ),
              ),
            ));
  }

  void _closeConnectionErrorDialog() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.sizeOf(context);
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
