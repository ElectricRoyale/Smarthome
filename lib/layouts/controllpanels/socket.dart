import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smarthome/utils/constants.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../JSON/energy_sensor_data.dart';
import '../../utils/Home_Assistant_Connection.dart';
import '../../utils/globals.dart';

class Socket extends StatefulWidget {
  const Socket({Key? key}) : super(key: key);

  @override
  SocketState createState() => SocketState();
}

class SocketState extends State<Socket> {
  bool toogle = deviceItem!.state == 'on';
  double? energy = 0.7;

  @override
  void initState() {
    super.initState();
    onUpdate = () => refresh();
  }

  void refresh() {
    setState(() {
      toogle = deviceItem!.state == 'on';
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
              padding: const EdgeInsets.only(top: 60.0, bottom: 20.0),
              child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      toogle = !toogle;
                    });
                    HomeAssistantConnection().send([
                      toogle
                          ? '{"id": "${idNumber++}", "type": "call_service", "domain": "switch", "service": "turn_on", "target": {"entity_id": "${deviceItem!.entityId}"}}'
                          : '{"id": "${idNumber++}", "type": "call_service", "domain": "switch", "service": "turn_off", "target": {"entity_id": "${deviceItem!.entityId}"}}'
                    ]);
                  },
                  style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                      primary: const Color(0x25ffffff),
                      onPrimary: const Color(0x25ffffff) // <-- Button color
                      ),
                  child: toogle
                      ? const Icon(
                          Icons.bolt,
                          color: Color.fromARGB(255, 254, 183, 5),
                          size: 60,
                        )
                      : const Icon(
                          Icons.bolt,
                          color: Color.fromARGB(255, 100, 100, 100),
                          size: 60,
                        )),
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
                    dateFormat: DateFormat.E().add_Hm(),
                    majorGridLines: const MajorGridLines(
                        color: Color.fromARGB(90, 145, 145, 145), width: 1),
                    majorTickLines:
                        const MajorTickLines(color: Colors.grey, size: 3),
                    minorTickLines:
                        const MinorTickLines(color: Colors.black12, size: 7),
                  ),
                  annotations: [
                    CartesianChartAnnotation(
                        widget: emptyView(),
                        coordinateUnit: CoordinateUnit.percentage,
                        region: AnnotationRegion.plotArea,
                        y: '50%',
                        x: '50%')
                  ],
                  primaryYAxis: NumericAxis(
                    name: 'Energy Consumption',
                    title: AxisTitle(
                        text: 'kWh',
                        textStyle:
                            const TextStyle(color: Colors.white, fontSize: 10)),
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
                  margin: const EdgeInsets.only(right: 10, left: 5),
                  plotAreaBorderWidth: 2,
                  plotAreaBorderColor: Colors.grey,
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <SplineAreaSeries<EnergySensorData, DateTime>>[
                    SplineAreaSeries(
                        name: 'Energy Consumption',
                        splineType: SplineType.monotonic,
                        dataSource: deviceItem!.energyUsageData,
                        xValueMapper: (data, _) => data.end!,
                        yValueMapper: (data, _) => data.state!,
                        color: const Color.fromARGB(191, 248, 131, 17),
                        borderColor: const Color.fromARGB(255, 254, 183, 5),
                        borderWidth: 2,
                        animationDuration: 3000),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget emptyView() {
    if (deviceItem!.energyUsageData.isEmpty) {
      return const Text(
        "No energy data found!",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Color.fromARGB(55, 255, 255, 255),
            fontSize: 16,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.none),
      );
    } else {
      return Container();
    }
  }
}
