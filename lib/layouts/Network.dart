import 'package:flutter/material.dart';
import 'package:format/format.dart';

class Network extends StatefulWidget {
  const Network({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => NetworkLayout();
}

class NetworkLayout extends State<Network> {
  List<Map<String, String>> devices = [
    {'name': 'FritzBox', 'ip': '192.168.0.3'},
    {'name': 'DeviceName', 'ip': '192.168.0.2'},
    {'name': 'FritzBox', 'ip': '192.168.0.3'},
    {'name': 'DeviceName', 'ip': '192.168.0.2'},
    {'name': 'FritzBox', 'ip': '192.168.0.3'},
    {'name': 'DeviceName', 'ip': '192.168.0.2'},
    {'name': 'FritzBox', 'ip': '192.168.0.3'},
    {'name': 'DeviceName', 'ip': '192.168.0.2'},
    {'name': 'FritzBox', 'ip': '192.168.0.3'},
    {'name': 'DeviceName', 'ip': '192.168.0.2'},
    {'name': 'FritzBox', 'ip': '192.168.0.3'},
    {'name': 'DeviceName', 'ip': '192.168.0.2'},
    {'name': 'FritzBox', 'ip': '192.168.0.3'},
    {'name': 'DeviceName', 'ip': '192.168.0.2'}
  ];

  void addNetworkDevice(Map<String, String> devicesData) {
    setState(() {
      devices.add(devicesData);
      devices.sort((s1, s2) {
        List<String> ips1 = s1['ip']!.split("\\.");
        String updatedIp1 =
            format("%3s.%3s.%3s.%3s", ips1[0], ips1[1], ips1[2], ips1[3]);
        List<String> ips2 = s2['ip']!.split("\\.");
        String updatedIp2 =
            format("%3s.%3s.%3s.%3s", ips2[0], ips2[1], ips2[2], ips2[3]);
        return updatedIp1.compareTo(updatedIp2);
      });
    });
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
                            'ReinWLAN5G',
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
                            'Speed',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 35),
                          child: Text(
                            '400 MB/S',
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
                            '38',
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
}
