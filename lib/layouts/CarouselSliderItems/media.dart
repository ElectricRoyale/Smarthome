import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../../utils/globals.dart';
import '../../utils/scrolling_text.dart';

class MediaLayout extends StatefulWidget {
  const MediaLayout({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MediaLayoutDesign();
}

class MediaLayoutDesign extends State<MediaLayout> {
  List mediaList = ['2021', '2022', '2023'];

  @override
  void initState() {
    super.initState();
    mediaRefresh = () async => setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    mediaRefresh = () async {};
  }

  @override
  Widget build(BuildContext context) {
    final delegate = S.of(context);
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: const Color(0x12ffffff),
          borderRadius: BorderRadius.circular(20.0)),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: MediaQuery.of(context).size.width / 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15),
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount: mediaList.length,
        itemBuilder: (ctx, index) => InkWell(
          onTap: () {},
          child: Stack(alignment: Alignment.topCenter, children: [
            const Icon(
              Icons.folder,
              size: 120,
              color: Color.fromARGB(255, 102, 102, 122),
            ),
            Positioned(
              bottom: 2,
              child: Container(
                width: (MediaQuery.of(context).size.width / 2 - 40),
                height: 22,
                alignment: Alignment.center,
                child: ScrollingText(
                  mediaList.elementAt(index),
                  velocity: 30,
                  maxWidth: (MediaQuery.of(context).size.width / 2 - 40),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
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
                  startAfter: const Duration(seconds: 3),
                  pauseAfterRound: const Duration(seconds: 3),
                  blankSpace: 100,
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
