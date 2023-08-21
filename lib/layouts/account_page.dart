import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sprintf/sprintf.dart';

import '../Model/user_data.dart';
import '../generated/l10n.dart';
import '../layouts/login.dart';
import '../layouts/mainlayout.dart';
import '../utils/constants.dart';
import '../utils/globals.dart' as globals;
import '../utils/widget_functions.dart';

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

  DateTime? birthday;
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
    birthday = date.length == 2
        ? DateTime(int.parse(date[2]), int.parse(date[1]), int.parse(date[0]))
        : null;
    _addressController.text = widget.address;
    _telephonenumberController.text = widget.telephonenumber;
  }

  void onItemTap(int index) {
    setState(() {
      editing = !editing;
    });
  }

  @override
  Widget build(BuildContext context) {
    final delegate = S.of(context);
    Size screenSize = MediaQuery.sizeOf(context);
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
        child: ListView(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color(0x12FFFFFF),
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              clipBehavior: Clip.hardEdge,
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
                                height: screenSize.height * 0.1421875,
                                clipBehavior: Clip.hardEdge,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: screenSize.height * 0.0109375),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(children: [
                                        IconButton(
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            globals.mustAuthenticate = false;
                                            _pickedImage = (await ImagePicker()
                                                .pickImage(
                                                    source:
                                                        ImageSource.gallery))!;
                                            if (!mounted) return;
                                            _cropImage(File(_pickedImage.path),
                                                    context)
                                                .then((value) => globals
                                                    .mustAuthenticate = true);
                                          },
                                          icon: SvgPicture.asset(
                                            "assets/gallery.svg",
                                            width: screenSize.width * 0.2430555,
                                            height:
                                                screenSize.width * 0.2430555,
                                          ),
                                          iconSize: 70,
                                        ),
                                        Text(
                                          delegate.gallery,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        )
                                      ]),
                                      Column(children: [
                                        IconButton(
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            globals.mustAuthenticate = false;
                                            _pickedImage = (await ImagePicker()
                                                .pickImage(
                                                    source:
                                                        ImageSource.camera))!;
                                            if (!mounted) return;
                                            _cropImage(File(_pickedImage.path),
                                                    context)
                                                .then((value) => globals
                                                    .mustAuthenticate = true);
                                          },
                                          icon: SvgPicture.asset(
                                            "assets/camera.svg",
                                            width: screenSize.width * 0.2430555,
                                            height:
                                                screenSize.width * 0.2430555,
                                          ),
                                          iconSize: 70,
                                        ),
                                        Text(
                                          delegate.camera,
                                          style: const TextStyle(
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
                  addVerticalSpace(screenSize.height * 0.01640625),
                  TextField(
                    controller: _nameController,
                    readOnly: !editing,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  addVerticalSpace(screenSize.height * 0.01640625)
                ],
              ),
            ),
            addVerticalSpace(screenSize.height * 0.021875),
            Container(
                decoration: const BoxDecoration(
                  color: Color(0x12FFFFFF),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenSize.height * 0.01640625),
                  child: Column(children: [
                    TextField(
                      controller: _emailController,
                      readOnly: !editing,
                      decoration: InputDecoration(
                        icon: const Icon(
                          Icons.email,
                        ),
                        labelText: delegate.accountLabelEmail,
                        labelStyle: const TextStyle(color: Colors.white),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(fontSize: 20),
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
                            height: screenSize.height * 0.371875,
                            borderRadius: 16,
                            imageHeader: const AssetImage(
                                'assets/datepickerbackground.png'),
                            customWeekDays: [
                              delegate.sun,
                              delegate.mon,
                              delegate.tue,
                              delegate.wed,
                              delegate.thu,
                              delegate.fri,
                              delegate.sat,
                            ],
                            styleDatePicker: MaterialRoundedDatePickerStyle(
                              textStyleDayButton: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 26,
                              ),
                              textStyleYearButton: const TextStyle(
                                fontSize: 21,
                              ),
                              textStyleDayHeader:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              textStyleCurrentDayOnCalendar: const TextStyle(
                                  color: Color(0xffaf0000),
                                  fontWeight: FontWeight.bold),
                              textStyleDayOnCalendar:
                                  const TextStyle(color: Colors.white),
                              textStyleDayOnCalendarSelected:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              textStyleDayOnCalendarDisabled: TextStyle(
                                  color: Colors.white.withOpacity(0.1)),
                              textStyleMonthYearHeader:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              paddingDatePicker: const EdgeInsets.all(0),
                              paddingMonthHeader: const EdgeInsets.all(16),
                              paddingDateYearHeader: const EdgeInsets.all(32),
                              colorArrowNext: Colors.white,
                              colorArrowPrevious: Colors.white,
                              textStyleButtonPositive:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              textStyleButtonNegative:
                                  const TextStyle(fontWeight: FontWeight.bold),
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
                                  fontSize: 24, fontWeight: FontWeight.bold),
                              heightYearRow: screenSize.height * 0.035,
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
                      decoration: InputDecoration(
                        icon: const Icon(
                          CupertinoIcons.calendar,
                        ),
                        labelText: delegate.accountLabelBirthday,
                        labelStyle: const TextStyle(color: Colors.white),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    TextField(
                      controller: _addressController,
                      readOnly: !editing,
                      decoration: InputDecoration(
                        icon: const Icon(
                          Icons.location_on,
                        ),
                        labelText: delegate.accountLabelAddress,
                        labelStyle: const TextStyle(color: Colors.white),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(fontSize: 20),
                    ),
                    TextField(
                      controller: _telephonenumberController,
                      readOnly: !editing,
                      decoration: InputDecoration(
                        icon: const Icon(
                          Icons.phone,
                        ),
                        labelText: delegate.accountLabelTelephone,
                        labelStyle: const TextStyle(color: Colors.white),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(fontSize: 20),
                    ),
                  ]),
                )),
            addVerticalSpace(screenSize.height * 0.021875),
            Container(
              decoration: const BoxDecoration(
                color: Color(0x12FFFFFF),
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 18.0),
              child: Wrap(
                spacing: 13.0,
                runSpacing: 10.0,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Icon(Icons.logout_rounded),
                  ElevatedButton(
                    onPressed: () {
                      WidgetsBinding.instance.removeObserver(MyHomePageState());
                      Hive.box('LoginData').clear();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Login()),
                          (Route<dynamic> route) => false);
                    },
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft,
                        backgroundColor: Colors.transparent,
                        elevation: 0),
                    child: Text(
                      delegate.accountLogout,
                      style: const TextStyle(color: Colors.red, fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      /*bottomNavigationBar: Container(
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
                                //profileImage: _profileImage,
                                name: _nameController.text,
                                /*email: _emailController.text,
                                  birthday: _birthdayController.text,
                                  address: _addressController.text,
                                  handyNumber: _telephonenumberController.text*/
                              );
                              userData.putAt(0, data);
                              MySQLHelper().update(
                                  _profileImage,
                                  _nameController.text,
                                  _emailController.text,
                                  _birthdayController.text,
                                  _addressController.text,
                                  _telephonenumberController.text,
                                  widget.name);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.save,

                                ),
                                Text(
                                  delegate.accountSave,
                                  style: const TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          ),
                          MaterialButton(
                            onPressed: () {
                              setState(() => editing = false);
                              //_profileImage = userData.values.first.profileImage!;
                              _nameController.text = userData.values.first.name;
                              /*_emailController.text =
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
                                  userData.values.first.handyNumber;*/
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.cancel_outlined,

                                ),
                                Text(
                                  delegate.accountCancel,
                                  style: const TextStyle(color: Colors.white),
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
                              children: [
                                const Icon(
                                  Icons.edit,

                                ),
                                Text(
                                  delegate.accountEdit,
                                  style: const TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        ],
                )))*/
    );
  }

  Future<void> _cropImage(File pickeImage, BuildContext context) async {
    final delegate = S.of(context);
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
            toolbarTitle: delegate.titleImageCropper,
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: delegate.titleImageCropper,
        )
      ],
      compressQuality: 100,
    );
    _profileImage = await imageFile!.readAsBytes();
    setState(() {});
  }
}
