import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:connectivity/connectivity.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smarthome/utils/MySQLHelper.dart';
import 'package:sprintf/sprintf.dart';

import '../utils/LoadingScreen.dart';
import '../utils/constants.dart';
import 'Login.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() {
    return _RegisterState();
  }
}

class _RegisterState extends State<Register> with TickerProviderStateMixin {
  bool _isObscure = true,
      _isObscureConfirm = true,
      nameError = false,
      emailError = false,
      birthdayError = false,
      passwordError = false,
      confirmPasswordError = false,
      connectionError = false;
  late BuildContext errorDialogContext, registerErrorDialogContext, loadingDialog;

  String nameErrorText = '',
      emailErrorText = '',
      passwordErrorText = '',
      confirmPasswordErrorText = '';
  Image _profileImage = Image.asset(
    'assets/person.png',
    fit: BoxFit.cover,
  );
  late Uint8List _profileImageInster;
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
          Navigator.pop(errorDialogContext);
        }
        break;
      case ConnectivityResult.mobile:
        if (connectionError) {
          Navigator.pop(errorDialogContext);
        }
        connectionErrorDialog(
            'No internet connection! Please turn on your wifi, for connecting to server!');
        break;
      case ConnectivityResult.none:
        if (connectionError) {
          Navigator.pop(errorDialogContext);
        }
        connectionErrorDialog(
            'No internet connection! Please check your wifi, for connecting to server!');
        break;
      default:
        if (connectionError) {
          Navigator.pop(errorDialogContext);
        }
        connectionErrorDialog(
            'No internet connection! Please check your wifi, for connecting to server!');
        break;
    }
  }

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 300), () => registerErrorDialog('Test', 'This is a test, for design this dialog!'));
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    super.dispose();
    _connectivitySubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
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
                const DelayedDisplay(
                    delay: Duration(),
                    child: Padding(
                        padding: EdgeInsets.only(top: 130),
                        child: Text(
                          'Register',
                          style: TextStyle(
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
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Align(
                                              alignment: Alignment.centerLeft,
                                              child: Column(children: [
                                                IconButton(
                                                  onPressed: () async {
                                                    final image =
                                                        await ImagePicker()
                                                            .pickImage(
                                                                source:
                                                                    ImageSource
                                                                        .gallery);
                                                    _cropImage(
                                                        File(image!.path),
                                                        context);
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
                                              ])),
                                          Column(children: [
                                            IconButton(
                                              onPressed: () async {
                                                final image =
                                                    await ImagePicker()
                                                        .pickImage(
                                                            source: ImageSource
                                                                .camera);
                                                _cropImage(
                                                    File(image!.path), context);
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
                                    height: 130,
                                    clipBehavior: Clip.hardEdge,
                                  );
                                });
                          },
                          elevation: 0.0,
                          child: SizedBox(
                              width: 106.0,
                              height: 106.0,
                              child: _profileImage),
                          clipBehavior: Clip.hardEdge,
                          shape: const CircleBorder(
                              side:
                                  BorderSide(color: Colors.white, width: 2.0)),
                        ))),
                DelayedDisplay(
                    delay: const Duration(milliseconds: 1000),
                    child: Padding(
                        padding:
                            const EdgeInsets.only(top: 30, left: 28, right: 28),
                        child: Focus(
                          child: TextField(
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
                              hintText: 'First name, Last name',
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
                    delay: const Duration(milliseconds: 1000),
                    child: Padding(
                        padding:
                            const EdgeInsets.only(top: 10, left: 28, right: 28),
                        child: Focus(
                          child: TextField(
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
                              hintText: 'E-Mail Address',
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
                    delay: const Duration(milliseconds: 1200),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 28, right: 28),
                      child: OutlinedButton(
                        onPressed: () {
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
                              if (value != null && value != birthday) {
                                birthday = value;
                              }
                            });
                          });
                        },
                        child: Row(children: [
                          const Icon(
                            Icons.calendar_today,
                            color: Colors.white,
                            size: 25,
                          ),
                          Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Text(
                                sprintf("%02i.%02i.%04i", [
                                  birthday.day,
                                  birthday.month,
                                  birthday.year
                                ]),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              )),
                        ]),
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size.zero,
                          // Set this
                          padding: const EdgeInsets.only(left: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(70),
                          ),
                          fixedSize: const Size.fromHeight(45),
                          side:
                              const BorderSide(color: Colors.white, width: 2.0),
                        ),
                      ),
                    )),
                DelayedDisplay(
                    delay: const Duration(milliseconds: 1400),
                    child: Padding(
                        padding:
                            const EdgeInsets.only(top: 10, left: 28, right: 28),
                        child: Focus(
                          child: TextField(
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
                              hintText: 'Password',
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
                    delay: const Duration(milliseconds: 1600),
                    child: Padding(
                        padding:
                            const EdgeInsets.only(top: 10, left: 28, right: 28),
                        child: Focus(
                          child: TextField(
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
                              hintText: 'Confirm Password',
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
                                  _passwordController.text ==
                                          _confirmPasswordController.text
                                      ? 'Password don\'t be the same!'
                                      : 'This field can\'t be empty!';
                            });
                          },
                        ))),
                DelayedDisplay(
                    delay: const Duration(milliseconds: 2150),
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
                                loadingDialog = context;
                                return LoadingDialog();
                              });
                          FocusScope.of(context).unfocus();
                          if (validate()) {
                            String result = await MySQLHelper().register(
                                _profileImageInster,
                                _nameController.text,
                                _emailController.text,
                                sprintf("%02i.%02i.%04i", [
                                  birthday.day,
                                  birthday.month,
                                  birthday.year
                                ]),
                                _passwordController.text);
                            if (result == 'successful') {
                              Navigator.pop(loadingDialog);
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
                            }else{
                              Navigator.pop(loadingDialog);
                              setState(() {
                                result == 'failed' ? registerErrorDialog('Registration failed', 'Oops, something went wrong!') : registerErrorDialog('Duplicated user', 'This username already exist! Please, take another Name!');
                                result == 'isDuplicated' ? nameError = true : null ;
                                nameErrorText = '';
                              });

                            }
                          }
                        },
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Register',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 17),
                              ),
                            ]),
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(70)),
                          backgroundColor: Colors.white,
                          fixedSize: const Size.fromHeight(45),
                        ),
                      ),
                    )),
                DelayedDisplay(
                  delay: const Duration(milliseconds: 2350),
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
                      child: const Text(
                        'Have already an Account',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                )
              ],
            ),
          ),
        ));
  }

  Future<void> _cropImage(File pickeImgae, BuildContext context) async {
    Navigator.pop(context);
    final imageFile = await ImageCropper().cropImage(
      sourcePath: pickeImgae.path,
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
      androidUiSettings: const AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      iosUiSettings: const IOSUiSettings(
        title: 'Cropper',
      ),
      compressQuality: 100,
    );
    _profileImageInster = await imageFile!.readAsBytes();
    _profileImage = Image.file(
      File(imageFile.path),
      fit: BoxFit.cover,
    );
    setState(() {});
  }

  bool validate() {
    validateName();
    validateEmail();
    validatePassword(true);
    return !nameError && !emailError && !passwordError && !confirmPasswordError;
  }

  void validateName() {
    if (_nameController.text.isNotEmpty) {
      if (_nameController.text.contains(" ")) {
      } else {
        setState(() {
          nameError = true;
          nameErrorText = 'Please, enter your first and last name!';
        });
      }
    } else {
      setState(() {
        nameError = true;
        nameErrorText = 'This filed can\'t be empty!';
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
          emailErrorText = 'Please, enter correct email address!';
        });
      }
    } else {
      setState(() {
        emailError = true;
        emailErrorText = 'This filed can\'t be empty!';
      });
    }
  }

  void validatePassword(bool checkPasswordMatch) {
    if (_passwordController.text.isNotEmpty) {
      if (RegExp(r'^(?=.*[A-Z])').hasMatch(_passwordController.text)) {
        if (RegExp(r'^(?=.*[a-z])').hasMatch(_passwordController.text)) {
          if (RegExp(r'^(?=.*\d)').hasMatch(_passwordController.text)) {
              if (_passwordController.text.length >= 8) {
                if (_confirmPasswordController.text.isNotEmpty) {
                  if (_passwordController.text ==
                          _confirmPasswordController.text ||
                      !checkPasswordMatch) {
                  } else {
                    setState(() {
                      passwordError = true;
                      passwordErrorText = 'Password don\'t be the same!';
                    });
                  }
                }
              } else {
                setState(() {
                  passwordError = true;
                  passwordErrorText = 'Password must be at least 8 characters!';
                });
              }
          } else {
            setState(() {
              passwordError = true;
              passwordErrorText = 'Password must contains numbers!';
            });
          }
        } else {
          setState(() {
            passwordError = true;
            passwordErrorText = 'Password must contains lower case letters!';
          });
        }
      } else {
        setState(() {
          passwordError = true;
          passwordErrorText = 'Password must contains capital letters!';
        });
      }
    } else {
      setState(() {
        passwordError = true;
        passwordErrorText = 'This filed can\'t be empty!';
      });
    }
    if (_confirmPasswordController.text.isNotEmpty || !checkPasswordMatch) {
    } else {
      setState(() {
        confirmPasswordError = true;
        confirmPasswordErrorText = 'This filed can\'t be empty!';
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
          errorDialogContext = context;
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
                      const Text(
                        'Connection error',
                        style: TextStyle(
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
          registerErrorDialogContext = context;
          return Center(
              child: Wrap(children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(16)), color: ThemeData.dark().backgroundColor),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18, decoration: TextDecoration.none),
              ),
              Padding(padding: const EdgeInsets.only(top: 5), child: Text(
                error,
                style: const TextStyle(color: Colors.white, fontSize: 12, decoration: TextDecoration.none),
                textAlign: TextAlign.center,
              ),),
            ],
          )
          )]));
        });
  }
}
