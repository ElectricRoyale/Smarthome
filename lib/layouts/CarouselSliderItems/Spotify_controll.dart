import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:smarthome/JSON/device_data.dart';
import 'package:smarthome/utils/DashboardData.dart';
import 'package:smarthome/utils/Home_Assistant_Connection.dart';
import 'package:smarthome/utils/constants.dart';

import '../../utils/globals.dart';
import '../../utils/scrolling_text.dart';

class SpotifyControllLayout extends StatefulWidget {
  const SpotifyControllLayout({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SpotifyControllLayoutDesign();
}

class SpotifyControllLayoutDesign extends State<SpotifyControllLayout> {
  DeviceData? spotify = DashboardData().getSpotify,
      spotifySubstitute = DashboardData().getSpotifySubstitute;
  String host = Hive.box('Settings').get('host');

  @override
  void initState() {
    super.initState();
    spotifyControllRefresh = () async => setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    spotifyControllRefresh = () async {};
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(5),
        width: double.maxFinite,
        decoration: BoxDecoration(
            color: const Color(0x12ffffff),
            borderRadius: BorderRadius.circular(20.0)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 25.0, bottom: 15.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        spreadRadius: 0,
                        blurRadius: 3,
                      ),
                    ]),
                clipBehavior: Clip.hardEdge,
                child: Image.network(
                  host +
                      (spotify!.attributes!.entityPicture ??
                          spotifySubstitute!.attributes!.entityPicture!),
                  width: 235,
                  height: 235,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 6.0, horizontal: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 70,
                        height: 25,
                        alignment: Alignment.center,
                        child: ScrollingText(
                          (spotify!.attributes!.mediaTitle ?? ' '),
                          maxWidth: MediaQuery.of(context).size.width - 80,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            shadows: [
                              Shadow(
                                offset: Offset(0.0, 2.0),
                                blurRadius: 3.0,
                                color: Color.fromARGB(255, 0, 0, 0),
                              )
                            ],
                            overflow: TextOverflow.ellipsis,
                          ),
                          startAfter: const Duration(seconds: 3),
                          pauseAfterRound: const Duration(seconds: 3),
                          blankSpace: 100,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 80,
                        height: 17,
                        alignment: Alignment.center,
                        child: ScrollingText(
                          (spotify!.attributes!.mediaArtist ?? ' '),
                          maxWidth: MediaQuery.of(context).size.width - 80,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            overflow: TextOverflow.ellipsis,
                          ),
                          startAfter: const Duration(seconds: 3),
                          pauseAfterRound: const Duration(seconds: 3),
                          blankSpace: 100,
                        ),
                      ),
                    ],
                  ),
                  /*InkWell(
                    onTap: () {},
                    child: const Icon(
                      Icons.favorite_border_rounded,
                      color: Colors.white,
                      size: 28,
                      shadows: [
                        Shadow(
                          offset: Offset(0.0, 2.5),
                          blurRadius: 3.0,
                          color: Color.fromARGB(255, 0, 0, 0),
                        )
                      ],
                    ),
                  )*/
                ],
              ),
            ),
            Row(
              children: [
                Container(
                  width: (MediaQuery.of(context).size.width - 10) / 5,
                  height: MediaQuery.of(context).size.height / 10,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: InkWell(
                    onTap: () {
                      HomeAssistantConnection().send([
                        '{"id": ${idNumber++}, "type": "call_service", "domain" : "media_player", "service": "shuffle_set", "service_data" : {"shuffle" : "${!(spotify!.attributes!.shuffle!)}"}, "target" : {"entity_id":"${spotify!.entityId}"}}'
                      ]);
                    },
                    radius: 30,
                    child: Icon(
                      Icons.shuffle,
                      color: spotify!.attributes!.shuffle ?? false
                          ? COLOR_ACCENT
                          : Colors.white,
                      size: 34,
                      shadows: const [
                        Shadow(
                          offset: Offset(0.0, 2.5),
                          blurRadius: 3.0,
                          color: Color.fromARGB(255, 0, 0, 0),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: (MediaQuery.of(context).size.width - 10) / 5,
                  height: 50,
                  child: InkWell(
                    onTap: () {
                      HomeAssistantConnection().send([
                        '{"id": ${idNumber++}, "type": "call_service", "domain" : "media_player", "service": "media_previous_track", "target" : {"entity_id":"${spotify!.entityId}"}}'
                      ]);
                    },
                    radius: 30,
                    child: const Icon(
                      Icons.skip_previous_rounded,
                      color: Colors.white,
                      size: 50,
                      shadows: [
                        Shadow(
                          offset: Offset(0.0, 2.5),
                          blurRadius: 3.0,
                          color: Color.fromARGB(255, 0, 0, 0),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: (MediaQuery.of(context).size.width - 10) / 5,
                  child: InkWell(
                    onTap: () {
                      HomeAssistantConnection().send([
                        '{"id": ${idNumber++}, "type": "call_service", "domain" : "media_player", "service": "media_play_pause", "target" : {"entity_id":"${spotify!.entityId}"}}'
                      ]);
                    },
                    radius: 30,
                    child: Icon(
                      spotify!.state == 'playing'
                          ? Icons.pause_circle_filled_rounded
                          : Icons.play_circle_rounded,
                      color: Colors.white,
                      size: 68,
                      shadows: const [
                        Shadow(
                          offset: Offset(0.0, 2.5),
                          blurRadius: 3.0,
                          color: Color.fromARGB(255, 0, 0, 0),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: (MediaQuery.of(context).size.width - 10) / 5,
                  height: 50,
                  child: InkWell(
                    onTap: () {
                      HomeAssistantConnection().send([
                        '{"id": ${idNumber++}, "type": "call_service", "domain" : "media_player", "service": "media_next_track", "target" : {"entity_id":"${spotify!.entityId}"}}'
                      ]);
                    },
                    radius: 30,
                    child: const Icon(
                      Icons.skip_next_rounded,
                      color: Colors.white,
                      size: 50,
                      shadows: [
                        Shadow(
                          offset: Offset(0.0, 2.5),
                          blurRadius: 3.0,
                          color: Color.fromARGB(255, 0, 0, 0),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: (MediaQuery.of(context).size.width - 10) / 5,
                  height: 34,
                  child: Center(
                    child: PopupMenuButton(
                      itemBuilder: (context) => ['off', 'all', 'one']
                          .map<PopupMenuItem<String>>((item) => PopupMenuItem(
                              value: item,
                              padding: EdgeInsets.zero,
                              child: Center(child: _repeatIcon[item])))
                          .toList(),
                      initialValue: spotify!.attributes!.repeat ?? 'off',
                      onSelected: (item) => HomeAssistantConnection().send([
                        '{"id": ${idNumber++}, "type": "call_service", "domain" : "media_player", "service": "repeat_set", "service_data" : {"repeat": "$item"}, "target" : {"entity_id":"${spotify!.entityId}"}}'
                      ]),
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      color: const Color.fromARGB(255, 51, 54, 68),
                      icon: _repeatIcon[spotify!.attributes!.repeat ?? 'off'],
                      padding: EdgeInsets.zero,
                      clipBehavior: Clip.hardEdge,
                      constraints:
                          const BoxConstraints(minWidth: 45.0, maxWidth: 45.0),
                    ),
                  ),
                )
              ],
            )
          ],
        ));
  }

  final Map<String, Widget> _repeatIcon = {
    'off': const Icon(
      Icons.repeat_rounded,
      color: Colors.white,
      size: 34,
      shadows: [
        Shadow(
          offset: Offset(0.0, 2.5),
          blurRadius: 3.0,
          color: Color.fromARGB(255, 0, 0, 0),
        )
      ],
    ),
    'all': const Icon(
      Icons.repeat_rounded,
      color: COLOR_ACCENT,
      size: 34,
      shadows: [
        Shadow(
          offset: Offset(0.0, 2.5),
          blurRadius: 3.0,
          color: Color.fromARGB(255, 0, 0, 0),
        )
      ],
    ),
    'one': const Icon(
      Icons.repeat_one_rounded,
      color: COLOR_ACCENT,
      size: 34,
      shadows: [
        Shadow(
          offset: Offset(0.0, 2.5),
          blurRadius: 3.0,
          color: Color.fromARGB(255, 0, 0, 0),
        )
      ],
    )
  };
}
