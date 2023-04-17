import 'dart:math';

import 'package:flutter/material.dart';
import 'package:smarthome/utils/constants.dart';
import 'package:smarthome/utils/widget_functions.dart';

import '../../utils/Home_Assistant_Connection.dart';
import '../../utils/energy_usage_statistics.dart';
import '../../utils/globals.dart';

class VideoDevice extends StatefulWidget {
  const VideoDevice({Key? key}) : super(key: key);

  @override
  VideoDeviceState createState() => VideoDeviceState();
}

class VideoDeviceState extends State<VideoDevice> {
  bool toggle = deviceItem!.state == 'on';

  @override
  void initState() {
    super.initState();
    onUpdate = () => refresh();
  }

  void refresh() {
    setState(() {
      toggle = deviceItem!.state == 'on';
    });
  }

  @override
  void dispose() {
    super.dispose();
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
        body: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.37,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    left: 20,
                    child: Container(
                      padding: const EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        color: const Color(0x25ffffff),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      margin: const EdgeInsets.only(top: 60.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: () => HomeAssistantConnection().send([
                          '{"id": ${idNumber++}, "type": "call_service", "domain": "media_player", "service": "volume_mute", "target": {"entity_id": "${deviceItem!.entityId}"}, "service_data" : {"is_volume_muted":"${deviceItem!.attributes!.isVolumeMuted}"}}'
                        ]),
                        child: deviceItem!.attributes!.isVolumeMuted ?? false
                            ? const Icon(Icons.volume_off_rounded,
                                color: Colors.white)
                            : const Icon(
                                Icons.volume_up_rounded,
                                color: Colors.white,
                              ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 80.0,
                    child: Container(
                      margin: const EdgeInsets.only(top: 60.0),
                      decoration: BoxDecoration(
                          color: const Color(0x25ffffff),
                          borderRadius: BorderRadius.circular(30)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 15.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () => HomeAssistantConnection().send([
                              '{"id": ${idNumber++}, "type": "call_service", "domain": "media_player", "service": "volume_up", "target": {"entity_id": "${deviceItem!.entityId}"}}'
                            ]),
                            borderRadius: BorderRadius.circular(30),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 35,
                            ),
                          ),
                          addVerticalSpace(30),
                          const Text(
                            'VOL',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          addVerticalSpace(30),
                          InkWell(
                            onTap: () => HomeAssistantConnection().send([
                              '{"id": ${idNumber++}, "type": "call_service", "domain": "media_player", "service": "volume_down", "target": {"entity_id": "${deviceItem!.entityId}"}}'
                            ]),
                            borderRadius: BorderRadius.circular(30.0),
                            child: const Icon(
                              Icons.remove,
                              color: Colors.white,
                              size: 35,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 60.0),
                    child: PopupMenuButton(
                      icon: Container(
                          padding: const EdgeInsets.all(6.0),
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(100, 145, 145, 145),
                              shape: BoxShape.circle),
                          child: const Icon(Icons.input_rounded,
                              color: Colors.white)),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      color: const Color.fromARGB(255, 82, 82, 93),
                      clipBehavior: Clip.hardEdge,
                      padding: EdgeInsets.zero,
                      offset: Offset(
                          -(MediaQuery.of(context).size.width * 0.27), 0),
                      itemBuilder: (BuildContext context) =>
                          deviceItem!.attributes!.sourceList!
                              .map((item) => PopupMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: const TextStyle(color: Colors.white),
                                  )))
                              .toList(),
                      onSelected: (value) => HomeAssistantConnection().send([
                        '{"id": ${idNumber++}, "type": "call_service", "domain": "media_player", "service": "select_source", "target": {"entity_id": "${deviceItem!.entityId}"}, "service_data" : {"source" : "$value"}}'
                      ]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 150.0),
                    child: Container(
                      padding: const EdgeInsets.all(1.0),
                      decoration: BoxDecoration(
                        color: const Color(0x25ffffff),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      margin: const EdgeInsets.only(top: 40.0),
                      child: InkWell(
                          borderRadius: BorderRadius.circular(30),
                          onTap: () => HomeAssistantConnection().send([
                                '{"id": ${idNumber++}, "type": "call_service", "domain": "media_player", "service": "media_play_pause", "target": {"entity_id": "${deviceItem!.entityId}"}}'
                              ]),
                          child: const Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 35,
                          )),
                    ),
                  ),
                  Positioned(
                    right: 80.0,
                    child: Container(
                      margin: const EdgeInsets.only(top: 60.0),
                      decoration: BoxDecoration(
                          color: const Color(0x25ffffff),
                          borderRadius: BorderRadius.circular(30)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 15.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () => HomeAssistantConnection().send([
                              '{"id": ${idNumber++}, "type": "call_service", "domain": "media_player", "service": "media_next_track", "target": {"entity_id": "${deviceItem!.entityId}"}}'
                            ]),
                            borderRadius: BorderRadius.circular(30),
                            child: Transform.rotate(
                              angle: (180 / 360) * pi,
                              child: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: Colors.white,
                                size: 35,
                              ),
                            ),
                          ),
                          addVerticalSpace(30),
                          const Text(
                            'CH',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          addVerticalSpace(30),
                          InkWell(
                            onTap: () => HomeAssistantConnection().send([
                              '{"id": ${idNumber++}, "type": "call_service", "domain": "media_player", "service": "media_previous_track", "target": {"entity_id": "${deviceItem!.entityId}"}}'
                            ]),
                            borderRadius: BorderRadius.circular(30),
                            child: Transform.rotate(
                              angle: -(180 / 360) * pi,
                              child: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: Colors.white,
                                size: 35,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: 20,
                    top: 50,
                    child: ElevatedButton(
                        onPressed: () => HomeAssistantConnection().send([
                              '{"id": ${idNumber++}, "type": "call_service", "domain": "media_player", "service": "toggle", "target": {"entity_id": "${deviceItem!.entityId}"}}'
                            ]),
                        style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(5),
                            backgroundColor: const Color(0x25ffffff),
                            foregroundColor:
                                const Color(0x25ffffff) // <-- Button color
                            ),
                        child: toggle
                            ? const Icon(
                                Icons.power_settings_new_rounded,
                                color: COLOR_ACCENT,
                                size: 35,
                              )
                            : const Icon(
                                Icons.power_settings_new_rounded,
                                color: Color.fromARGB(255, 100, 100, 100),
                                size: 35,
                              )),
                  ),
                ],
              ),
            ),
            const Divider(
              height: 20,
              thickness: 2,
              indent: 10,
              endIndent: 10,
              color: Colors.white,
            ),
            EnergyUsageStatistics(
              data: deviceItem!,
              padding: const EdgeInsets.only(top: 25),
            ),
          ],
        ),
      ),
    );
  }
}
