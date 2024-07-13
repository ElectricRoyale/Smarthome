import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/ColorPicker/circle_color_picker.dart';
import '../../utils/ColorPicker/color_picker_controller.dart';
import '../../utils/constants.dart';
import '../../utils/energy_usage_statistics.dart';
import '../../utils/globals.dart';
import '../../utils/home_assistant_connection.dart';
import '../../utils/widget_functions.dart';

class Light extends StatefulWidget {
  const Light({Key? key}) : super(key: key);

  @override
  LightState createState() => LightState();
}

class LightState extends State<Light> {
  bool toggle = deviceItem!.state == 'on';

  Widget get _dropdownValue =>
      dropdownItems[deviceItem!.attributes!.effect ?? 'none']!;

  final _controller = CircleColorPickerController(
    initialColor: Color.fromARGB(
        255,
        (deviceItem!.attributes?.rgbColor?.elementAt(0) ?? 255),
        (deviceItem!.attributes?.rgbColor?.elementAt(1) ?? 0),
        (deviceItem!.attributes?.rgbColor?.elementAt(2) ?? 0)),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      checkAvailability(context);
    });
    onUpdate = () => _refresh();
  }

  void _refresh() {
    checkAvailability(context);
    setState(() {
      toggle = deviceItem!.state == 'on';
      _controller.color = Color.fromARGB(
          255,
          (deviceItem!.attributes?.rgbColor?.elementAt(0) ?? 255),
          (deviceItem!.attributes?.rgbColor?.elementAt(1) ?? 0),
          (deviceItem!.attributes?.rgbColor?.elementAt(2) ?? 0));
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.sizeOf(context);
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
            body: Column(children: [
              Padding(
                padding: const EdgeInsets.only(top: 50.0, bottom: 10),
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    if (deviceItem!.attributes!.effectList != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0, top: 90.0),
                        child: PopupMenuButton(
                          initialValue:
                              deviceItem!.attributes!.effect ?? 'none',
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          itemBuilder: (context) => deviceItem!
                              .attributes!.effectList!
                              .map(
                                (item) => PopupMenuItem<String>(
                                  padding: const EdgeInsets.only(left: 13.0),
                                  value: item,
                                  child: Center(
                                    child: Row(children: [
                                      dropdownItems[item]!,
                                      addHorizontalSpace(10),
                                      Text(item,
                                          style: const TextStyle(
                                              color: Colors.white))
                                    ]),
                                  ),
                                ),
                              )
                              .toList(),
                          onSelected: (value) {
                            setState(() {});
                            HomeAssistantConnection().send([
                              value == 'none'
                                  ? '{"id": ${idNumber++}, "type": "call_service", "domain" : "light", "service": "turn_on", "service_data" : {"rgb_color" : [${deviceItem!.attributes!.rgbColor!.elementAt(0)},${deviceItem!.attributes!.rgbColor!.elementAt(1)},${deviceItem!.attributes!.rgbColor!.elementAt(2)}]}, "target" : {"entity_id": "${deviceItem!.entityId}"}}'
                                  : '{"id": ${idNumber++}, "type": "call_service", "domain" : "light", "service": "turn_on", "service_data" : {"effect" : "$value"}, "target" : {"entity_id": "${deviceItem!.entityId}"}}'
                            ]);
                          },
                          color: const Color.fromARGB(255, 82, 82, 93),
                          clipBehavior: Clip.hardEdge,
                          icon: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                  color: Color.fromARGB(100, 145, 145, 145),
                                  shape: BoxShape.circle),
                              child: _dropdownValue),
                          constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).size.height / 4.5),
                        ),
                      ),
                    Align(
                      alignment: Alignment.center,
                      child: CircleColorPicker(
                        controller: _controller,
                        onChanged: (color) => setState(() {}),
                        onEnded: (color) {
                          HomeAssistantConnection().send([
                            '{"id": ${idNumber++}, "type": "call_service", "domain" : "light", "service": "turn_on", "service_data" : {"rgb_color" : [${color.red},${color.green},${color.blue}]}, "target" : {"entity_id": "${deviceItem!.entityId}"}}'
                          ]);
                          deviceItem!.attributes!.rgbColor = [
                            color.red,
                            color.green,
                            color.blue
                          ];
                        },
                        brightness:
                            (deviceItem?.attributes?.brightness ?? 0 / 255)
                                .toDouble(),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              toggle = !toggle;
                            });
                            HomeAssistantConnection().send([
                              toggle
                                  ? '{"id": ${idNumber++}, "type": "call_service", "domain": "light", "service": "turn_on", "target": {"entity_id": "${deviceItem!.entityId}"}}'
                                  : '{"id": ${idNumber++}, "type": "call_service", "domain": "light", "service": "turn_off", "target": {"entity_id": "${deviceItem!.entityId}"}}'
                            ]);
                          },
                          style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(20),
                              backgroundColor: const Color(0x25ffffff),
                              foregroundColor:
                                  const Color(0x25ffffff) // <-- Button color
                              ),
                          child: toggle
                              ? SvgPicture.asset(
                                  'assets/light.svg',
                                  width: 60,
                                  height: 60,
                                )
                              : SvgPicture.asset(
                                  'assets/light_off.svg',
                                  width: 60,
                                  height: 60,
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: screenSize.height * 0.021875,
                thickness: screenSize.height * 0.0021875,
                indent: screenSize.width * 0.02431,
                endIndent: screenSize.width * 0.02431,
                color: Colors.white,
              ),
              EnergyUsageStatistics(
                data: deviceItem!,
                padding: const EdgeInsets.only(top: 25),
              ),
            ])));
  }
}
