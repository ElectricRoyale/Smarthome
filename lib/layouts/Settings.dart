import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smarthome/Model/UserData.dart';
import 'package:smarthome/layouts/AccountPage.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => Settingslayout();
}

class Settingslayout extends State<Settings> {
  Uint8List? _profileImage;
  String _name = 'Unknown',
      _email = 'Unknown',
      _birthday = 'Unknown',
      _handynumber = 'Unknown',
      _address = 'Unknown';

  void setData() async {
    try {
      var userData = Hive.box<UserData>('UserData').values.first;
      setState(() {
        //_profileImage = userData.profileImage;
        _name = userData.name;
        // _email = userData.email;
      });
      /*_birthday = userData.birthday;
      _handynumber = userData.handyNumber;
      _address = userData.address;*/
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: ListView(
          children: [
            GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            AccountPage(
                              profileimage: _profileImage!,
                              name: _name,
                              email: _email,
                              birthday: _birthday,
                              address: _address,
                              telephonenumber: _handynumber,
                            ),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) =>
                                child),
                  ).then((value) {
                    setData();
                  });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0x12ffffff),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Row(children: [
                            Container(
                                width: 62.0,
                                height: 62.0,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: _profileImage != null
                                            ? Colors.transparent
                                            : Colors.white),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: getImage(),
                                    ))),
                            Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _name,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    _email,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ])),
                      const Align(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                            color: Colors.white,
                          )),
                    ],
                  ),
                )),
          ],
        ));
  }

  getImage() {
    return _profileImage != null
        ? MemoryImage(
            _profileImage!,
          )
        : const AssetImage('assets/person.png');
  }

  @override
  void initState() {
    setData();
    super.initState();
  }
}
