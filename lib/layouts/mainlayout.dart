import 'package:smarthome/layouts/customAppBar.dart';
import 'package:smarthome/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:smarthome/layouts/Dashboard.dart';
import 'package:smarthome/layouts/Network.dart';
import 'package:smarthome/layouts/Settings.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  static const List<String> _pageNames = <String>[
    "Rooms",
    "Network devices",
    "Settings",
  ];
  static const List<String> _pageIcons = <String>[
    "assets/house_app_icon.svg",
    "assets/refresh.svg",
    "assets/",
  ];
  static List<int> _pageAppBar = <int>[
    CustomAppBar.APP_BAR_WITH_ICONS,
    CustomAppBar.APP_BAR_WITH_ICONS,
    CustomAppBar.APP_BAR_WITHOUT_ICONS,
  ];
  
  static List<Widget> _pages = <Widget>[
    Dashboard(),
    Network(),
    Settings(),
  ];

  void onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar( _pageNames.elementAt(_selectedIndex), _pageIcons.elementAt(_selectedIndex), _pageAppBar.elementAt(_selectedIndex)),
        extendBody: true,
        body: SafeArea(
          bottom: false,
          child: _pages.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: _bottomNavigationBar(),
      ),
    );
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
}
