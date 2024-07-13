import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dart_ping/dart_ping.dart';
import 'package:flutter/material.dart';
import 'package:lan_scanner/lan_scanner.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:speed_test_dart/speed_test_dart.dart';
import 'package:sprintf/sprintf.dart';
import 'package:wifi_info_plugin_plus/wifi_info_plugin_plus.dart';

import '../generated/l10n.dart';
import '../layouts/custom_app_bar.dart';

class Network extends StatefulWidget {
  const Network({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => NetworkLayout();
}

class NetworkLayout extends State<Network> {
  List<dynamic> devices = [];
  StreamSubscription<void>? listOfWifiDevices;
  String subnet = '';

  Ping? _ping;
  var networkInfo = NetworkInfo();

  String ssid = '-';
  int downloadRate = 0;
  int uploadRate = 0;
  var unitText = 'MB/s';
  int pingTime = 0;
  bool running = true;
  @override
  late BuildContext context;

  SpeedTestDart tester = SpeedTestDart();

  Future<void> ping() async {
    _ping = Ping('www.google.com');
    _ping?.stream.listen((result) {
      if (result.response != null) {
        pingTime = result.response?.time?.inMilliseconds ?? 0;
      }
      setState(() {});
    });
  }

  Future<void> getWifiSpeed() async {
    WifiInfoWrapper? wifiObject;

    while (running) {
      wifiObject = await WifiInfoPlugin.wifiDetails;
      downloadRate = wifiObject!.linkSpeed;
      setState(() {});
      await Future.delayed(const Duration(seconds: 5));
    }
  }

  Future<void> uploadSpeedTest() async {
    var settings = await tester.getSettings();
    var servers = settings.servers;

    final bestServersList = await tester.getBestServers(
      servers: servers,
    );

    while (running) {
      var uploadSpeed = await tester.testUploadSpeed(
          servers: bestServersList,
          simultaneousUploads: settings.upload.threadsPerUrl == 0
              ? 2
              : settings.upload.threadsPerUrl,
          retryCount: 3);
      uploadRate = uploadSpeed.round();
      setState(() {});
      await Future.delayed(const Duration(seconds: 5));
    }
  }

  void getSSID() async {
    await networkInfo
        .getWifiName()
        .then((value) => setState(() => ssid = value!.replaceAll('"', '')));
  }

  Future<void> addNetworkDevice() async {
    await networkInfo.getWifiIP().then((ip) async {
      String subnet = ipToCSubnet(ip!);
      final scanner = LanScanner(debugLogging: true);

      if (subnet != this.subnet) {
        devices.clear();
      }

      final stream = scanner.icmpScan(
        this.subnet = subnet,
        progressCallback: (progress) {
          log('progress: $progress');
        },
      );

      listOfWifiDevices = stream.listen((host) async {
        /*if (host.isReachable ?? false) {
          await host.internetAddress.reverse().then((value) {
            Map<String, String> deviceData = {
              'name': value.host.substring(0, value.host.indexOf('.')),
              'ip': host.internetAddress.address
            };
            _updateList(deviceData);
          }).catchError((error) {
            debugPrint(error.toString());
            Map<String, String> deviceData = {
              'name': S.of(context).unknown,
              'ip': host.internetAddress.address
            };
            _updateList(deviceData);
          });
        } else {
          devices.removeWhere(
              (element) => element.containsValue(host.internetAddress.address));
        }*/
      })
        ..onDone(() => CustomAppBarLayout.stopAnimation());
    });
  }

  void _updateList(Map<String, String> deviceData) {
    setState(() {
      devices.add(deviceData);
      devices = devices.map((item) => jsonEncode(item)).toList();
      devices = devices.toSet().toList();
      devices = devices.map((item) => jsonDecode(item)).toList();
      devices.sort((s1, s2) {
        List<String> ips1 = s1['ip']!.split(".");
        String updatedIp1 =
            sprintf("%3s.%3s.%3s.%3s", [ips1[0], ips1[1], ips1[2], ips1[3]]);
        List<String> ips2 = s2['ip']!.split(".");
        String updatedIp2 =
            sprintf("%3s.%3s.%3s.%3s", [ips2[0], ips2[1], ips2[2], ips2[3]]);
        return updatedIp1.compareTo(updatedIp2);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.sizeOf(context);
    final delegate = S.of(context);
    this.context = context;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: const Color(0x12ffffff),
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.white,
                    blurRadius: 4,
                    spreadRadius: 0,
                    offset: Offset(0, 0),
                    blurStyle: BlurStyle.outer,
                  )
                ]),
            margin: EdgeInsets.only(
                left: screenSize.width * 0.012152778,
                right: screenSize.width * 0.012152778,
                top: screenSize.height * 0.0109375),
            height: screenSize.height * 0.13,
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'ssid',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          ssid,
                          textScaleFactor: 1.3,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const VerticalDivider(
                    width: 1.1,
                    color: Colors.white,
                    indent: 10,
                    endIndent: 10,
                    thickness: 1.1,
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          delegate.speed,
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          '$uploadRate $unitText',
                          textScaleFactor: 1.3,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '$downloadRate $unitText',
                          textScaleFactor: 1.3,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const VerticalDivider(
                    width: 1.1,
                    color: Colors.white,
                    indent: 10,
                    endIndent: 10,
                    thickness: 1.1,
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Ping',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          '$pingTime',
                          textScaleFactor: 1.3,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ShaderMask(
              shaderCallback: (Rect rect) => const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.grey,
                  Colors.transparent,
                  Colors.transparent,
                  Colors.grey,
                ],
                stops: [0.0, 0.035, 0.87, 1.0],
              ).createShader(rect),
              blendMode: BlendMode.dstOut,
              child: ListView.separated(
                separatorBuilder: (context, index) => const Divider(
                  color: Colors.white,
                  indent: 10,
                  endIndent: 10,
                  thickness: 1.1,
                ),
                padding: EdgeInsets.only(
                    top: screenSize.height * 0.021875,
                    bottom: screenSize.height * 0.0875),
                itemCount: devices.length,
                itemBuilder: (context, index) => Container(
                  margin: EdgeInsets.only(left: screenSize.width * 0.0364583),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${devices.elementAt(index)['name']}',
                        textScaleFactor: 1.16,
                        style: TextStyle(
                          color: devices.elementAt(index)['name'] !=
                                  delegate.unknown
                              ? Colors.white
                              : const Color.fromARGB(255, 240, 0, 0),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${devices.elementAt(index)['ip']}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _ping!.stop();
    listOfWifiDevices!.cancel();
    running = false;
    super.dispose();
  }

  void resume() {
    ping();
    getSSID();
    addNetworkDevice();
    CustomAppBarLayout.startAnimation();
    running = true;
    getWifiSpeed();
    uploadSpeedTest();
  }

  void stop(bool error) {
    if (_ping != null) _ping!.stop();

    CustomAppBarLayout.stopAnimation();
    if (error) {
      setState(() {
        ssid = '-';
        downloadRate = 0;
        uploadRate = 0;
        pingTime = 0;
      });
    }
    running = false;
  }
}
