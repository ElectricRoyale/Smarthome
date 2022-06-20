import 'package:flutter/material.dart';

import '../JSON/device_data.dart';
import '../utils/Devices.dart';
import '../utils/constants.dart';

class OverViewPage extends StatefulWidget {
  final String group, name;

  const OverViewPage({Key? key, required this.name, required this.group})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => OverViewPageState();
}

class OverViewPageState extends State<OverViewPage> {
  List<DeviceData> devices = [];

  @override
  void initState() {
    super.initState();
    switch (widget.name) {
      case 'LIGHT':
        devices.addAll(Devices().getLights);
        break;
      case 'SOCKET':
        devices.addAll(Devices().getSockets);
        break;
      case 'ROLLER SHUTTER':
        devices.addAll(Devices().getShutters);
        break;
      case 'AIR CONDITIONER':
        devices.addAll(Devices().getAirConditioners);
        break;
      case 'VIDEO DEVICES':
        devices.addAll(Devices().getVideoDevices);
        break;
      case 'HEATING SYSTEM':
        devices.addAll(Devices().getHeatingSystems);
        break;
      case 'KITCHEN TOOLS':
        devices.addAll(Devices().getKitchenTools);
        break;
      case 'WASHING MACHINE':
        devices.addAll(Devices().getWashingMachines);
        break;
      case 'IRRIGATION':
        devices.addAll(Devices().getIrrigations);
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
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            widget.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
        ),
        body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20),
          padding: const EdgeInsets.only(left: 5, right: 5, top: 20),
          itemCount: devices.length,
          itemBuilder: (ctx, index) => Container(
            decoration: BoxDecoration(
                color: const Color(0x12ffffff),
                borderRadius: BorderRadius.circular(15)),
            child: Text(
              (devices.elementAt(index).attributes!.friendlyName)!,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  decoration: TextDecoration.none),
            ),
          ),
        ),
      ),
    );
  }
}
