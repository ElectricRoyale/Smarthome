import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smarthome/utils/constants.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

import '../../utils/color_picker_wheel.dart';

class Light extends StatefulWidget {
  const Light({Key? key}) : super(key: key);

  @override
  LightState createState() => LightState();
}

class LightState extends State<Light> {
  bool toogle = false;

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
                child: Stack(alignment: Alignment.center, children: [
                  ColorPicker(
                    width: 35.0,
                    onSelectionChange: (newValue, endValue) => {setState},
                    selectionColor: Colors.white,
                    init: 0,
                    baseColor: Colors.white,
                    end: 100,
                    intervals: 1,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        toogle = !toogle;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(20),
                        primary: const Color(0x25ffffff),
                        onPrimary: const Color(0x25ffffff) // <-- Button color
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
                ])),
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
