import 'dart:math';

import 'package:flutter/material.dart';

import '../../JSON/device_data.dart';
import '../../utils/constants.dart';
import '../../utils/energy_usage_statistics.dart';
import '../../utils/globals.dart';
import '../../utils/home_assistant_connection.dart';
import '../../utils/widget_functions.dart';
import '../unavailable_dialog.dart';

class VideoDevice extends StatefulWidget {
  const VideoDevice({Key? key}) : super(key: key);

  @override
  VideoDeviceState createState() => VideoDeviceState();
}

class VideoDeviceState extends State<VideoDevice> {
  bool toggle =
      deviceItem!.state != 'off' && deviceItem!.state != 'unavailable';
  List<Widget> zoneControlList = [];
  bool test = true;
  double volumeLevel = deviceItem!.attributes!.volumeLevel ?? 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (deviceItem == null || deviceItem!.state == 'unavailable') {
        showDialog(
          context: context,
          builder: (context) => UnavailableDialog(
            () => Navigator.of(context, rootNavigator: true)
                .popUntil((route) => route.settings.name == 'overviewpage'),
          ),
        );
      }
    });
    onUpdate = () => refresh();
  }

  void refresh() {
    setState(() {
      toggle = deviceItem!.state != 'off' && deviceItem!.state != 'unavailable';
      volumeLevel = deviceItem!.attributes!.volumeLevel ?? 0;
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
            controller(),
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

  Widget controller() {
    if (deviceItem!.attributes!.icon == 'mdi:television') {
      return SizedBox(
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
                    child:
                        const Icon(Icons.input_rounded, color: Colors.white)),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                color: const Color.fromARGB(255, 82, 82, 93),
                clipBehavior: Clip.hardEdge,
                padding: EdgeInsets.zero,
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
      );
    } else if (deviceItem!.attributes!.icon == 'mdi:audio-video') {
      return SizedBox(
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
                    '{"id": ${idNumber++}, "type": "call_service", "domain": "media_player", "service": "volume_mute", "target": {"entity_id": "${deviceItem!.entityId}"}, "service_data" : {"is_volume_muted":"${!(deviceItem!.attributes!.isVolumeMuted!)}"}}',
                    if (deviceItem!.secondZone != null)
                      '{"id": ${idNumber++}, "type": "call_service", "domain": "media_player", "service": "volume_mute", "target": {"entity_id": "${deviceItem!.secondZone!.entityId}"}, "service_data" : {"is_volume_muted":"${!(deviceItem!.secondZone!.attributes!.isVolumeMuted!)}"}}'
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
                        '{"id": ${idNumber++}, "type": "call_service", "domain": "media_player", "service": "volume_up", "target": {"entity_id": "${deviceItem!.entityId}"}}',
                        if (deviceItem!.secondZone != null)
                          '{"id": ${idNumber++}, "type": "call_service", "domain": "media_player", "service": "volume_up", "target": {"entity_id": "${deviceItem!.secondZone!.entityId}"}}'
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
                        '{"id": ${idNumber++}, "type": "call_service", "domain": "media_player", "service": "volume_down", "target": {"entity_id": "${deviceItem!.entityId}"}}',
                        if (deviceItem!.secondZone != null)
                          '{"id": ${idNumber++}, "type": "call_service", "domain": "media_player", "service": "volume_down", "target": {"entity_id": "${deviceItem!.secondZone!.entityId}"}}'
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
                padding: EdgeInsets.only(
                    top: 50, left: MediaQuery.of(context).size.width * 0.15),
                child: zoneControlColumn()),
            Positioned(
              right: MediaQuery.of(context).size.width * 0.1,
              bottom: MediaQuery.of(context).size.height * 0.045,
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(12)),
                clipBehavior: Clip.hardEdge,
                height: MediaQuery.of(context).size.height * 0.2,
                child: RotatedBox(
                  quarterTurns: 3,
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 24,
                      thumbShape: SliderComponentShape.noOverlay,
                      overlayShape: SliderComponentShape.noOverlay,
                      inactiveTrackColor: const Color.fromARGB(255, 82, 82, 93),
                      activeTrackColor: Colors.white,
                      valueIndicatorShape: SliderComponentShape.noOverlay,
                      trackShape: const RectangularSliderTrackShape(),
                    ),
                    child: Slider(
                      max: 1.0,
                      min: 0,
                      divisions: 20,
                      value: volumeLevel,
                      onChanged: (double value) => setState(() {
                        if (deviceItem!.state != 'off' &&
                            deviceItem!.state != 'unavailable' &&
                            deviceItem!.attributes!.volumeLevel! >=
                                volumeLevel) {
                          deviceItem!.attributes!.volumeLevel = value;
                        }
                        if (deviceItem!.secondZone != null &&
                            deviceItem!.secondZone!.state != 'off' &&
                            deviceItem!.secondZone!.state != 'unavailable' &&
                            deviceItem!.secondZone!.attributes!.volumeLevel! >=
                                volumeLevel) {
                          deviceItem!.secondZone!.attributes!.volumeLevel =
                              value;
                        }
                        volumeLevel = value;
                      }),
                      onChangeEnd: (double value) =>
                          HomeAssistantConnection().send([
                        '{"id": ${idNumber++}, "type": "call_service", "domain" : "media_player", "service": "volume_set", "service_data" : {"volume_level" : "${deviceItem!.attributes!.volumeLevel}"}, "target" : {"entity_id": "${deviceItem!.entityId}"}}',
                        if (deviceItem!.secondZone != null)
                          '{"id": ${idNumber++}, "type": "call_service", "domain" : "media_player", "service": "volume_set", "service_data" : {"volume_level" : "${deviceItem!.secondZone!.attributes!.volumeLevel}"}, "target" : {"entity_id": "${deviceItem!.secondZone!.entityId}"}}'
                      ]),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 20,
              top: 50,
              child: ElevatedButton(
                onPressed: () => HomeAssistantConnection().send([
                  '{"id": ${idNumber++}, "type": "call_service", "domain": "media_player", "service": "toggle", "target": {"entity_id": "${deviceItem!.entityId}"}}',
                  if (deviceItem!.secondZone != null)
                    '{"id": ${idNumber++}, "type": "call_service", "domain": "media_player", "service": "toggle", "target": {"entity_id": "${deviceItem!.secondZone!.entityId}"}}'
                ]),
                style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(5),
                    backgroundColor: const Color(0x25ffffff),
                    foregroundColor: const Color(0x25ffffff) // <-- Button color
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
                      ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget zoneControlColumn() {
    zoneControlList = [
      const Text(
        'Zone 1',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
      addVerticalSpace(5),
      zoneControl(deviceItem!, deviceItem!.secondZone != null),
    ];
    if (deviceItem!.secondZone != null) {
      zoneControlList.addAll([
        addVerticalSpace(20),
        const Text(
          'Zone 2',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        addVerticalSpace(5),
        zoneControl(deviceItem!.secondZone!, true),
      ]);
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: zoneControlList,
    );
  }

  Widget zoneControl(DeviceData deviceData, bool volumeController) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 35,
            width: 35,
            child: ElevatedButton(
              onPressed: () => HomeAssistantConnection().send([
                '{"id": ${idNumber++}, "type": "call_service", "domain": "media_player", "service": "toggle", "target": {"entity_id": "${deviceData.entityId}"}}'
              ]),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: const CircleBorder(),
                backgroundColor: const Color(0x25ffffff),
                foregroundColor: const Color(0x25ffffff), // <-- Button color
              ),
              child:
                  deviceData.state != 'off' && deviceData.state != 'unavailable'
                      ? const Icon(
                          Icons.power_settings_new_rounded,
                          color: COLOR_ACCENT,
                        )
                      : const Icon(
                          Icons.power_settings_new_rounded,
                          color: Color.fromARGB(255, 100, 100, 100),
                        ),
            ),
          ),
          addVerticalSpace(10),
          Container(
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(
              color: const Color(0x25ffffff),
              borderRadius: BorderRadius.circular(30),
            ),
            height: 35,
            width: 35,
            alignment: Alignment.center,
            child: InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: () => HomeAssistantConnection().send([
                      '{"id": ${idNumber++}, "type": "call_service", "domain": "media_player", "service": "media_play_pause", "target": {"entity_id": "${deviceData.entityId}"}}'
                    ]),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 32,
                )),
          ),
        ],
      ),
      addHorizontalSpace(15),
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 35,
            width: 35,
            child: PopupMenuButton(
              icon: Container(
                  padding: const EdgeInsets.all(6.0),
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(100, 145, 145, 145),
                      shape: BoxShape.circle),
                  child: const Icon(Icons.input_rounded, color: Colors.white)),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              color: const Color.fromARGB(255, 82, 82, 93),
              clipBehavior: Clip.hardEdge,
              padding: EdgeInsets.zero,
              itemBuilder: (BuildContext context) =>
                  deviceData.attributes!.sourceList!
                      .map((item) => PopupMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(color: Colors.white),
                          )))
                      .toList(),
              onSelected: (value) => HomeAssistantConnection().send([
                '{"id": ${idNumber++}, "type": "call_service", "domain": "media_player", "service": "select_source", "target": {"entity_id": "${deviceData.entityId}"}, "service_data" : {"source" : "$value"}}'
              ]),
            ),
          ),
          addVerticalSpace(10),
          SizedBox(
            height: 35,
            width: 35,
            child: PopupMenuButton(
              icon: Container(
                  padding: const EdgeInsets.all(6.0),
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(100, 145, 145, 145),
                      shape: BoxShape.circle),
                  child: const Icon(Icons.surround_sound_outlined,
                      color: Colors.white)),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              color: const Color.fromARGB(255, 82, 82, 93),
              clipBehavior: Clip.hardEdge,
              padding: EdgeInsets.zero,
              itemBuilder: (BuildContext context) =>
                  deviceData.attributes!.soundModeList!
                      .map((item) => PopupMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(color: Colors.white),
                          )))
                      .toList(),
              onSelected: (value) => HomeAssistantConnection().send([
                '{"id": ${idNumber++}, "type": "call_service", "domain": "media_player", "service": "select_source", "target": {"entity_id": "${deviceData.entityId}"}, "service_data" : {"source" : "$value"}}'
              ]),
            ),
          ),
        ],
      ),
      addHorizontalSpace(15),
      if (volumeController)
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          clipBehavior: Clip.hardEdge,
          height: 80,
          child: RotatedBox(
            quarterTurns: 3,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 14,
                thumbShape: SliderComponentShape.noOverlay,
                overlayShape: SliderComponentShape.noOverlay,
                inactiveTrackColor: const Color.fromARGB(255, 82, 82, 93),
                activeTrackColor: Colors.white,
                valueIndicatorShape: SliderComponentShape.noOverlay,
                trackShape: const RectangularSliderTrackShape(),
              ),
              child: Slider(
                max: 1.0,
                min: 0,
                divisions: 20,
                value: deviceData.attributes!.volumeLevel ?? 0,
                onChanged: (double value) => setState(() {
                  if (deviceItem!.attributes!.volumeLevel ==
                      deviceData.attributes!.volumeLevel) {
                    if (deviceData.attributes!.volumeLevel! >=
                        deviceItem!.secondZone!.attributes!.volumeLevel!) {
                      volumeLevel = value;
                    }
                  } else {
                    if (deviceData.attributes!.volumeLevel! >=
                        deviceItem!.attributes!.volumeLevel!) {
                      volumeLevel = value;
                    }
                  }
                  deviceData.attributes!.volumeLevel = value;
                }),
                onChangeEnd: (double value) => HomeAssistantConnection().send([
                  '{"id": ${idNumber++}, "type": "call_service", "domain" : "media_player", "service": "volume_set", "service_data" : {"volume_level" : "$value"}, "target" : {"entity_id": "${deviceData.entityId}"}}'
                ]),
              ),
            ),
          ),
        ),
    ]);
  }
}
