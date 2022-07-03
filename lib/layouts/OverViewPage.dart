import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../JSON/device_data.dart';
import '../utils/Devices.dart';
import '../utils/constants.dart';
import '../utils/scrolling_text.dart';

class OverViewPage extends StatefulWidget {
  final String group, name, icon;

  const OverViewPage(
      {Key? key, required this.name, required this.icon, required this.group})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => OverViewPageState();
}

class OverViewPageState extends State<OverViewPage> {
  List<DeviceData> deviceData = [];

  @override
  void initState() {
    super.initState();
    switch (widget.name) {
      case 'LIGHT':
        deviceData.addAll(Devices().getLights);
        break;
      case 'SOCKET':
        deviceData.addAll(Devices().getSockets);
        break;
      case 'ROLLER SHUTTER':
        deviceData.addAll(Devices().getShutters);
        break;
      case 'AIR CONDITIONER':
        deviceData.addAll(Devices().getAirConditioners);
        break;
      case 'VIDEO DEVICES':
        deviceData.addAll(Devices().getVideoDevices);
        break;
      case 'HEATING SYSTEM':
        deviceData.addAll(Devices().getHeatingSystems);
        break;
      case 'KITCHEN TOOLS':
        deviceData.addAll(Devices().getKitchenTools);
        break;
      case 'WASHING MACHINE':
        deviceData.addAll(Devices().getWashingMachines);
        break;
      case 'IRRIGATION':
        deviceData.addAll(Devices().getIrrigations);
        break;
    }
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
        appBar: AppBar(
          title: Text(
            widget.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
        ),
        backgroundColor: Colors.transparent,
        body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 3.25 / 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15),
          padding: const EdgeInsets.only(left: 7, right: 7, top: 20),
          itemCount: deviceData.length,
          itemBuilder: (ctx, index) => Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              color: const Color(0x12ffffff),
              borderRadius: BorderRadius.circular(15),
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SvgPicture.asset(
                  'assets/${widget.icon}',
                  fit: BoxFit.scaleDown,
                  height: 50,
                  width: 50,
                ),
              ),
              Container(
                width: double.maxFinite,
                height: 16,
                margin: const EdgeInsets.only(top: 5, left: 10, right: 10),
                child: ScrollingText(
                  velocity: 20,
                  maxWidth: 170,
                  text: (deviceData.elementAt(index).attributes!.friendlyName)!,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none),
                  pauseAfterRound: const Duration(seconds: 3),
                  blankSpace: 100,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  deviceData.elementAt(index).energy != 'Unavailable'
                      ? '${deviceData.elementAt(index).energy} KWh USED'
                      : deviceData.elementAt(index).energy,
                  style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      decoration: TextDecoration.none),
                  maxLines: 1,
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
