import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'globals.dart';

enum ConnectionStatus { connected, connectionLost, unknown }

class ErrorDialog extends StatelessWidget {
  final Connectivity _connectivity = Connectivity();
  BuildContext? _context;
  Function(ConnectionStatus)? _onChange;
  bool _retry = false;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  ErrorDialog({Key? key}) : super(key: key);

  void initialize(BuildContext context,
      {Function(ConnectionStatus connectionStatus)? onChange}) {
    _context = context;
    _onChange = onChange;
    _initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void checkConnection() async {
    await Socket.connect('192.168.0.51', 80,
            timeout: const Duration(milliseconds: 1000))
        .then((socket) {
      if (connectionError) {
        _popDialog();
      }
      _retry = false;
      socket.destroy();
    }).catchError((error) {
      _retry = true;
      if (!connectionError) _showDialog();
      debugPrint("Exception on Socket $error");
    });
  }

  Future<void> _initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return _updateConnectionStatus(result);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        if (connectionError) {
          _popDialog();
          _onChange!(ConnectionStatus.connected);
        }
        break;
      case ConnectivityResult.mobile:
        _onChange!(ConnectionStatus.connectionLost);
        debugPrint('connection Error');
        if (!connectionError) _showDialog();
        break;
      case ConnectivityResult.none:
        _onChange!(ConnectionStatus.connectionLost);
        debugPrint('connection Error');
        if (!connectionError) _showDialog();
        break;
      default:
        _onChange!(ConnectionStatus.unknown);
        debugPrint('connection Error');
        if (!connectionError) _showDialog();
        break;
    }
  }

  void _showDialog() {
    connectionError = true;
    showDialog(
        context: _context!,
        barrierDismissible: false,
        useRootNavigator: true,
        builder: (BuildContext context) => build(context));
  }

  void _popDialog() {
    if (connectionError) {
      connectionError = false;
      Navigator.of(_context!, rootNavigator: true).pop();
    }
  }

  void dispose() {
    _connectivitySubscription.cancel();
    _popDialog();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: () async => false,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Stack(children: [
            Align(
                child: Padding(
                    padding: const EdgeInsets.only(bottom: 240),
                    child: SvgPicture.asset(
                      'assets/error.svg',
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ))),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Connection error',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 26),
                ),
                const Text(
                  'No internet connection!\n Please check your wifi connection, to be able to connect to the Server!',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                if (_retry)
                  TextButton(
                      onPressed: () => checkConnection(),
                      child: const Text('Retry')),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
