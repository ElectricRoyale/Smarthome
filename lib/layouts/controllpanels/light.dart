import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/ColorPicker/circleColorPicker.dart';
import '../../utils/ColorPicker/colorPickerController.dart';
import '../../utils/Home_Assistant_Connection.dart';
import '../../utils/constants.dart';
import '../../utils/energy_usage_statistics.dart';
import '../../utils/globals.dart';
import '../../utils/widget_functions.dart';

class Light extends StatefulWidget {
  const Light({Key? key}) : super(key: key);

  @override
  LightState createState() => LightState();
}

class LightState extends State<Light> {
  bool toogle = deviceItem!.state == 'on';

  Widget get _dropdownValue => _dropdownItems[_value]!;
  String _value = 'none';
  final Map<String, Widget> _dropdownItems = {
    'none': const SizedBox(
      width: 24,
      height: 24,
    ),
    'colorloop': SvgPicture.asset(
      'assets/colorloop.svg',
      width: 24,
      height: 24,
    ),
  };

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
    onUpdate = () => refresh();
  }

  void refresh() {
    setState(() {
      toogle = deviceItem!.state == 'on';
      _controller.color = Color.fromARGB(
          255,
          (deviceItem!.attributes?.rgbColor?.elementAt(0) ?? 255),
          (deviceItem!.attributes?.rgbColor?.elementAt(1) ?? 0),
          (deviceItem!.attributes?.rgbColor?.elementAt(2) ?? 0));
    });
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
            body: Column(children: [
              Padding(
                padding: const EdgeInsets.only(top: 50.0, bottom: 10),
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 40.0, top: 90.0),
                      child: PopupMenuButton(
                          initialValue: _value,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          itemBuilder: (context) => ['none', 'colorloop']
                              .map(
                                (item) => PopupMenuItem<String>(
                                  value: item,
                                  child: Row(children: [
                                    _dropdownItems[item]!,
                                    addHorizontalSpace(10),
                                    Text(item,
                                        style: const TextStyle(
                                            color: Colors.white))
                                  ]),
                                ),
                              )
                              .toList(),
                          onSelected: (value) {
                            setState(() => _value = value);
                            HomeAssistantConnection().send([
                              '{"id": ${idNumber++}, "type": "call_service", "domain" : "light", "service": "turn_on", "service_data" : {"effect" : "$_value"}, "target" : {"entity_id": "${deviceItem!.entityId}"}}'
                            ]);
                          },
                          color: const Color.fromARGB(255, 82, 82, 93),
                          clipBehavior: Clip.hardEdge,
                          icon: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                  color: Color.fromARGB(100, 145, 145, 145),
                                  shape: BoxShape.circle),
                              child: _dropdownValue)),
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
                        brightness: ValueNotifier(
                            (((deviceItem!.attributes!.brightness != null
                                                ? deviceItem!.attributes!
                                                        .brightness! /
                                                    2.55
                                                : 1) -
                                            1) *
                                        2.32 +
                                    9)
                                .roundToDouble()),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              toogle = !toogle;
                            });
                            HomeAssistantConnection().send([
                              toogle
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
                          child: toogle
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
            ])));
  }
}
