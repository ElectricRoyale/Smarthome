import 'package:flutter/material.dart';
import 'package:flutter_local_auth_invisible/flutter_local_auth_invisible.dart';

import 'constants.dart';

class BiometricAuthentication extends StatefulWidget {
  const BiometricAuthentication({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BiometricAuthenticationState();
}

class _BiometricAuthenticationState extends State<BiometricAuthentication> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
                    child: const Text('The app is looked!',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 26,
                            decoration: TextDecoration.none)),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 130),
                    child: Icon(
                      Icons.fingerprint,
                      color: Colors.white,
                      size: 80,
                    ),
                  ),
                  const Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: Icon(Icons.lock, color: Colors.white, size: 50)),
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
    if (await LocalAuthentication.isDeviceSupported() &&
        await LocalAuthentication.canCheckBiometrics) {
      if (await LocalAuthentication.authenticate(
        localizedReason: 'Unlock the app.',
        biometricOnly: true,
        stickyAuth: true,
      )) {
        Navigator.pop(context);
      }
    }
  }
}
