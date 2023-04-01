import 'package:flutter/material.dart';

import '../../utils/globals.dart';

class MediaLayout extends StatefulWidget {
  const MediaLayout({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MediaLayoutDesign();
}

class MediaLayoutDesign extends State<MediaLayout> {
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
    return Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: const Color(0x12ffffff),
            borderRadius: BorderRadius.circular(20.0)),
        child: ListView());
  }
}
