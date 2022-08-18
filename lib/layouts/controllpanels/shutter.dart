import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:smarthome/utils/Home_Assistant_Connection.dart';
import 'package:smarthome/utils/constants.dart';
import 'package:smarthome/utils/globals.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

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
                                '{"id": "${idNumber++}", "type": "call_service", "domain": "cover", "service": "open_cover", "target": {"entity_id": "$entity_id"}}'
                              ]);
                              break;
                            case 2:
                              HomeAssistantConnection().send([
                                '{"id": "${idNumber++}", "type": "call_service", "domain": "cover", "service": "stop_cover", "target": {"entity_id": "$entity_id"}}'
                              ]);
                              break;
                            case 3:
                              HomeAssistantConnection().send([
                                '{"id": "${idNumber++}", "type": "call_service", "domain": "cover", "service": "close_cover", "target": {"entity_id": "$entity_id"}}'
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
                              value: postion,
                              onChanged: (double value) => setState(() {
                                postion = value.roundToDouble();
                              }),
                              onChangeEnd: (double value) =>
                                  HomeAssistantConnection().send([
                                '{"id": "${idNumber++}", "type": "call_service", "domain" : "cover", "service": "set_cover_position", "service_data" : {"position" : "${100 - value.round()}"}, "target" : {"entity_id": "$entity_id"}}'
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
            SfSparkLineChart(
              dashArray: const [
                1.0,
                5.0,
                3.0,
                10.0,
                4.0,
                4.0,
                2.0,
                7.0,
                8.0,
                6.0
              ],
              axisLineDashArray: const [
                1.0,
                2.0,
                3.0,
                4.0,
                5.0,
                6.0,
                7.0,
                8.0,
                9.0,
                10.0
              ],
            ),
          ],
        ),
      ),
    );
  }
}
