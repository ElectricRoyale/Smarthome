import 'package:flutter/material.dart';
import 'package:smarthome/utils/constants.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

import '../../utils/globals.dart';
import '../unavailable_dialog.dart';

class HeatingSystem extends StatefulWidget {
  const HeatingSystem({Key? key}) : super(key: key);

  @override
  HeatingSystemState createState() => HeatingSystemState();
}

class HeatingSystemState extends State<HeatingSystem> {
  int selected = 2;

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
