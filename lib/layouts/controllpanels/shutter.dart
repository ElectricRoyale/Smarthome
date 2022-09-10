import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:smarthome/utils/Home_Assistant_Connection.dart';
import 'package:smarthome/utils/constants.dart';
import 'package:smarthome/utils/globals.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Shutter extends StatefulWidget {
  const Shutter({Key? key}) : super(key: key);

  @override
  ShutterState createState() => ShutterState();
}

class ShutterState extends State<Shutter> {
  int selected = 2;

  @override
  void initState() {
    super.initState();
    onUpdate = () => refresh();
  }

  void refresh() {
    setState(() {
      selected =
          deviceItem!.state == 'opening' || deviceItem!.state == 'closing'
              ? deviceItem!.state == 'opening'
                  ? 1
                  : 3
              : 2;
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
              padding: const EdgeInsets.only(top: 50.0, bottom: 20),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    RotatedBox(
                      quarterTurns: 1,
                      child: AnimatedToggleSwitch<int>.size(
                        current: selected,
                        values: const [1, 2, 3],
                        iconOpacity: 1,
                        indicatorSize: const Size.fromWidth(100),
                        height: 65,
                        iconAnimationType: AnimationType.onHover,
                        indicatorAnimationType: AnimationType.onHover,
                        iconBuilder: (value, size) {
                          IconData data = Icons.error;
                          switch (value) {
                            case 1:
                              data = Icons.arrow_back;
                              break;
                            case 2:
                              data = Icons.stop;
                              break;
                            case 3:
                              data = Icons.arrow_forward;
                              break;
                          }
                          return Icon(
                            data,
                            size: 40,
                            color: Colors.white,
                          );
                        },
                        borderWidth: 0.0,
                        borderColor: Colors.transparent,
                        innerColor: const Color(0x12ffffff),
                        colorBuilder: (i) =>
                            i.isEven ? Colors.red : Colors.green,
                        onChanged: (index) {
                          setState(() => selected = index);
                          switch (index) {
                            case 1:
                              HomeAssistantConnection().send([
                                '{"id": "${idNumber++}", "type": "call_service", "domain": "cover", "service": "open_cover", "target": {"entity_id": "${deviceItem!.entityId}"}}'
                              ]);
                              break;
                            case 2:
                              HomeAssistantConnection().send([
                                '{"id": "${idNumber++}", "type": "call_service", "domain": "cover", "service": "stop_cover", "target": {"entity_id": "${deviceItem!.entityId}"}}'
                              ]);
                              break;
                            case 3:
                              HomeAssistantConnection().send([
                                '{"id": "${idNumber++}", "type": "call_service", "domain": "cover", "service": "close_cover", "target": {"entity_id": "${deviceItem!.entityId}"}}'
                              ]);
                              break;
                          }
                        },
                      ),
                    ),
                    RotatedBox(
                        quarterTurns: 1,
                        child: SliderTheme(
                            data: const SliderThemeData(),
                            child: Slider(
                              max: 100.0,
                              value: 100 -
                                  deviceItem!.attributes!.currentPosition!
                                      .toDouble(),
                              onChanged: (double value) => setState(() {
                                deviceItem!.attributes!.currentPosition =
                                    100 - value.round();
                              }),
                              onChangeEnd: (double value) =>
                                  HomeAssistantConnection().send([
                                '{"id": "${idNumber++}", "type": "call_service", "domain" : "cover", "service": "set_cover_position", "service_data" : {"position" : "${100 - value.round()}"}, "target" : {"entity_id": "${deviceItem!.entityId}"}}'
                              ]),
                            ))),
                  ]),
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
                        splineType: SplineType.clamped,
                        dataSource: <EnergyData>[
                          EnergyData(DateTime(2022, 08, 25, 01), 0.0),
                          EnergyData(DateTime(2022, 08, 25, 02), 0.0),
                          EnergyData(DateTime(2022, 08, 25, 03), 0.0),
                          EnergyData(DateTime(2022, 08, 25, 04), 0.0),
                          EnergyData(DateTime(2022, 08, 25, 05), 0.2),
                          EnergyData(DateTime(2022, 08, 25, 06), 0.5),
                          EnergyData(DateTime(2022, 08, 25, 07), 0.4),
                        ],
                        xValueMapper: (data, _) => data.time,
                        yValueMapper: (data, _) => data.energy,
                        color: const Color.fromARGB(191, 248, 131, 17),
                        borderColor: const Color.fromARGB(255, 254, 183, 5),
                        borderWidth: 2,
                        animationDuration: 10),
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
