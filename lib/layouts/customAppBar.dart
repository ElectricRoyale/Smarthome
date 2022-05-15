import 'package:dart_ping/dart_ping.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smarthome/layouts/statistics.dart';

import 'Network.dart';

const pageParams = [
  {
    'name': 'Rooms',
    'icon': 'assets/house_app_icon.svg',
    'layout': CustomAppBar.APP_BAR_WITH_ICONS
  },
  {
    'name': 'Network',
    'icon': 'assets/refresh.svg',
    'layout': CustomAppBar.APP_BAR_WITH_ICONS
  },
  {'name': 'Settings', 'con': '', 'layout': CustomAppBar.APP_BAR_WITHOUT_ICONS},
];

class CustomAppBar extends StatefulWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;
  static const APP_BAR_WITH_ICONS = 0;
  static const APP_BAR_WITHOUT_ICONS = 1;

  CustomAppBarLayout customAppBarLayout = CustomAppBarLayout();

  CustomAppBar({Key? key})
      : preferredSize = const Size.fromHeight(70.0),
        super(key: key);

  @override
  State<StatefulWidget> createState() => customAppBarLayout;

  void update(int index) {
    customAppBarLayout.changeIndex(index);
  }
}

class CustomAppBarLayout extends State<CustomAppBar>
    with SingleTickerProviderStateMixin {
  int index = 0;
  static late AnimationController _animationController;
  SvgPicture signalStrength = SvgPicture.asset('assets/unavailable_signal.svg');
  final _ping = Ping('192.168.0.51');

  void changeIndex(int index) {
    setState(() {
      this.index = index;
      index == 1
          ? _animationController
              .forward()
              .then((value) => _animationController.repeat())
          : _animationController.reset();
    });
  }

  void checkSignalStrength() {
    _ping.stream.listen((pingData) {
      int strength = pingData.response!.time!.inMilliseconds;
      if (strength < 50) {
        setState(() {
          signalStrength = SvgPicture.asset('assets/full_signal.svg');
        });
      } else if (strength < 100) {
        setState(() {
          signalStrength = SvgPicture.asset('assets/medium_signal.svg');
        });
      } else if (strength >= 100) {
        setState(() {
          signalStrength = SvgPicture.asset('assets/low_signal.svg');
        });
      }
    });
  }

  static void stopAnimation() {
    _animationController.animateTo(1);
  }

  static void startAnimation() {
    _animationController
        .forward()
        .then((value) => _animationController.repeat());
  }

  @override
  Widget build(BuildContext context) {
    switch (pageParams.elementAt(index)['layout']) {
      case 0:
        return AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: Transform.translate(
              offset: const Offset(15, 8),
              child: RotationTransition(
                  turns:
                      Tween(begin: 0.0, end: 1.0).animate(_animationController),
                  child: IconButton(
                      icon: SvgPicture.asset(
                          '${pageParams.elementAt(index)['icon']}',
                          height: 30,
                          width: 30,
                          fit: BoxFit.scaleDown),
                      onPressed: () {
                        switch (index) {
                          case 0:
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Statistics()),
                            );
                            break;
                          case 1:
                            if (_animationController.isAnimating) {
                              Network.networkLayout.listOfWifiDevices.cancel();
                              _animationController.animateTo(1);
                            } else {
                              if (!_animationController.isAnimating) {
                                _animationController.forward().then(
                                    (value) => _animationController.repeat());
                                Network.networkLayout.addNetworkDevice();
                              }
                            }
                            break;
                        }
                      }))),
          titleSpacing: 0,
          title: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text('${pageParams.elementAt(index)['name']}',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w900),
                textScaleFactor: 1.3),
          ),
          actions: [
            Transform.translate(
                offset: const Offset(-15, 13),
                child: IconButton(icon: signalStrength, onPressed: () {})),
          ],
        );
      case 1:
        return AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text('${pageParams.elementAt(index)['name']}',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w900),
                textScaleFactor: 1.3),
          ),
        );
      default:
        return AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        );
    }
  }

  @override
  void initState() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    checkSignalStrength();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _ping.stop();
    super.dispose();
  }
}
