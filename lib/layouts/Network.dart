import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_ping/dart_ping.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lan_scanner/lan_scanner.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smarthome/layouts/customAppBar.dart';
import 'package:speed_test_port/speed_test_port.dart';
import 'package:sprintf/sprintf.dart';
import 'package:wifi_info_plugin_plus/wifi_info_plugin_plus.dart';

class Network extends StatefulWidget {
  const Network({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => NetworkLayout();
}

class NetworkLayout extends State<Network> {
  List<dynamic> devices = [];
  late StreamSubscription<void> listOfWifiDevices;

  late Ping _ping;
  var networkInfo = NetworkInfo();

  String ssid = '-';
  int downloadRate = 0;
  int uploadRate = 0;
  var unitText = 'MB/s';
  int pingTime = 0;
  bool running = true;
  @override
  late BuildContext context;

  SpeedTest tester = SpeedTest();

  Future<void> ping() async {
    _ping.stream.listen((result) {
      pingTime = result.response!.time!.inMilliseconds;
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
    var settings = await tester.GetSettings();
    var servers = settings.servers;

    for (var server in servers) {
      server.Latency = await tester.TestServerLatency(server, 3);
    }

    //Getting best server
    servers.sort((a, b) => a.Latency.compareTo(b.Latency));
    var bestServer = servers.first;

    while (running) {
      var uploadSpeed = await tester.TestUploadSpeed(
          bestServer,
          settings.upload.ThreadsPerUrl == 0
              ? 2
              : settings.upload.ThreadsPerUrl,
          3);
      uploadRate = uploadSpeed.round();
      setState(() {});
      await Future.delayed(const Duration(seconds: 5));
    }
  }

  void getSSID() async {
    await Permission.location.request().isGranted;
    await networkInfo
        .getWifiName()
        .then((value) => setState(() => ssid = value!));
  }

  Future<void> addNetworkDevice() async {
    await networkInfo.getWifiIP().then((ip) async {
      String subnet = ipToCSubnet(ip!);
      final scanner = LanScanner(debugLogging: true);

      final stream = scanner.icmpScan(
        subnet,
        progressCallback: (progress) {
          if (kDebugMode) {
            print('progress: $progress');
          }
        },
      );

      listOfWifiDevices = stream.listen((host) async {
        if (host.isReachable) {
          await InternetAddress(host.ip).reverse().then((value) {
            Map<String, String> deviceData = {
              'name': value.host.substring(0, value.host.indexOf('.')),
              'ip': host.ip
            };
            setState(() {
              devices.add(deviceData);
              devices = devices.map((item) => jsonEncode(item)).toList();
              devices = devices.toSet().toList();
              devices = devices.map((item) => jsonDecode(item)).toList();
              devices.sort((s1, s2) {
                List<String> ips1 = s1['ip']!.split(".");
                String updatedIp1 = sprintf(
                    "%3s.%3s.%3s.%3s", [ips1[0], ips1[1], ips1[2], ips1[3]]);
                List<String> ips2 = s2['ip']!.split(".");
                String updatedIp2 = sprintf(
                    "%3s.%3s.%3s.%3s", [ips2[0], ips2[1], ips2[2], ips2[3]]);
                return updatedIp1.compareTo(updatedIp2);
              });
            });
          });
        } else {
          devices.removeWhere((element) => element.containsValue(host.ip));
        }
      })
        ..onDone(() => CustomAppBarLayout.stopAnimation());
    });
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: const Color(0x12ffffff),
                borderRadius: BorderRadius.circular(20.0)),
            margin: const EdgeInsets.only(left: 5, right: 5, top: 10),
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 35, bottom: 8),
                          child: Text(
                            'ssid',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 35),
                          child: Text(
                            ssid,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
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
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 21, bottom: 8),
                          child: Text(
                            'Speed',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            '$downloadRate $unitText',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Text(
                            '$uploadRate $unitText',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
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
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 35, bottom: 8),
                          child: Text(
                            'Ping',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 35),
                          child: Text(
                            '$pingTime',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
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
            child: ListView.separated(
              separatorBuilder: (context, index) => const Divider(
                color: Colors.white,
                indent: 10,
                endIndent: 10,
                thickness: 1.1,
              ),
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(top: 20, bottom: 90),
              itemCount: devices.length,
              itemBuilder: (context, index) => Container(
                margin: const EdgeInsets.only(left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${devices.elementAt(index)['name']}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
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
        ],
      ),
    );
  }

  @override
  void dispose() {
    _ping.stop();
    listOfWifiDevices.cancel();
    running = false;
    super.dispose();
  }

  void resume() {
    _ping = Ping('google.com');
    ping();
    getSSID();
    addNetworkDevice();
    CustomAppBarLayout.startAnimation();
    running = true;
    getWifiSpeed();
    uploadSpeedTest();
  }

  void stop(bool error) {
    _ping.stop();
    listOfWifiDevices.cancel();
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
