import 'dart:convert';
import 'dart:io';

import 'package:dart_ping/dart_ping.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nsd/flutter_nsd.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smarthome/layouts/customAppBar.dart';
import 'package:sprintf/sprintf.dart';
//import 'package:internet_speed_test/callbacks_enum.dart';
//import 'package:internet_speed_test/internet_speed_test.dart';

class Network extends StatefulWidget {
  const Network({Key? key}) : super(key: key);

  static late NetworkLayout networkLayout;

  @override
  State<StatefulWidget> createState() => networkLayout = NetworkLayout();
}

class NetworkLayout extends State<Network> {
  List<dynamic> devices = [];

  //final internetSpeedTest = InternetSpeedTest();

  double donwloadRate = 0;
  double uploadRate = 0;
  String unitText = 'Mb/s';
  int pingTime = 0;

  /*void ping() async{
    while (true) {
      var ping = await Ping('192.168.0.1');

      ping.stream.listen((result) {
        setState(() {
          pingTime = result.response!.time!.inMilliseconds;
        });
      });
    }
  }

  void speedTestDown() async{
    internetSpeedTest.startDownloadTesting(
        onDone: (double transferRate, SpeedUnit unit) {},
        onProgress: ((percent, transferRate, unit) {
          setState(() {
            donwloadRate = transferRate;
            unitText = unitText == SpeedUnit.Kbps ? 'Kb/s' : 'Mb/s';
          });
        }),
        onError: ((errorMessage, speedTestError) {
          print(
              'the errorMessage $errorMessage, the speedTestError $speedTestError');
        }),
    fileSize: 20000000);
  }

  void speedTestUp() async{
    internetSpeedTest.startUploadTesting(
        onDone: (double transferRate, SpeedUnit unit) {},
        onProgress: ((percent, transferRate, unit) {
          setState(() {
            uploadRate = transferRate;
            unitText = unitText == SpeedUnit.Kbps ? 'Kb/s' : 'Mb/s';
          });
        }),
        onError: ((errorMessage, speedTestError) {
          print(
              'the errorMessage $errorMessage, the speedTestError $speedTestError');
        }),
        fileSize: 20000000);
  }*/

  String ssid = '-';

  void getSSID()async {
    await Permission.location.request().isGranted;
    await NetworkInfo().getWifiName().then((value) => setState(() {
      ssid = value!;
    }));
  }

  int i = 0;

  Future<void> addNetworkDevice() async {
    await NetworkInfo().getWifiIP().then((ip) async {
      String subnet = ip!.substring(0, ip.lastIndexOf('.'));
      for (i = 1; i <= 255; i++) {
        await Socket.connect(
            '$subnet.$i', 80, timeout: Duration(milliseconds: 100)).then(
                (socket) async {
              await InternetAddress(socket.address.address).reverse().then((
                  value) {
                Map<String, String> deviceData = {
                  'name': '${value.host.substring(0, value.host.indexOf('.'))}',
                  'ip': '${socket.address.address}'
                };
                setState(() {
                  devices.add(deviceData);
                  devices = devices.map((item) => jsonEncode(item)).toList();
                  devices = devices.toSet().toList();
                  devices = devices.map((item) => jsonDecode(item)).toList();
                  devices.sort((s1, s2) {
                    List<String> ips1 = s1['ip']!.split(".");
                    String updatedIp1 = sprintf(
                        "%3s.%3s.%3s.%3s",
                        [ips1[0], ips1[1], ips1[2], ips1[3]]);
                    List<String> ips2 = s2['ip']!.split(".");
                    String updatedIp2 = sprintf(
                        "%3s.%3s.%3s.%3s",
                        [ips2[0], ips2[1], ips2[2], ips2[3]]);
                    return updatedIp1.compareTo(updatedIp2);
                  });
                });
              });
              socket.destroy();
            }).catchError((error) {
          devices.removeWhere((element) => element.containsValue('$subnet.$i'));
        });
      }
    }).then((value) => CustomAppBarLayout.stopAnimation());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Color(0x12ffffff),
                borderRadius: BorderRadius.circular(20.0)),
            margin: EdgeInsets.only(left: 5, right: 5, top: 10),
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 35, bottom: 8),
                          child: Text(
                            'ssid',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 35),
                          child: Text(
                            ssid,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                  VerticalDivider(
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
                        Padding(
                          padding: EdgeInsets.only(top: 21, bottom: 8),
                          child: Text(
                            'Speed',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            '$donwloadRate $unitText',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Text(
                            '$uploadRate $unitText',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                  VerticalDivider(
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
                        Padding(
                          padding: EdgeInsets.only(top: 35, bottom: 8),
                          child: Text(
                            'Ping',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 35),
                          child: Text(
                            '$pingTime',
                            style: TextStyle(
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
              separatorBuilder: (context, index) => Divider(
                color: Colors.white,
                indent: 10,
                endIndent: 10,
                thickness: 1.1,
              ),
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.only(top: 20, bottom: 60),
              itemCount: devices.length,
              itemBuilder: (context, index) => Container(
                margin: EdgeInsets.only(left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${devices.elementAt(index)['name']}',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    Text(
                      '${devices.elementAt(index)['ip']}',
                      style: TextStyle(color: Colors.white),
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
  void initState() {
    super.initState();
    getSSID();
    addNetworkDevice();
  }
}
