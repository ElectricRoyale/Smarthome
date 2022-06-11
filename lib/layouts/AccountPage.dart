import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smarthome/Model/UserData.dart';
import 'package:smarthome/layouts/Login.dart';
import 'package:smarthome/utils/MySQLHelper.dart';
import 'package:smarthome/utils/globals.dart' as globals;
import 'package:smarthome/utils/widget_functions.dart';
import 'package:sprintf/sprintf.dart';

import '../utils/constants.dart';

class AccountPage extends StatefulWidget {
  final Uint8List profileimage;
  final String name, email, birthday, address, telephonenumber;

  const AccountPage(
      {Key? key,
      required this.profileimage,
      required this.name,
      required this.email,
      required this.birthday,
      required this.address,
      required this.telephonenumber})
      : super(key: key);

  @override
  AccountPageState createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage> {
  bool editing = false;
  late Uint8List _profileImage;
  final _nameController = TextEditingController(),
      _emailController = TextEditingController(),
      _birthdayController = TextEditingController(),
      _addressController = TextEditingController(),
      _telephonenumberController = TextEditingController();

  late DateTime birthday;
  Box<UserData> userData = Hive.box<UserData>('UserData');

  late XFile _pickedImage;

  @override
  void initState() {
    super.initState();
    _profileImage = widget.profileimage;
    _nameController.text = widget.name;
    _emailController.text = widget.email;
    _birthdayController.text = widget.birthday;
    var date = widget.birthday.split('.');
    birthday =
        DateTime(int.parse(date[2]), int.parse(date[1]), int.parse(date[0]));
    _addressController.text = widget.address;
    _telephonenumberController.text = widget.telephonenumber;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onItemTap(int index) {
    setState(() {
      editing = !editing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  BACKGROUND_START,
                  BACKGROUND_END,
                ],
              ),
            ),
            child: ListView(children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(25)),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0x12FFFFFF),
                  ),
                  child: Column(
                    children: [
                      MaterialButton(
                        onPressed: () {
                          if (editing) {
                            showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                builder: (BuildContext context) {
                                  return Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(26)),
                                      color: Color(0xff292828),
                                    ),
                                    height: 130,
                                    clipBehavior: Clip.hardEdge,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Column(children: [
                                            IconButton(
                                              onPressed: () async {
                                                Navigator.pop(context);
                                                globals.mustAuthenticate =
                                                    false;
                                                _pickedImage =
                                                    (await ImagePicker()
                                                        .pickImage(
                                                            source: ImageSource
                                                                .gallery))!;
                                                if (!mounted) return;
                                                _cropImage(
                                                        File(_pickedImage.path),
                                                        context)
                                                    .then((value) => globals
                                                            .mustAuthenticate =
                                                        true);
                                              },
                                              icon: SvgPicture.asset(
                                                "assets/gallery.svg",
                                                width: 100,
                                                height: 100,
                                              ),
                                              iconSize: 70,
                                            ),
                                            const Text(
                                              'Gallery',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )
                                          ]),
                                          Column(children: [
                                            IconButton(
                                              onPressed: () async {
                                                Navigator.pop(context);
                                                globals.mustAuthenticate =
                                                    false;
                                                _pickedImage =
                                                    (await ImagePicker()
                                                        .pickImage(
                                                            source: ImageSource
                                                                .camera))!;
                                                if (!mounted) return;
                                                _cropImage(
                                                        File(_pickedImage.path),
                                                        context)
                                                    .then((value) => globals
                                                            .mustAuthenticate =
                                                        true);
                                              },
                                              icon: SvgPicture.asset(
                                                "assets/camera.svg",
                                                width: 100,
                                                height: 100,
                                              ),
                                              iconSize: 70,
                                            ),
                                            const Text(
                                              'Camera',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )
                                          ]),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          }
                        },
                        padding: EdgeInsets.zero,
                        child: Image.memory(
                          _profileImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                      addVerticalSpace(15),
                      TextField(
                        controller: _nameController,
                        readOnly: !editing,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                        cursorColor: Colors.white,
                      ),
                      addVerticalSpace(15)
                    ],
                  ),
                ),
              ),
              addVerticalSpace(20),
              Container(
                  decoration: const BoxDecoration(
                    color: Color(0x12FFFFFF),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(children: [
                      TextField(
                        controller: _emailController,
                        readOnly: !editing,
                        decoration: const InputDecoration(
                          icon: Icon(
                            Icons.email,
                            color: Colors.white,
                          ),
                          labelText: 'Email Address:',
                          labelStyle: TextStyle(color: Colors.white),
                          border: InputBorder.none,
                        ),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                        cursorColor: Colors.white,
                      ),
                      TextField(
                        controller: _birthdayController,
                        readOnly: true,
                        enabled: editing,
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          showRoundedDatePicker(
                              context: context,
                              initialDate: birthday,
                              firstDate: DateTime(1800),
                              lastDate: DateTime(2600),
                              height: 340,
                              borderRadius: 16,
                              imageHeader: const AssetImage(
                                  'assets/datepickerbackground.png'),
                              customWeekDays: [
                                "SUN",
                                "MON",
                                "TUE",
                                "WED",
                                "THU",
                                "FRI",
                                "SAT"
                              ],
                              styleDatePicker: MaterialRoundedDatePickerStyle(
                                textStyleDayButton: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 26,
                                ),
                                textStyleYearButton: const TextStyle(
                                  fontSize: 21,
                                  color: Colors.white,
                                ),
                                textStyleDayHeader: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                textStyleCurrentDayOnCalendar: const TextStyle(
                                    color: Color(0xffaf0000),
                                    fontWeight: FontWeight.bold),
                                textStyleDayOnCalendar:
                                    const TextStyle(color: Colors.white),
                                textStyleDayOnCalendarSelected: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                textStyleDayOnCalendarDisabled: TextStyle(
                                    color: Colors.white.withOpacity(0.1)),
                                textStyleMonthYearHeader: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                paddingDatePicker: const EdgeInsets.all(0),
                                paddingMonthHeader: const EdgeInsets.all(16),
                                paddingDateYearHeader: const EdgeInsets.all(32),
                                colorArrowNext: Colors.white,
                                colorArrowPrevious: Colors.white,
                                textStyleButtonPositive: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                textStyleButtonNegative: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                decorationDateSelected: const BoxDecoration(
                                    color: Color(0xffaf0000),
                                    shape: BoxShape.circle),
                                backgroundPicker: BACKGROUND_END,
                                backgroundHeader: const Color(0xffaf0000),
                                backgroundHeaderMonth: BACKGROUND_END,
                              ),
                              styleYearPicker: MaterialRoundedYearPickerStyle(
                                textStyleYear: const TextStyle(
                                    fontSize: 21, color: Colors.white),
                                textStyleYearSelected: const TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                heightYearRow: 32,
                                backgroundPicker: BACKGROUND_END,
                              )).then((value) {
                            setState(() {
                              if (value != null) {
                                _birthdayController.text = sprintf(
                                    "%02i.%02i.%04i",
                                    [value.day, value.month, value.year]);
                              }
                            });
                          });
                        },
                        decoration: const InputDecoration(
                          icon: Icon(
                            Icons.calendar_month,
                            color: Colors.white,
                          ),
                          labelText: 'Birthday:',
                          labelStyle: TextStyle(color: Colors.white),
                          border: InputBorder.none,
                        ),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      TextField(
                        controller: _addressController,
                        readOnly: !editing,
                        decoration: const InputDecoration(
                          icon: Icon(
                            Icons.location_on,
                            color: Colors.white,
                          ),
                          labelText: 'Address:',
                          labelStyle: TextStyle(color: Colors.white),
                          border: InputBorder.none,
                        ),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                        cursorColor: Colors.white,
                      ),
                      TextField(
                        controller: _telephonenumberController,
                        readOnly: !editing,
                        decoration: const InputDecoration(
                          icon: Icon(
                            Icons.phone,
                            color: Colors.white,
                          ),
                          labelText: 'Telephonenumber:',
                          labelStyle: TextStyle(color: Colors.white),
                          border: InputBorder.none,
                        ),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                        cursorColor: Colors.white,
                      ),
                    ]),
                  )),
              addVerticalSpace(20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 70),
                child: ElevatedButton(
                  onPressed: () {
                    Hive.box('LoginData').clear();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const Login()),
                        (Route<dynamic> route) => false);
                  },
                  style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      primary: const Color(0x7c292828)),
                  child: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ),
              ),
            ])),
        bottomNavigationBar: Container(
            padding: const EdgeInsets.only(top: 12),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Color(0xE6000000),
                ],
                tileMode: TileMode.decal,
              ),
            ),
            child: SizedBox(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: editing
                      ? [
                          MaterialButton(
                            onPressed: () {
                              setState(() => editing = false);
                              var data = UserData(
                                  profileImage: widget.profileimage,
                                  name: _nameController.text,
                                  email: _emailController.text,
                                  birthday: _birthdayController.text,
                                  address: _addressController.text,
                                  handyNumber: _telephonenumberController.text);
                              userData.putAt(0, data);
                              MySQLHelper().update(
                                  _profileImage,
                                  _nameController.text,
                                  _emailController.text,
                                  _birthdayController.text,
                                  _addressController.text,
                                  _telephonenumberController.text);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.save,
                                  color: Colors.white,
                                ),
                                Text(
                                  'Save',
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          ),
                          MaterialButton(
                            onPressed: () {
                              setState(() => editing = false);
                              _profileImage =
                                  userData.values.first.profileImage!;
                              _nameController.text = userData.values.first.name;
                              _emailController.text =
                                  userData.values.first.email;
                              _birthdayController.text =
                                  userData.values.first.birthday;
                              var date =
                                  userData.values.first.birthday.split('.');
                              birthday = DateTime(int.parse(date[2]),
                                  int.parse(date[1]), int.parse(date[0]));
                              _addressController.text =
                                  userData.values.first.address;
                              _telephonenumberController.text =
                                  userData.values.first.handyNumber;
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.cancel_outlined,
                                  color: Colors.white,
                                ),
                                Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        ]
                      : [
                          MaterialButton(
                            onPressed: () {
                              setState(() => editing = true);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                                Text(
                                  'Edit',
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        ],
                ))));
  }

  Future<void> _cropImage(File pickeImage, BuildContext context) async {
    final imageFile = await ImageCropper().cropImage(
      sourcePath: pickeImage.path,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
      cropStyle: CropStyle.circle,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        )
      ],
      compressQuality: 100,
    );
    _profileImage = await imageFile!.readAsBytes();
    setState(() {});
  }
}
