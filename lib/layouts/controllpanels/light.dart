import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:smarthome/utils/Home_Assistant_Connection.dart';
import 'package:smarthome/utils/constants.dart';
import 'package:smarthome/utils/widget_functions.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../utils/ColorPicker/circleColorPicker.dart';
import '../../utils/ColorPicker/colorPickerController.dart';
import '../../utils/globals.dart';

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
            Padding(
              padding: const EdgeInsets.only(top: 50.0, bottom: 10),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0, top: 90.0),
                    child: DropdownButtonHideUnderline(
                        child: Theme(
                      data: Theme.of(context).copyWith(
                        canvasColor: const Color.fromARGB(255, 145, 145, 145),
                      ),
                      child: DropdownButton2<String>(
                          value: _value,
                          customButton: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                  color: Color.fromARGB(100, 145, 145, 145),
                                  shape: BoxShape.circle),
                              child: _dropdownValue),
                          dropdownWidth: 145,
                          isExpanded: false,
                          items: <String>['none', 'colorloop']
                              .map<DropdownMenuItem<String>>(
                                (item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Row(children: [
                                    _dropdownItems[item]!,
                                    addHorizontalSpace(10),
                                    Text(item)
                                  ]),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() => _value = value!);
                            HomeAssistantConnection().send([
                              '{"id": "${idNumber++}", "type": "call_service", "domain" : "light", "service": "turn_on", "service_data" : {"effect" : "$_value"}, "target" : {"entity_id": "${deviceItem!.entityId}"}}'
                            ]);
                          }),
                    )),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: CircleColorPicker(
                      controller: _controller,
                      onChanged: (color) => setState(() {}),
                      onEnded: (color) {
                        HomeAssistantConnection().send([
                          '{"id": "${idNumber++}", "type": "call_service", "domain" : "light", "service": "turn_on", "service_data" : {"rgb_color" : [${color.red},${color.green},${color.blue}]}, "target" : {"entity_id": "${deviceItem!.entityId}"}}'
                        ]);
                        deviceItem!.attributes!.rgbColor = [
                          color.red,
                          color.green,
                          color.blue
                        ];
                      },
                      brightness: ValueNotifier(
                          (((deviceItem!.attributes!.brightness != null
                                              ? deviceItem!
                                                      .attributes!.brightness! /
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
                                ? '{"id": "${idNumber++}", "type": "call_service", "domain": "light", "service": "turn_on", "target": {"entity_id": "${deviceItem!.entityId}"}}'
                                : '{"id": "${idNumber++}", "type": "call_service", "domain": "light", "service": "turn_off", "target": {"entity_id": "${deviceItem!.entityId}"}}'
                          ]);
                        },
                        style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(20),
                            primary: const Color(0x25ffffff),
                            onPrimary:
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
            Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: SizedBox(
                height: 175,
                child: SfCartesianChart(
                  primaryXAxis: DateTimeAxis(
                    name: 'Time',
                    labelStyle: const TextStyle(color: Colors.white),
                    intervalType: DateTimeIntervalType.hours,
                    dateFormat: DateFormat.Hm(),
                    majorGridLines: const MajorGridLines(
                        color: Color.fromARGB(90, 145, 145, 145), width: 1),
                    majorTickLines:
                        const MajorTickLines(color: Colors.grey, size: 3),
                    minorTickLines:
                        const MinorTickLines(color: Colors.black12, size: 7),
                  ),
                  primaryYAxis: NumericAxis(
                    name: 'Energy Consumption',
                    labelStyle: const TextStyle(color: Colors.white),
                    majorGridLines: const MajorGridLines(
                        color: Color.fromARGB(90, 145, 145, 145), width: 1),
                    majorTickLines:
                        const MajorTickLines(color: Colors.grey, size: 3),
                    minorTickLines:
                        const MinorTickLines(color: Colors.black12, size: 7),
                  ),
                  zoomPanBehavior: ZoomPanBehavior(
                      enablePanning: true,
                      enablePinching: true,
                      zoomMode: ZoomMode.x),
                  margin: const EdgeInsets.only(right: 25, left: 5),
                  enableAxisAnimation: true,
                  plotAreaBorderWidth: 2,
                  plotAreaBorderColor: Colors.grey,
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <SplineAreaSeries<EnergyData, DateTime>>[
                    SplineAreaSeries(
                      name: 'Energy Consumption',
                      splineType: SplineType.monotonic,
                      dataSource: <EnergyData>[
                        EnergyData(
                            DateTime.parse('2022-08-25T00:00:00.000'), 0.0),
                        EnergyData(
                            DateTime.parse('2022-08-25T01:00:00.000'), 0.0),
                        EnergyData(
                            DateTime.parse('2022-08-25T02:00:00.000'), 0.0),
                        EnergyData(
                            DateTime.parse('2022-08-25T03:00:00.000'), 0.02),
                        EnergyData(
                            DateTime.parse('2022-08-25T04:00:00.000'), 0.02),
                        EnergyData(
                            DateTime.parse('2022-08-25T05:00:00.000'), 0.02),
                        EnergyData(
                            DateTime.parse('2022-08-25T06:00:00.000'), 0.02),
                      ],
                      xValueMapper: (data, _) => data.time,
                      yValueMapper: (data, _) => data.energy,
                      color: const Color.fromARGB(191, 248, 131, 17),
                      borderColor: const Color.fromARGB(255, 254, 183, 5),
                      borderWidth: 2,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
