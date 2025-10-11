import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/icon_map.dart';
import 'package:smarthome/layouts/dashboard.dart';
import 'package:smarthome/my_icons_icons.dart';
import 'package:smarthome/utils/constants.dart';
import 'package:smarthome/utils/scrolling_text.dart';

import 'overview_page.dart';

class RoomItem extends StatelessWidget {
  final dynamic roomItem;
  final double width, height;
  final Layout layout;

  const RoomItem(
      {Key? key,
      required this.layout,
      required this.roomItem,
      required this.width,
      required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (roomItem['name'] != 'add') {
      return Container(
        margin: EdgeInsets.only(right: width * 0.02431),
        width: width * 0.72,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
            color: const Color(0x12ffffff),
            borderRadius: BorderRadius.circular(20.0)),
        child: InkWell(
          borderRadius: BorderRadius.circular(20.0),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OverViewPage(
                roomItem['appliancesList'],
                name: roomItem['name'],
                groupName: roomItem['name'],
              ),
              settings: const RouteSettings(name: 'overviewpage'),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: BackgroundRoomMap[(roomItem['aliases'] as List).first]!.first,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xff282828),
                            blurRadius: 2,
                            offset: Offset(1, 2),
                          )
                        ]),
                    padding: EdgeInsets.all(width * 0.012153),
                    margin: EdgeInsets.only(
                        top: height * 0.02692, left: width * 0.0486),
                    height: width * 0.1555,
                    width: width * 0.1555,
                    child: Icon(iconMap[convertToCamelCase(roomItem['icon'])], size: 48,),
                  ),
                  Container(
                      width: width * 0.425,
                      height: height * 0.0403774,
                      margin: EdgeInsets.only(
                          top: height * 0.02692, left: width * 0.0486),
                      child: ScrollingText(
                        roomItem['name'],
                        velocity: 30,
                        blankSpace: 100,
                        textScaleFactor: 1.7,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                        startAfter: const Duration(seconds: 3),
                        pauseAfterRound: const Duration(seconds: 3),
                      )),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: width * 0.0486,
                    right: width * 0.0486,
                    top: height * 0.0201887),
                child: Row(
                  children: roomItem['appliances'],
                ),
              ),
              Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: BackgroundRoomMap[(roomItem['aliases'] as List).first]!
                                      .last),
                              shape: BoxShape.circle,
                            ),
                            padding: EdgeInsets.all(width * 0.0097222),
                            margin: EdgeInsets.only(
                                left: width * 0.0486,
                                top: height * 0.0201887,
                                bottom: height * 0.0201887),
                            child: const Icon(
                              MyIcons.lightning,
                              color: Colors.white,
                            )),
                        Padding(
                          padding: EdgeInsets.only(left: width * 0.03646),
                          child: Text(
                            "${roomItem['energyConsumption']}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  /*Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white,
                                  Color(0xffFFD500),
                                  Color(0xffFFB700)
                                ]),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xff282828),
                                blurRadius: 4,
                                offset: Offset(1, 2),
                              )
                            ]),
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.only(
                            right: 20, top: 14, bottom: 14),
                        child: const Icon(
                          Icons.power_settings_new,
                          color: Colors.white,
                          size: 28,
                        )),
                  ),*/
                ],
              )
            ],
          ),
        ),
      );
    } else {
      return Container(
        width: width * 0.27,
        margin: EdgeInsets.symmetric(vertical: height * 0.026918245),
        decoration: BoxDecoration(
            color: const Color(0x12ffffff),
            borderRadius: BorderRadius.circular(20.0)),
        child: IconButton(
          onPressed: layout.addItem,
          iconSize: width * 0.133681,
          icon: const Icon(
            Icons.add_circle_outline_rounded,
            color: Colors.white,
          ),
        ),
      );
    }
  }
}

String convertToCamelCase(String text) {
  // Check and remove the 'mdi:' prefix if present
  String cleanText = text.startsWith('mdi:') ? text.substring(4) : text;

  // Split the string by '-' and iterate over the parts
  return cleanText.split('-').asMap().map((index, part) {
    // For each part after the first, capitalize the first letter
    if (index > 0) {
      return MapEntry(index, part[0].toUpperCase() + part.substring(1));
    }
    // Keep the first part as is
    return MapEntry(index, part);
  }).values.join(); // Join the parts back together
}