import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:connectivity/connectivity.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sprintf/sprintf.dart';

import '../generated/l10n.dart';
import '../layouts/web_auth.dart';
import '../utils/constants.dart';
import '../utils/loading_screen.dart';
import '../utils/my_sql_helper.dart';
import 'login.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<Register> with TickerProviderStateMixin {
  bool _isObscure = true,
      _isObscureConfirm = true,
      nameError = false,
      emailError = false,
      passwordError = false,
      confirmPasswordError = false,
      connectionError = false;

  String nameErrorText = '',
      emailErrorText = '',
      passwordErrorText = '',
      confirmPasswordErrorText = '';

  Image _profileImage = Image.asset(
    'assets/person.png',
    fit: BoxFit.cover,
  );
  late XFile _pickedImage;
  //Uint8List? _profileImageInster;
  DateTime birthday = DateTime(2000, 1, 1);
  final _nameController = TextEditingController(),
      _emailController = TextEditingController(),
      _passwordController = TextEditingController(),
      _confirmPasswordController = TextEditingController();

  late final AnimationController _controller = AnimationController(
      reverseDuration: const Duration(milliseconds: 800),
      vsync: this,
      value: 1.0);

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.decelerate,
  );

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  final authorizationEndpoint = Uri.http(
      RegExp(r'(?<host>\d+\.\d+\.\d+\.\d+:\d+)')
          .firstMatch(Hive.box('Settings').get('host'))!
          .namedGroup('host')!,
      '/auth/authorize',
      {
        "response_type": "code",
        "redirect_uri": "${Hive.box('Settings').get('host')}/auth-callback",
        "client_id":
            'http://${RegExp(r'(?<host>\d+\.\d+\.\d+\.\d+:\d+)').firstMatch(Hive.box('Settings').get('host'))!.namedGroup('host')!}',
      });
  final clientId =
      'http://${RegExp(r'(?<host>\d+\.\d+\.\d+\.\d+:\d+)').firstMatch(Hive.box('Settings').get('host'))!.namedGroup('host')!}';
  final tokenEndpoint =
      Uri.parse("${Hive.box('Settings').get('host')}/auth/token");
  final registrationEndpoint = Uri.parse(
      "${Hive.box('Settings').get('host')}/api/mobile_app/registrations");

  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return _updateConnectionStatus(result);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        if (connectionError) {
          Navigator.pop(context);
        }
        connectionError = false;
        break;
      case ConnectivityResult.mobile:
        if (connectionError) {
          Navigator.pop(context);
        }
        connectionError = false;
        break;
      case ConnectivityResult.none:
        if (connectionError) {
          Navigator.pop(context);
        }
        connectionErrorDialog(S.of(context).connectionerrorMessage);
        break;
      default:
        if (connectionError) {
          Navigator.pop(context);
        }
        connectionErrorDialog(S.of(context).connectionerrorMessage);
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    super.dispose();
    _connectivitySubscription.cancel();
    if (connectionError) {
      Navigator.pop(context);
      connectionError = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final delegate = S.of(context);
    return Container(
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
        child: FadeTransition(
          opacity: _animation,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              children: [
                DelayedDisplay(
                    child: Padding(
                        padding: const EdgeInsets.only(top: 130),
                        child: Text(
                          delegate.titleRegister,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 36),
                        ))),
                DelayedDisplay(
                    delay: const Duration(milliseconds: 1000),
                    child: Padding(
                        padding:
                            const EdgeInsets.only(top: 30, left: 28, right: 28),
                        child: MaterialButton(
                          onPressed: () {
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
                                                _pickedImage =
                                                    (await ImagePicker()
                                                        .pickImage(
                                                            source: ImageSource
                                                                .gallery))!;
                                                if (!mounted) return;
                                                _cropImage(
                                                    File(_pickedImage.path),
                                                    context);
                                              },
                                              icon: SvgPicture.asset(
                                                "assets/gallery.svg",
                                                width: 100,
                                                height: 100,
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
                                                _pickedImage =
                                                    (await ImagePicker()
                                                        .pickImage(
                                                            source: ImageSource
                                                                .camera))!;
                                                if (!mounted) return;
                                                _cropImage(
                                                    File(_pickedImage.path),
                                                    context);
                                              },
                                              icon: SvgPicture.asset(
                                                "assets/camera.svg",
                                                width: 100,
                                                height: 100,
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
                          },
                          elevation: 0.0,
                          clipBehavior: Clip.hardEdge,
                          shape: const CircleBorder(
                              side:
                                  BorderSide(color: Colors.white, width: 2.0)),
                          child: SizedBox(
                              width: 106.0,
                              height: 106.0,
                              child: _profileImage),
                        ))),
                DelayedDisplay(
                    delay: const Duration(milliseconds: 1200),
                    child: Padding(
                        padding:
                            const EdgeInsets.only(top: 30, left: 28, right: 28),
                        child: Focus(
                          child: TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(70)),
                                borderSide:
                                    BorderSide(color: Colors.white, width: 2.0),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(70)),
                                borderSide:
                                    BorderSide(color: Colors.white, width: 2.0),
                              ),
                              hintText: delegate.registerFieldHintName,
                              hintStyle: const TextStyle(color: Colors.white),
                              prefixIcon: const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 30,
                              ),
                              contentPadding: const EdgeInsets.all(0),
                              isDense: true,
                              errorText: nameError ? nameErrorText : null,
                              errorBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(70)),
                                borderSide:
                                    BorderSide(color: Colors.red, width: 2.0),
                              ),
                            ),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                            cursorColor: Colors.white,
                          ),
                          onFocusChange: (hasFocus) {
                            setState(() {
                              hasFocus ? nameError = false : validateName();
                            });
                          },
                        ))),
                DelayedDisplay(
                    delay: const Duration(milliseconds: 1400),
                    child: Padding(
                        padding:
                            const EdgeInsets.only(top: 10, left: 28, right: 28),
                        child: Focus(
                          child: TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(70)),
                                borderSide:
                                    BorderSide(color: Colors.white, width: 2.0),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(70)),
                                borderSide:
                                    BorderSide(color: Colors.white, width: 2.0),
                              ),
                              hintText: delegate.registerFieldHintEmail,
                              hintStyle: const TextStyle(color: Colors.white),
                              prefixIcon: const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 30,
                              ),
                              contentPadding: const EdgeInsets.all(0),
                              isDense: true,
                              errorText: emailError ? emailErrorText : null,
                              errorBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(70)),
                                borderSide:
                                    BorderSide(color: Colors.red, width: 2.0),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                            cursorColor: Colors.white,
                          ),
                          onFocusChange: (hasFocus) {
                            setState(() {
                              hasFocus ? emailError = false : validateEmail();
                            });
                          },
                        ))),
                DelayedDisplay(
                    delay: const Duration(milliseconds: 1600),
                    child: Padding(
                        padding:
                            const EdgeInsets.only(top: 10, left: 28, right: 28),
                        child: Focus(
                          child: TextField(
                            decoration: InputDecoration(
                              focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(70)),
                                borderSide:
                                    BorderSide(color: Colors.white, width: 2.0),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(70)),
                                borderSide:
                                    BorderSide(color: Colors.white, width: 2.0),
                              ),
                              hintText: sprintf("%02i.%02i.%04i", [
                                birthday.day,
                                birthday.month,
                                birthday.year
                              ]),
                              hintStyle: const TextStyle(color: Colors.white),
                              prefixIcon: const Icon(
                                Icons.calendar_month,
                                color: Colors.white,
                                size: 30,
                              ),
                              contentPadding: const EdgeInsets.all(0),
                              isDense: true,
                            ),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                            cursorColor: Colors.white,
                            readOnly: true,
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
                                    delegate.sun,
                                    delegate.mon,
                                    delegate.tue,
                                    delegate.wed,
                                    delegate.thu,
                                    delegate.fri,
                                    delegate.sat,
                                  ],
                                  styleDatePicker:
                                      MaterialRoundedDatePickerStyle(
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
                                    textStyleCurrentDayOnCalendar:
                                        const TextStyle(
                                            color: Color(0xffaf0000),
                                            fontWeight: FontWeight.bold),
                                    textStyleDayOnCalendar:
                                        const TextStyle(color: Colors.white),
                                    textStyleDayOnCalendarSelected:
                                        const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                    textStyleDayOnCalendarDisabled: TextStyle(
                                        color: Colors.white.withOpacity(0.1)),
                                    textStyleMonthYearHeader: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                    paddingDatePicker: const EdgeInsets.all(0),
                                    paddingMonthHeader:
                                        const EdgeInsets.all(16),
                                    paddingDateYearHeader:
                                        const EdgeInsets.all(32),
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
                                  styleYearPicker:
                                      MaterialRoundedYearPickerStyle(
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
                                  if (value != null && value != birthday) {
                                    birthday = value;
                                  }
                                });
                              });
                            },
                          ),
                        ))),
                DelayedDisplay(
                    delay: const Duration(milliseconds: 1800),
                    child: Padding(
                        padding:
                            const EdgeInsets.only(top: 10, left: 28, right: 28),
                        child: Focus(
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: _isObscure,
                            enableSuggestions: false,
                            decoration: InputDecoration(
                              focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(70)),
                                borderSide:
                                    BorderSide(color: Colors.white, width: 2.0),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(70)),
                                borderSide:
                                    BorderSide(color: Colors.white, width: 2.0),
                              ),
                              hintText: delegate.registerFieldHintPassword,
                              hintStyle: const TextStyle(color: Colors.white),
                              prefixIcon: const Icon(
                                Icons.security,
                                color: Colors.white,
                                size: 30,
                              ),
                              contentPadding: const EdgeInsets.all(0),
                              isDense: true,
                              suffixIcon: IconButton(
                                  icon: Icon(
                                    _isObscure
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isObscure = !_isObscure;
                                    });
                                  }),
                              errorText:
                                  passwordError ? passwordErrorText : null,
                              errorBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(70)),
                                borderSide:
                                    BorderSide(color: Colors.red, width: 2.0),
                              ),
                            ),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                            cursorColor: Colors.white,
                          ),
                          onFocusChange: (hasFocus) {
                            setState(() {
                              hasFocus
                                  ? passwordError = false
                                  : validatePassword(false);
                            });
                          },
                        ))),
                DelayedDisplay(
                    delay: const Duration(milliseconds: 2000),
                    child: Padding(
                        padding:
                            const EdgeInsets.only(top: 10, left: 28, right: 28),
                        child: Focus(
                          child: TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: _isObscureConfirm,
                            enableSuggestions: false,
                            decoration: InputDecoration(
                              focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(70)),
                                borderSide:
                                    BorderSide(color: Colors.white, width: 2.0),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(70)),
                                borderSide:
                                    BorderSide(color: Colors.white, width: 2.0),
                              ),
                              hintText:
                                  delegate.registerFieldHintConfirmPassword,
                              hintStyle: const TextStyle(color: Colors.white),
                              prefixIcon: const Icon(
                                Icons.security,
                                color: Colors.white,
                                size: 30,
                              ),
                              contentPadding: const EdgeInsets.all(0),
                              isDense: true,
                              suffixIcon: IconButton(
                                  icon: Icon(
                                    _isObscureConfirm
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isObscureConfirm = !_isObscureConfirm;
                                    });
                                  }),
                              errorText: confirmPasswordError
                                  ? confirmPasswordErrorText
                                  : null,
                              errorBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(70)),
                                borderSide:
                                    BorderSide(color: Colors.red, width: 2.0),
                              ),
                            ),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                            cursorColor: Colors.white,
                          ),
                          onFocusChange: (hasFocus) {
                            setState(() {
                              confirmPasswordError = hasFocus
                                  ? false
                                  : !(_passwordController.text ==
                                          _confirmPasswordController.text &&
                                      _confirmPasswordController
                                          .text.isNotEmpty);
                              confirmPasswordErrorText =
                                  _passwordController.text !=
                                          _confirmPasswordController.text
                                      ? delegate.registerFieldErrorPassword
                                      : delegate.registerFieldErrorEmpty;
                            });
                          },
                        ))),
                DelayedDisplay(
                    delay: const Duration(milliseconds: 2550),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 70, left: 28, right: 28),
                      child: TextButton(
                        onPressed: () async {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              useRootNavigator: false,
                              builder: (BuildContext context) {
                                return const LoadingDialog();
                              });
                          FocusScope.of(context).unfocus();
                          if (validate()) {
                            String? token = await Navigator.of(context).push(
                                MaterialPageRoute<String>(
                                    builder: (BuildContext context) {
                              return WebAuth(authorizationEndpoint, clientId,
                                  tokenEndpoint);
                            }));
                            String result = await MySQLHelper().register(
                              _nameController.text,
                              _passwordController.text,
                              registrationEndpoint,
                              token!,
                            );
                            if (result == 'successful') {
                              if (!mounted) return;
                              Navigator.pop(context);
                              _controller
                                  .reverse(from: 1.0)
                                  .then((value) => Navigator.pushReplacement(
                                        context,
                                        PageRouteBuilder(
                                            pageBuilder: (context, animation,
                                                    secondaryAnimation) =>
                                                const Login(),
                                            transitionsBuilder: (context,
                                                    animation,
                                                    secondaryAnimation,
                                                    child) =>
                                                child),
                                      ));
                            } else {
                              if (!mounted) return;
                              Navigator.pop(context);
                              setState(() {
                                result == 'failed'
                                    ? registerErrorDialog(
                                        delegate.registerErrorFailed,
                                        delegate.registerErrorFailedMessage)
                                    : registerErrorDialog(
                                        delegate.registerErrorUserDuplicated,
                                        delegate
                                            .registerErrorUserDuplicatedMessage);
                                result == 'isDuplicated'
                                    ? nameError = true
                                    : null;
                                nameErrorText = '';
                              });
                            }
                          }
                        },
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(70)),
                          backgroundColor: Colors.white,
                          fixedSize: const Size.fromHeight(45),
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                delegate.titleRegister,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 17),
                              ),
                            ]),
                      ),
                    )),
                DelayedDisplay(
                  delay: const Duration(milliseconds: 2750),
                  child: TextButton(
                      onPressed: () {
                        _controller
                            .reverse(from: 1.0)
                            .then((value) => Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          const Login(),
                                      transitionsBuilder: (context, animation,
                                              secondaryAnimation, child) =>
                                          child),
                                ));
                      },
                      child: Text(
                        delegate.registerAlreadyHaveAccount,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                )
              ],
            ),
          ),
        ));
  }

  Future<void> _cropImage(File pickeImage, BuildContext context) async {
    Navigator.pop(context);
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
    //_profileImageInster = await imageFile!.readAsBytes();
    _profileImage = Image.file(
      File(imageFile!.path),
      fit: BoxFit.cover,
    );
    setState(() {});
  }

  bool validate() {
    validateName();
    //validateEmail();
    validatePassword(true);
    return !nameError && !passwordError && !confirmPasswordError;
  }

  void validateName() {
    if (_nameController.text.isNotEmpty) {
      if (_nameController.text.contains(" ")) {
      } else {
        setState(() {
          nameError = true;
          nameErrorText = S.of(context).registerFieldErrorName;
        });
      }
    } else {
      setState(() {
        nameError = true;
        nameErrorText = S.of(context).registerFieldErrorEmpty;
      });
    }
  }

  void validateEmail() {
    if (_emailController.text.isNotEmpty) {
      if (RegExp(
              r'^(([^<>()[\]\\.,;:\s@]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\])|(([a-zA-Z\-\d]+\.)+[a-zA-Z]{2,}))$')
          .hasMatch(_emailController.text)) {
      } else {
        setState(() {
          emailError = true;
          emailErrorText = S.of(context).registerFieldErrorEmail;
        });
      }
    } else {
      setState(() {
        emailError = true;
        emailErrorText = S.of(context).registerFieldErrorEmpty;
      });
    }
  }

  void validatePassword(bool checkPasswordMatch) {
    if (_passwordController.text.isNotEmpty) {
      if (RegExp(r'^(?=.*[A-Z])').hasMatch(_passwordController.text)) {
        if (RegExp(r'^(?=.*[a-z])').hasMatch(_passwordController.text)) {
          if (_passwordController.text.length >= 8) {
            if (_confirmPasswordController.text.isNotEmpty) {
              if (_passwordController.text == _confirmPasswordController.text ||
                  !checkPasswordMatch) {
              } else {
                setState(() {
                  passwordError = true;
                  passwordErrorText = S.of(context).registerFieldErrorPassword;
                });
              }
            }
          } else {
            setState(() {
              passwordError = true;
              passwordErrorText =
                  S.of(context).registerFieldErrorPasswordLength;
            });
          }
        } else {
          setState(() {
            passwordError = true;
            passwordErrorText =
                S.of(context).registerFieldErrorPasswordCharactersLow;
          });
        }
      } else {
        setState(() {
          passwordError = true;
          passwordErrorText =
              S.of(context).registerFieldErrorPasswordCharactersCapital;
        });
      }
    } else {
      setState(() {
        passwordError = true;
        passwordErrorText = S.of(context).registerFieldErrorEmpty;
      });
    }
    if (_confirmPasswordController.text.isNotEmpty || !checkPasswordMatch) {
    } else {
      setState(() {
        confirmPasswordError = true;
        confirmPasswordErrorText = S.of(context).registerFieldErrorEmpty;
      });
    }
  }

  void connectionErrorDialog(String error) {
    connectionError = true;
    showDialog(
        context: context,
        barrierDismissible: false,
        useRootNavigator: false,
        builder: (BuildContext context) {
          final delegate = S.of(context);
          return WillPopScope(
            onWillPop: () async => false,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
              child: Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
                backgroundColor: Colors.transparent,
                child: Stack(children: [
                  Align(
                      child: Padding(
                          padding: const EdgeInsets.only(bottom: 240),
                          child: SvgPicture.asset(
                            'assets/error.svg',
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ))),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        delegate.connectionerrorTitle,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 26),
                      ),
                      Text(
                        error,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ]),
              ),
            ),
          );
        });
  }

  void registerErrorDialog(String title, String error) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
              child: Wrap(children: [
            Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    color: const ColorScheme.dark().background),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          decoration: TextDecoration.none),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        error,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            decoration: TextDecoration.none),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ))
          ]));
        });
  }
}
