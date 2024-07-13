import 'package:flutter/material.dart';
import 'package:smarthome/utils/constants.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

import '../../utils/globals.dart';

class Irrigation extends StatefulWidget {
  const Irrigation({Key? key}) : super(key: key);

  @override
  IrrigationState createState() => IrrigationState();
}

class IrrigationState extends State<Irrigation> {
  int selected = 2;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      checkAvailability(context);
    });
  }

  @override
  void dispose() {
    super.dispose();
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
        body: Column(
          children: [
            Divider(
              height: screenSize.height * 0.021875,
              thickness: screenSize.height * 0.0021875,
              indent: screenSize.width * 0.02431,
              endIndent: screenSize.width * 0.02431,
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
