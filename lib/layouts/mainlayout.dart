import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:smarthome/layouts/custom_app_bar.dart';
import 'package:smarthome/layouts/dashboard.dart';
import 'package:smarthome/layouts/network.dart';
import 'package:smarthome/layouts/settings.dart';
import 'package:smarthome/utils/connection_manager.dart';
import 'package:smarthome/utils/constants.dart';
import 'package:smarthome/utils/globals.dart';

import '../generated/l10n.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  int _selectedIndex = 0;
  final network = GlobalKey<NetworkLayout>();
  final customAppBar = GlobalKey<CustomAppBarLayout>();
  ConnectionManager errorDialog = ConnectionManager();

  bool dashboardIsInit = false,
      networkIsInit = false,
      settingsIsInit = false,
      visible = true;

  bool authenticationNeeded = false;

  double widget1Opacity = 0.0;

  void onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
      customAppBar.currentState!.changeIndex(index);
    });
    index == 1
        ? network.currentState!.resume()
        : network.currentState!.stop(false);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Builder(builder: (context) {
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
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(screenSize.height * 0.065),
                child: CustomAppBar(key: customAppBar, network: network)),
            body: SafeArea(
              bottom: false,
              child: IndexedStack(
                index: _selectedIndex,
                children: [
                  const Dashboard(),
                  Network(key: network),
                  const Settings(),
                ],
              ),
            ),
            bottomNavigationBar: _bottomNavigationBar(),
          ),
        ),
      );
    });
  }

  Widget _bottomNavigationBar() {
    final delegate = S.of(context);
    Size screenSize = MediaQuery.sizeOf(context);
    return Container(
      height: screenSize.height * 0.1,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(50)),
        boxShadow: [
          BoxShadow(color: Colors.black38, spreadRadius: 1.25, blurRadius: 3),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0x2bffffff),
                Colors.transparent,
              ],
              tileMode: TileMode.decal,
            ),
          ),
          clipBehavior: Clip.hardEdge,
          child: DefaultTabController(
            length: 3,
            initialIndex: _selectedIndex,
            child: TabBar(
              onTap: onItemTap,
              splashFactory: InkSplash.splashFactory,
              dividerColor: Colors.transparent,
              indicator: BoxDecoration(),
              labelColor: Colors.white,
              splashBorderRadius: BorderRadius.circular(50),
              tabs: <Tab>[
                Tab(
                  icon: Icon(
                    Icons.dashboard_rounded,
                    color: _selectedIndex == 0 ? COLOR_ACCENT : Colors.white,
                    shadows: const [
                      Shadow(
                        offset: Offset(0.0, 2.5),
                        blurRadius: 3.0,
                        color: Color.fromARGB(255, 0, 0, 0),
                      )
                    ],
                  ),
                  text: 'Dashboard',
                ),
                Tab(
                  icon: Icon(
                    Icons.wifi_tethering,
                    color: _selectedIndex == 1 ? COLOR_ACCENT : Colors.white,
                    shadows: const [
                      Shadow(
                        offset: Offset(0.0, 2.5),
                        blurRadius: 3.0,
                        color: Color.fromARGB(255, 0, 0, 0),
                      )
                    ],
                  ),
                  text: delegate.titleNetwork,
                ),
                Tab(
                  icon:  Icon(
                    Icons.settings,
                    color: _selectedIndex == 2 ? COLOR_ACCENT : Colors.white,
                    shadows: const[
                      Shadow(
                        offset: Offset(0.0, 2.5),
                        blurRadius: 3.0,
                        color: Color.fromARGB(255, 0, 0, 0),
                      )
                    ],
                  ),
                  text: delegate.titleSettings,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    errorDialog.initialize(context, onChange: (connectionStatus) {
      if (connectionStatus == ConnectionStatus.connected) {
        if (_selectedIndex == 1) network.currentState!.resume();
        customAppBar.currentState!.resumeSignalChecker();
      } else {
        customAppBar.currentState!.pingStream.cancel();
        network.currentState!.stop(true);
      }
    });
    widget1Opacity = 1;
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    errorDialog.dispose();
    Hive.close();
    super.dispose();
  }

  void _onResume() {
    Navigator.popUntil(context, (route) {
      if (route.settings.name == 'biometricAuthentication') {
        return false;
      }
      return true;
    });
    if (mustAuthenticate) {
      Navigator.pushNamed(context, 'biometricAuthentication').then((value) =>
          errorDialog.initialize(context, onChange: (connectionStatus) {
            if (connectionStatus == ConnectionStatus.connected) {
              if (_selectedIndex == 1) network.currentState!.resume();
              customAppBar.currentState!.resumeSignalChecker();
            } else {
              customAppBar.currentState!.pingStream.cancel();
              network.currentState!.stop(true);
            }
          }));
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (authenticationNeeded) _onResume();
        authenticationNeeded = false;
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.hidden:
        //SystemNavigator.pop();
        break;
      case AppLifecycleState.paused:
        authenticationNeeded = true;
        break;
    }
    super.didChangeAppLifecycleState(state);
  }
}
