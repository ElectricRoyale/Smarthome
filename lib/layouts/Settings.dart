import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => Settingslayout();
}

class Settingslayout extends State<Settings> {

  List<Widget> _settings = [
    Container(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView.separated(
        separatorBuilder: (context, index) => Divider(
          color: Colors.white,
          indent: 10,
          endIndent: 10,
          thickness: 1.1,
        ),
        itemCount: _settings.length,
        itemBuilder: (context, index) => Container(child: _settings.elementAt(index),),
      ),
    );
  }
}