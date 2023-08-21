import 'dart:async';

import 'package:dart_ping/dart_ping.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:smarthome/layouts/statistics.dart';

import '../generated/l10n.dart';
import 'network.dart';

Map pageParams(BuildContext context, int index) {
  List pages = [
    {
      'name': S.of(context).titleRooms,
      'icon': 'assets/house_app_icon.svg',
      'layout': CustomAppBarIcons.appBarWithIcons
    },
    {
      'name': S.of(context).titleNetwork,
      'icon': 'assets/refresh.svg',
      'layout': CustomAppBarIcons.appBarWithIcons
    },
    {
      'name': S.of(context).titleSettings,
      'icon': '',
      'layout': CustomAppBarIcons.appBarWithoutIcons
    },
  ];
  return pages.elementAt(index);
}

enum CustomAppBarIcons {
  appBarWithIcons,
  appBarWithoutIcons,
}

class CustomAppBar extends StatefulWidget {
  final GlobalKey<NetworkLayout> network;

  const CustomAppBar({Key? key, required this.network}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CustomAppBarLayout();
}

class CustomAppBarLayout extends State<CustomAppBar>
    with SingleTickerProviderStateMixin {
  static int index = 0;
  static late AnimationController _animationController;
  SvgPicture signalStrength = SvgPicture.asset('assets/unavailable_signal.svg');
  var ping = Ping(Hive.box('Settings').get('host').toString().substring(
      Hive.box('Settings').get('host').toString().indexOf('://') + 3,
      Hive.box('Settings').get('host').toString().lastIndexOf(':')));
  late StreamSubscription<PingData> pingStream;

  void changeIndex(int index1) {
    setState(() {
      index = index1;
      if (index1 != 1) _animationController.reset();
    });
  }

  void resumeSignalChecker() {
    var host = Hive.box('Settings').get('host').toString();
    ping = Ping(host.substring(host.indexOf('://') + 3, host.lastIndexOf(':')));
    checkSignalStrength();
  }

  void checkSignalStrength() {
    pingStream = ping.stream.listen((pingData) {
      try {
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
      } catch (_) {
        setState(() {
          signalStrength = SvgPicture.asset('assets/unavailable_signal.svg');
        });
      }
    });
    pingStream.onError((error) {
      setState(() {
        signalStrength = SvgPicture.asset('assets/unavailable_signal.svg');
      });
    });
  }

  static void stopAnimation() {
    if (index == 1) _animationController.animateTo(1);
  }

  static void startAnimation() {
    if (index == 1) {
      _animationController
          .forward()
          .then((value) => _animationController.repeat());
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.sizeOf(context);
    switch (pageParams(context, index)['layout']) {
      case CustomAppBarIcons.appBarWithIcons:
        return AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          forceMaterialTransparency: true,
          leading: Transform.translate(
              offset: const Offset(15, 8),
              child: RotationTransition(
                  turns:
                      Tween(begin: 0.0, end: 1.0).animate(_animationController),
                  child: IconButton(
                      icon: SvgPicture.asset(
                          '${pageParams(context, index)['icon']}',
                          height: screenSize.width * 0.07291666,
                          width: screenSize.width * 0.07291666,
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
                              widget.network.currentState!.listOfWifiDevices!
                                  .cancel();
                              _animationController.animateTo(1);
                            } else {
                              if (!_animationController.isAnimating) {
                                _animationController.forward().then(
                                    (value) => _animationController.repeat());
                                widget.network.currentState!.addNetworkDevice();
                              }
                            }
                            break;
                        }
                      }))),
          titleSpacing: 0,
          title: Padding(
            padding: EdgeInsets.only(top: screenSize.height * 0.021875),
            child: Text('${pageParams(context, index)['name']}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  shadows: [
                    Shadow(
                      offset: Offset(0.0, 2.5),
                      blurRadius: 3.0,
                      color: Color.fromARGB(255, 0, 0, 0),
                    )
                  ],
                ),
                textScaleFactor: 1.3),
          ),
          actions: [
            Transform.translate(
                offset: const Offset(-15, 13),
                child: IconButton(icon: signalStrength, onPressed: () {})),
          ],
        );
      case CustomAppBarIcons.appBarWithoutIcons:
        return AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          forceMaterialTransparency: true,
          title: Padding(
            padding: EdgeInsets.only(top: screenSize.height * 0.021875),
            child: Text('${pageParams(context, index)['name']}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  shadows: [
                    Shadow(
                      offset: Offset(0.0, 2.5),
                      blurRadius: 3.0,
                      color: Color.fromARGB(255, 0, 0, 0),
                    )
                  ],
                ),
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
    ping.stop();
    super.dispose();
  }
}
