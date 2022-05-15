import 'dart:async';
import 'dart:ui';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:local_auth/local_auth.dart';
import 'package:smarthome/layouts/Dashboard.dart';
import 'package:smarthome/layouts/Network.dart';
import 'package:smarthome/layouts/Settings.dart';
import 'package:smarthome/layouts/customAppBar.dart';
import 'package:smarthome/utils/biometricAuthentication.dart';
import 'package:smarthome/utils/constants.dart';

import '../security/secure_application.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  int _selectedIndex = 0;

  final LocalAuthentication auth = LocalAuthentication();
  SecureApplicationController? _secureNotifier;

  AppLifecycleState lastState = AppLifecycleState.resumed;

  //late var dashboard, network, settings;
  CustomAppBar customAppBar = CustomAppBar();
  late BuildContext errorDialogContext;
  bool connectionError = false,
      dashboardIsInit = false,
      networkIsInit = false,
      settingsIsInit = false,
      visible = true;

  AppLifecycleState lastAppState = AppLifecycleState.resumed;

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  double widget1Opacity = 0.0;

  Widget getPage(int index) {
    switch (index) {
      case 0:
        /*var page =
            dashboardIsInit ? dashboard : (dashboard = const Dashboard());
        dashboardIsInit = true;*/
        return const Dashboard();
      case 1:
        /*var page = networkIsInit ? network : (network = const Network());
        networkIsInit = true;*/
        return const Network();
      case 2:
        /*var page = settingsIsInit ? settings : (settings = const Settings());
        settingsIsInit = true;*/
        return const Settings();
      default:
        /*var page =
            dashboardIsInit ? dashboard : (dashboard = const Dashboard());
        dashboardIsInit = true;*/
        return const Dashboard();
    }
  }

  void onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
      customAppBar.update(index);
    });
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    if (!mounted) {
      return Future.value(null);
    }
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
        if (connectionError) {
          Navigator.pop(errorDialogContext);
          if (_selectedIndex == 1) {
            Network.networkLayout.resume();
          }
        }
        connectionError = false;
        break;
      case ConnectivityResult.mobile:
        if (connectionError) {
          Navigator.pop(errorDialogContext);
        }
        connectionErrorDialog(
            'No internet connection! Please turn on your wifi, for connecting to server!');
        break;
      case ConnectivityResult.none:
        if (connectionError) {
          Navigator.pop(errorDialogContext);
        }
        connectionErrorDialog(
            'No internet connection! Please check your wifi, for connecting to server!');
        break;
      default:
        if (connectionError) {
          Navigator.pop(errorDialogContext);
        }
        connectionErrorDialog(
            'No internet connection! Please check your wifi, for connecting to server!');
        break;
    }
  }

  void connectionErrorDialog(String error) {
    connectionError = true;
    showDialog(
        context: context,
        barrierDismissible: false,
        useRootNavigator: false,
        builder: (BuildContext context) {
          errorDialogContext = context;
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
                      Text(
                        error,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ]),
              ),
            ),
          );
        });
    if (_selectedIndex == 1) Network.networkLayout.stop();
  }

  @override
  Widget build(BuildContext context) {
    return SecureApplication(
        child: SecureGate(
            opacity: 0,
            lockedBuilder: ((context, secureNotifier) {
              _secureNotifier = secureNotifier;
              return const BiometricAuthentication();
            }),
            child: Builder(builder: (context) {
              SecureApplicationProvider.of(context)!.secure();
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
                child: AnimatedOpacity(
                  opacity: widget1Opacity,
                  duration: const Duration(milliseconds: 1500),
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    appBar: customAppBar,
                    extendBody: true,
                    body: SafeArea(
                      bottom: false,
                      child: getPage(_selectedIndex),
                    ),
                    bottomNavigationBar: _bottomNavigationBar(),
                  ),
                ),
              );
            })));
  }

  Widget _bottomNavigationBar() {
    return Container(
      padding: const EdgeInsets.only(top: 12),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Color(0xE6000000),
          ],
          tileMode: TileMode.clamp,
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: onItemTap,
        showUnselectedLabels: true,
        backgroundColor: Colors.transparent,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.white,
        selectedIconTheme: const IconThemeData(color: COLOR_ACCENT),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wifi_tethering),
            label: 'Network',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  void biometricLogin() async {
    if (await auth.isDeviceSupported() && await auth.canCheckBiometrics) {
      if (await auth.authenticate(
          localizedReason: 'Please complete the biometrics to proceed.',
          options: const AuthenticationOptions(
            biometricOnly: true,
            stickyAuth: true,
          ))) {
        _secureNotifier?.authSuccess(unlock: true);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    widget1Opacity = 1;
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    WidgetsBinding.instance.removeObserver(this);
    Hive.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (lastAppState == AppLifecycleState.paused &&
        state == AppLifecycleState.resumed) {
      biometricLogin();
      _connectivitySubscription.cancel();
      _connectivitySubscription =
          _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    }
    lastAppState = state;
    super.didChangeAppLifecycleState(state);
  }
}
