import 'package:flutter/material.dart';

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
    Size screenSize = MediaQuery.sizeOf(context);
    return Container(
      margin: EdgeInsets.all(screenSize.width * 0.01215),
      decoration: BoxDecoration(
          color: const Color(0x12ffffff),
          borderRadius: BorderRadius.circular(20.0)),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: MediaQuery.of(context).size.width / 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: screenSize.width * 0.0364583,
            mainAxisSpacing: screenSize.height * 0.016406),
        padding: EdgeInsets.symmetric(
            vertical: screenSize.height * 0.01093,
            horizontal: screenSize.width * 0.024305),
        itemCount: mediaList.length,
        itemBuilder: (ctx, index) => InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {},
          child: Stack(alignment: Alignment.topCenter, children: [
            Positioned(
              top: -screenSize.height * 0.01093,
              child: const Icon(
                Icons.folder,
                size: 120,
                color: Color.fromARGB(255, 102, 102, 122),
              ),
            ),
            Positioned(
              bottom: screenSize.height * 0.005468,
              child: Container(
                width: screenSize.width * 0.4027777,
                height: screenSize.height * 0.0240625,
                alignment: Alignment.center,
                child: ScrollingText(
                  mediaList.elementAt(index),
                  velocity: 30,
                  //#Todo: change fontSize to textScaleFactor.
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
                  crossAxisAlignment: CrossAxisAlignment.center,
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
