import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smarthome/Model/UserData.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => Settingslayout();
}

class Settingslayout extends State<Settings>{

  Image _profileImage = Image.asset('assets/person.png');
  String _name = 'Unknown', _email = 'Unknown', _birthday = 'Unknown', _handynumber = 'Unknown', _address = 'Unknown';

  void setData () async {
    var userData = Hive.box<UserData>('UserData');
    var test = userData.values;
    print(test);
    /*setState(() {
      //_profileImage;
      _name = userData.;
      _email = userData.get('Email');
    });
    _birthday = userData.get('Birthday');
    _handynumber = userData.get('HandyNumber');
    _address = userData.get('Address');*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color(0x12ffffff),
            ),
            child: Row(
              children: [
                _profileImage,
                Column(
                  children: [
                    Text(_name, style: const TextStyle(color: Colors.white),),
                    Text(_email, style: const TextStyle(color: Colors.white),),
                  ],
                ),
                IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_forward_ios, size: 10,)),
              ],
            ),
          ),
        ],
      )
    );
  }

  @override
  void initState() {
    setData();
    super.initState();
  }
}