import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smarthome/layouts/dashboard.dart';
import 'package:smarthome/my_icons_icons.dart';
import 'package:smarthome/utils/constants.dart';
import 'package:smarthome/utils/scrolling_text.dart';

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
        margin: const EdgeInsets.only(right: 10.0),
        width: width * 0.72,
        decoration: BoxDecoration(
            color: const Color(0x12ffffff),
            borderRadius: BorderRadius.circular(20.0)),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: BackgroundRoomMap[roomItem['icon']]!.first,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xff282828),
                          blurRadius: 2,
                          offset: Offset(1, 2),
                        )
                      ]),
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.only(top: 20, left: 20),
                  height: 64,
                  width: 64,
                  child: SvgPicture.asset("assets/${roomItem['icon']}",
                      colorFilter: const ColorFilter.mode(
                          Colors.white, BlendMode.srcIn)),
                ),
                Container(
                    width: width * 0.425,
                    height: 30,
                    margin: const EdgeInsets.only(left: 20, top: 20),
                    child: ScrollingText(
                      roomItem['name'],
                      maxWidth: width * 0.425,
                      velocity: 30,
                      startPointOffset: 1,
                      blankSpace: 100,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 24),
                      startAfter: const Duration(seconds: 3),
                      pauseAfterRound: const Duration(seconds: 3),
                    )),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
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
                                colors:
                                    BackgroundRoomMap[roomItem['icon']]!.last),
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(4),
                          margin: const EdgeInsets.only(
                              left: 20, top: 15, bottom: 15),
                          child: const Icon(
                            MyIcons.lightning,
                            color: Colors.white,
                          )),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                          "${roomItem['energyConsumption']}",
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
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
                      margin:
                          const EdgeInsets.only(right: 20, top: 14, bottom: 14),
                      child: const Icon(
                        Icons.power_settings_new,
                        color: Colors.white,
                        size: 28,
                      )),
                ),
              ],
            )
          ],
        ),
      );
    } else {
      return Container(
        width: width * 0.27,
        margin: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
            color: const Color(0x12ffffff),
            borderRadius: BorderRadius.circular(20.0)),
        child: IconButton(
          onPressed: layout.addItem,
          icon: const Icon(
            Icons.add_circle_outline_rounded,
            color: Colors.white,
            size: 55,
          ),
        ),
      );
    }
  }
}
