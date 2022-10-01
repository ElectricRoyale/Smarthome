import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:smarthome/layouts/Dashboard.dart';
import 'package:smarthome/layouts/Network.dart';
import 'package:smarthome/layouts/Settings.dart';
import 'package:smarthome/layouts/customAppBar.dart';
import 'package:smarthome/utils/constants.dart';
import 'package:smarthome/utils/error_dialog.dart';
import 'package:smarthome/utils/globals.dart';

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
  ErrorDialog errorDialog = ErrorDialog();

  bool dashboardIsInit = false,
      networkIsInit = false,
      settingsIsInit = false,
      visible = true;

  AppLifecycleState lastAppState = AppLifecycleState.resumed;

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
            appBar: CustomAppBar(key: customAppBar, network: network),
            extendBody: true,
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
          tileMode: TileMode.decal,
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (lastAppState == AppLifecycleState.paused &&
        state == AppLifecycleState.resumed) {
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
    lastAppState = state;
    super.didChangeAppLifecycleState(state);
  }
}
