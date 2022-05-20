import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smarthome/layouts/Dashboard.dart';
import 'package:smarthome/my_icons_icons.dart';

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
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xff3A64FA),
                        Color(0xff000667),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.only(top: 20, left: 20),
                  height: 64,
                  width: 64,
                  child: SvgPicture.asset("assets/${roomItem['icon']}",
                      color: Colors.white),
                ),
                Container(
                    margin: const EdgeInsets.only(left: 20, top: 20),
                    child: Text(
                      "${roomItem['name']}",
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 24),
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
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [Color(0xff00C385), Color(0xff44FF00)]),
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
                      ),
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
