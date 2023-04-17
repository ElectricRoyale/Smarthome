import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:smarthome/utils/DashboardData.dart';
import 'package:smarthome/utils/weatherData.dart';

//import 'package:flutter_local_auth_invisible/flutter_local_auth_invisible.dart';

import '../generated/l10n.dart';
import 'constants.dart';

class BiometricAuthentication extends StatefulWidget {
  const BiometricAuthentication({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BiometricAuthenticationState();
}

class _BiometricAuthenticationState extends State<BiometricAuthentication> {
  LocalAuthentication auth = LocalAuthentication();

  @override
  Widget build(BuildContext context) {
    final delegate = S.of(context);
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: LayoutBuilder(
            builder: (context, constraints) => Container(
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
              width: constraints.maxWidth,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: constraints.maxHeight * 0.17),
                    child: Text(delegate.biometricScreenHeading,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                          decoration: TextDecoration.none,
                          shadows: [
                            Shadow(
                              offset: Offset(0.0, 2.5),
                              blurRadius: 3.0,
                              color: Color.fromARGB(255, 0, 0, 0),
                            )
                          ],
                        )),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 130),
                    child: Icon(
                      Icons.fingerprint,
                      color: Colors.white,
                      size: 80,
                      shadows: [
                        Shadow(
                          offset: Offset(0.0, 2.5),
                          blurRadius: 3.0,
                          color: Color.fromARGB(255, 0, 0, 0),
                        )
                      ],
                    ),
                  ),
                  const Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: Icon(
                        Icons.lock,
                        color: Colors.white,
                        size: 50,
                        shadows: [
                          Shadow(
                            offset: Offset(0.0, 2.5),
                            blurRadius: 3.0,
                            color: Color.fromARGB(255, 0, 0, 0),
                          )
                        ],
                      )),
                ],
              ),
            ),
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
    biometricLogin();
  }

  void biometricLogin() async {
    if (await auth.isDeviceSupported() && await auth.canCheckBiometrics) {
      if (await auth.authenticate(
          localizedReason: S.of(context).biometricLocalizedReason,
          options: const AuthenticationOptions(
              stickyAuth: true, biometricOnly: true, useErrorDialogs: false))) {
        DashboardData().reconnect();
        WeatherData().init(context);
        Navigator.pop(context);
      }
    }
  }
}
