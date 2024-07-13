import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:smarthome/utils/globals.dart';

import '../JSON/device_data.dart';
import '../generated/l10n.dart';
import '../utils/constants.dart';
import '../utils/scrolling_text.dart';

class OverViewPage extends StatefulWidget {
  final String name, groupName;
  final List<DeviceData> deviceData;

  const OverViewPage(this.deviceData,
      {Key? key, required this.name, required this.groupName})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => OverViewPageState();
}

class OverViewPageState extends State<OverViewPage> {
  double opacity = 0.0;

  @override
  void initState() {
    super.initState();
    onUpdate = () => setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.sizeOf(context);
    if (widget.deviceData.isNotEmpty) {
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
              style: TextStyle(
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    offset: Offset(0.0, screenSize.height * 0.0027),
                    blurRadius: 3.0,
                    color: const Color.fromARGB(255, 0, 0, 0),
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
                maxCrossAxisExtent: screenSize.width / 2,
                childAspectRatio: 3.25 / 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15),
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 20),
            itemCount: widget.deviceData.length,
            itemBuilder: (ctx, index) => InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () {
                deviceItem = widget.deviceData.elementAt(index);
                Navigator.pushNamed(
                        context,
                        widget.deviceData.elementAt(index).entityId!.substring(
                            0,
                            widget.deviceData
                                .elementAt(index)
                                .entityId!
                                .indexOf('.')))
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
                        padding: EdgeInsets.all(screenSize.width * 0.0243),
                        child: SimpleShadow(
                          opacity: 0.6,
                          offset: Offset(0, screenSize.height * 0.0021875),
                          child: SvgPicture.asset(
                            'assets/${widget.deviceData.elementAt(index).icon}',
                            fit: BoxFit.scaleDown,
                            height: screenSize.width * 0.1215,
                            width: screenSize.width * 0.1215,
                            colorFilter:
                                widget.deviceData.elementAt(index).state ==
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
                        widget.deviceData
                            .elementAt(index)
                            .attributes!
                            .friendlyName!,
                        textScaleFactor: 1.09,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                          shadows: [
                            Shadow(
                              offset: Offset(0.0, screenSize.height * 0.0027),
                              blurRadius: 3.0,
                              color: const Color.fromARGB(255, 0, 0, 0),
                            )
                          ],
                        ),
                        fadingEdgeStartFraction: 0.1,
                        fadingEdgeEndFraction: 0.1,
                        startAfter: const Duration(seconds: 3),
                        pauseAfterRound: const Duration(seconds: 3),
                        blankSpace: 100,
                        margin: EdgeInsets.only(
                            top: screenSize.height * 0.00328,
                            left: screenSize.width * 0.0243,
                            right: screenSize.width * 0.0243),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(left: screenSize.width * 0.0243),
                        child: Text(
                          widget.deviceData.elementAt(index).state !=
                                  'unavailable'
                              ? double.tryParse(widget.deviceData
                                          .elementAt(index)
                                          .energy) !=
                                      null
                                  ? double.parse(widget.deviceData
                                              .elementAt(index)
                                              .energy)
                                          .toStringAsPrecision(2) +
                                      S.of(context).devicegridUsage
                                  : ''
                              : S.of(context).unavailable,
                          textScaleFactor: 0.85,
                          style: TextStyle(
                              color: widget.deviceData.elementAt(index).state !=
                                      'unavailable'
                                  ? Colors.grey
                                  : Colors.red,
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
              textScaleFactor: 1.15,
              style: const TextStyle(
                  color: Color.fromARGB(55, 255, 255, 255),
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none),
            ),
          ),
        ),
      ),
    );
  }
}
