import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smarthome/JSON/device_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../JSON/energy_sensor_data.dart';
import '../generated/l10n.dart';

class EnergyUsageStatistics extends StatelessWidget {
  final DeviceData? data;
  final EdgeInsetsGeometry padding;
  const EnergyUsageStatistics(
      {Key? key, required this.data, this.padding = EdgeInsets.zero})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final delegate = S.of(context);
    return Padding(
      padding: padding,
      child: SizedBox(
        height: 175,
        child: SfCartesianChart(
          primaryXAxis: DateTimeAxis(
            name: delegate.energystatisticsAxisLableX,
            labelStyle: const TextStyle(color: Colors.white),
            intervalType: DateTimeIntervalType.hours,
            dateFormat: DateFormat.E().add_Hm(),
            majorGridLines: const MajorGridLines(
                color: Color.fromARGB(90, 145, 145, 145), width: 1),
            majorTickLines: const MajorTickLines(color: Colors.grey, size: 3),
            minorTickLines:
                const MinorTickLines(color: Colors.black12, size: 7),
          ),
          annotations: [
            CartesianChartAnnotation(
                widget: emptyView(context),
                coordinateUnit: CoordinateUnit.percentage,
                region: AnnotationRegion.plotArea,
                y: '50%',
                x: '50%')
          ],
          primaryYAxis: NumericAxis(
            name: delegate.energystatisticsAxisLableY,
            title: AxisTitle(
                text: 'kWh',
                textStyle: const TextStyle(color: Colors.white, fontSize: 10)),
            labelStyle: const TextStyle(color: Colors.white),
            majorGridLines: const MajorGridLines(
                color: Color.fromARGB(90, 145, 145, 145), width: 1),
            majorTickLines: const MajorTickLines(color: Colors.grey, size: 3),
            minorTickLines:
                const MinorTickLines(color: Colors.black12, size: 7),
          ),
          zoomPanBehavior: ZoomPanBehavior(
              enablePanning: true, enablePinching: true, zoomMode: ZoomMode.x),
          margin: const EdgeInsets.only(right: 10, left: 5),
          plotAreaBorderWidth: 2,
          plotAreaBorderColor: Colors.grey,
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <SplineAreaSeries<EnergySensorData, DateTime>>[
            SplineAreaSeries(
                name: delegate.energystatisticsAxisLableLine,
                splineType: SplineType.monotonic,
                dataSource: data?.energyUsageData ?? [],
                xValueMapper: (data, _) => data.end!,
                yValueMapper: (data, _) => data.state!,
                color: const Color.fromARGB(191, 248, 131, 17),
                borderColor: const Color.fromARGB(255, 254, 183, 5),
                borderWidth: 2,
                animationDuration: 3000),
          ],
        ),
      ),
    );
  }

  Widget emptyView(BuildContext context) {
    if (data != null && data!.energyUsageData.isEmpty) {
      return Text(
        S.of(context).energystatisticsEmpty,
        textAlign: TextAlign.center,
        style: const TextStyle(
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
