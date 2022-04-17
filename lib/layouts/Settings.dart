import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => Settingslayout();
}

class Settingslayout extends State<Settings> {

  final List<Widget> _settings = [
    Container(
      decoration: const BoxDecoration(
        color: Color(0x12ffffff),
      ),
      child: Row(
        children: const [
          //Image.memory(),
        ],
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView.separated(
        separatorBuilder: (context, index) => const Divider(
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