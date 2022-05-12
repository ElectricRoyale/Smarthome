

import 'package:flutter/material.dart';

import 'constants.dart';

class BiometricAuthentication extends StatelessWidget {
  const BiometricAuthentication({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
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
    );
  }
}
