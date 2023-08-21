import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:smarthome/utils/globals.dart';

import '../JSON/device_data.dart';
import '../generated/l10n.dart';
import '../utils/constants.dart';
import '../utils/dashboard_data.dart';
import '../utils/scrolling_text.dart';

class OverViewPage extends StatefulWidget {
  final String name, groupName;

  const OverViewPage({Key? key, required this.name, required this.groupName})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => OverViewPageState();
}

class OverViewPageState extends State<OverViewPage> {
  List<DeviceData> deviceData = [];
  double opacity = 0.0;

  @override
  void initState() {
    super.initState();
    deviceData.addAll(DashboardData().categoryMap[widget.groupName]!);
    onUpdate = () => setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (deviceData.isNotEmpty) {
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
          appBar: AppBar(
            title: Text(
              widget.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    offset: Offset(0.0, 2.5),
                    blurRadius: 3.0,
                    color: Color.fromARGB(255, 0, 0, 0),
                  )
                ],
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            centerTitle: true,
          ),
          backgroundColor: Colors.transparent,
          body: GridView.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: MediaQuery.of(context).size.width / 2,
                childAspectRatio: 3.25 / 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15),
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 20),
            itemCount: deviceData.length,
            itemBuilder: (ctx, index) => InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () {
                deviceItem = deviceData.elementAt(index);
                Navigator.pushNamed(
                        context,
                        deviceData.elementAt(index).entityId!.substring(0,
                            deviceData.elementAt(index).entityId!.indexOf('.')))
                    .then((value) {
                  onUpdate = () => setState(() {});
                  setState(() {});
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0x12ffffff),
                  borderRadius: BorderRadius.circular(15),
                ),
                clipBehavior: Clip.hardEdge,
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SimpleShadow(
                          opacity: 0.6,
                          offset: const Offset(0, 2),
                          child: SvgPicture.asset(
                            'assets/${deviceData.elementAt(index).icon}',
                            fit: BoxFit.scaleDown,
                            height: 50,
                            width: 50,
                            colorFilter: deviceData.elementAt(index).state ==
                                    'unavailable'
                                ? const ColorFilter.mode(
                                    Color.fromARGB(255, 80, 80, 80),
                                    BlendMode.srcIn)
                                : null,
                          ),
                        ),
                      ),
                      ScrollingText(
                        velocity: 30,
                        deviceData.elementAt(index).attributes!.friendlyName!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                          shadows: [
                            Shadow(
                              offset: Offset(0.0, 2.5),
                              blurRadius: 3.0,
                              color: Color.fromARGB(255, 0, 0, 0),
                            )
                          ],
                        ),
                        fadingEdgeStartFraction: 0.1,
                        fadingEdgeEndFraction: 0.1,
                        startAfter: const Duration(seconds: 3),
                        pauseAfterRound: const Duration(seconds: 3),
                        blankSpace: 100,
                        margin:
                            const EdgeInsets.only(top: 3, left: 10, right: 10),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          deviceData.elementAt(index).state != 'unavailable'
                              ? double.tryParse(
                                          deviceData.elementAt(index).energy) !=
                                      null
                                  ? double.parse(deviceData
                                              .elementAt(index)
                                              .energy)
                                          .toStringAsPrecision(2) +
                                      S.of(context).devicegridUsage
                                  : ''
                              : S.of(context).unavailable,
                          style: TextStyle(
                              color: deviceData.elementAt(index).state !=
                                      'unavailable'
                                  ? Colors.grey
                                  : Colors.red,
                              fontSize: 12,
                              decoration: TextDecoration.none),
                          maxLines: 1,
                        ),
                      ),
                    ]),
              ),
            ),
          ),
        ),
      );
    } else {
      Future.delayed(
          const Duration(milliseconds: 200),
          () => setState(() {
                opacity = 1.0;
              }));
      return emptyGrid();
    }
  }

  Container emptyGrid() {
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
        appBar: AppBar(
          title: Text(
            widget.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
        ),
        backgroundColor: Colors.transparent,
        body: Center(
          child: AnimatedOpacity(
            duration: const Duration(seconds: 2),
            opacity: opacity,
            child: Text(
              S.of(context).noDevicesAvailable,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Color.fromARGB(55, 255, 255, 255),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none),
            ),
          ),
        ),
      ),
    );
  }
}
