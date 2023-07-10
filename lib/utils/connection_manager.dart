import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:smarthome/layouts/error_dialog.dart';

import 'globals.dart';

enum ConnectionStatus { connected, connectionLost, unknown }

class ConnectionManager {
  final Connectivity _connectivity = Connectivity();
  late BuildContext _context;
  Function(ConnectionStatus)? _onChange;
  bool _retry = false;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  void initialize(BuildContext context,
      {Function(ConnectionStatus connectionStatus)? onChange}) {
    _context = context;
    _onChange = onChange;
    _initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void checkConnection() async {
    await Socket.connect(
            Hive.box('Settings').get('host').toString().substring(
                Hive.box('Settings').get('host').toString().indexOf('://') + 3,
                Hive.box('Settings').get('host').toString().lastIndexOf(':')),
            8123,
            timeout: const Duration(seconds: 2))
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
        _popDialog();
        _onChange!(ConnectionStatus.connected);
        break;
      case ConnectivityResult.none:
        _popDialog();
        _onChange!(ConnectionStatus.connectionLost);
        debugPrint('connection Error');
        if (!connectionError) _showDialog();
        break;
      default:
        _popDialog();
        _onChange!(ConnectionStatus.unknown);
        debugPrint('connection Error');
        if (!connectionError) _showDialog();
        break;
    }
  }

  void _showDialog() {
    connectionError = true;
    showDialog(
        context: _context,
        barrierDismissible: false,
        useRootNavigator: true,
        builder: (BuildContext context) =>
            ErrorDialog(_retry, checkConnection));
  }

  void _popDialog() {
    if (connectionError) {
      connectionError = false;
      Navigator.of(_context, rootNavigator: true).pop();
    }
  }

  void dispose() {
    _connectivitySubscription.cancel();
    _popDialog();
  }
}
