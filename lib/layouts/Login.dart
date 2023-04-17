import 'dart:async';

import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:local_auth/local_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smarthome/layouts/mainlayout.dart';
import 'package:smarthome/utils/LoadingScreen.dart';
import 'package:smarthome/utils/MySQLHelper.dart';
import 'package:smarthome/utils/error_dialog.dart';

import '../generated/l10n.dart';
import '../utils/DashboardData.dart';
import '../utils/constants.dart';
import '../utils/globals.dart';
import '../utils/weatherData.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  bool _isObscure = true, nameError = false, passwordError = false;
  String nameErrorText = '', passwordErrorText = '';
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  ErrorDialog errorDialog = ErrorDialog();

  Box loginData = Hive.box('LoginData');

  late final AnimationController _controller = AnimationController(
      reverseDuration: const Duration(milliseconds: 800),
      vsync: this,
      value: 1.0);

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.decelerate,
  );

  LocalAuthentication auth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    errorDialog.initialize(context, onChange: (connectionStatus) {
      if (connectionStatus == ConnectionStatus.connected) {
        biometricLogin();
      } else {
        _cancelAuthentication();
      }
    });

    errorDialog.checkConnection();
    Future.delayed(const Duration(milliseconds: 2900), () => biometricLogin());
  }

  Future<void> _cancelAuthentication() async {
    await auth.stopAuthentication();
  }

  void biometricLogin() async {
    await Permission.location.request().isGranted;
    await Permission.camera.request().isGranted;
    await Permission.storage.request().isGranted;
    if (loginData.isNotEmpty && !connectionError) {
      nameController.text = loginData.get('name');
      if (await auth.isDeviceSupported() && await auth.canCheckBiometrics) {
        if (await auth.authenticate(
          localizedReason: S.of(context).biometricLocalizedReason,
          options: const AuthenticationOptions(
              stickyAuth: true, biometricOnly: true),
        )) {
          passwordController.text = loginData.get('password');
          login(loginData.get('name'), loginData.get('password'));
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    errorDialog.dispose();
    _cancelAuthentication();
  }

  late BuildContext loadingDialog;

  void login(String name, String password) async {
    if (nameController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      showDialog(
          context: context,
          barrierDismissible: false,
          useRootNavigator: false,
          builder: (BuildContext context) {
            loadingDialog = context;
            return const LoadingDialog();
          });
      if (await MySQLHelper().login(name, password)) {
        await DashboardData().init(context);
        await WeatherData().init(context);
        errorDialog.dispose();
        if (!mounted) return;
        Navigator.pop(loadingDialog);
        _controller
            .reverse(from: 1.0)
            .then((value) => Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const MyHomePage(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) =>
                              child),
                ));
      } else {
        Navigator.pop(loadingDialog);
        setState(() {
          nameError = true;
          nameErrorText = 'Username and Password doesn\'t match';
          passwordError = true;
          passwordErrorText = 'Username and Password doesn\'t match';
          passwordController.text = '';
        });
      }
    } else {
      if (nameController.text.isEmpty) {
        setState(() {
          nameError = true;
          nameErrorText = 'Flied can\'t be empty!';
        });
      }
      if (passwordController.text.isEmpty) {
        setState(() {
          passwordError = true;
          passwordErrorText = 'Flied can\'t be empty!';
        });
      }
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
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            body: Column(
              children: [
                DelayedDisplay(
                    delay: const Duration(),
                    child: Padding(
                        padding: const EdgeInsets.only(top: 130),
                        child: Text(
                          delegate.titleLogin,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 36,
                            shadows: [
                              Shadow(
                                offset: Offset(0.0, 2.5),
                                blurRadius: 3.0,
                                color: Color.fromARGB(255, 0, 0, 0),
                              )
                            ],
                          ),
                        ))),
                DelayedDisplay(
                    delay: const Duration(milliseconds: 1000),
                    child: Padding(
                        padding: const EdgeInsets.only(
                            top: 130, left: 28, right: 28),
                        child: Focus(
                          child: TextField(
                            controller: nameController,
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
                              hintText: delegate.loginFieldHintName,
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
                              nameError = hasFocus
                                  ? false
                                  : nameController.text.isEmpty;
                              nameErrorText = delegate.loginFieldErrorEmpty;
                            });
                          },
                        ))),
                DelayedDisplay(
                    delay: const Duration(milliseconds: 1200),
                    child: Padding(
                        padding:
                            const EdgeInsets.only(top: 60, left: 28, right: 28),
                        child: Focus(
                          child: TextFormField(
                            controller: passwordController,
                            obscureText: _isObscure,
                            enableSuggestions: false,
                            decoration: InputDecoration(
                                focusedBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(70)),
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 2.0),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(70)),
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 2.0),
                                ),
                                hintText: delegate.loginFieldHintPassword,
                                hintStyle: const TextStyle(color: Colors.white),
                                prefixIcon: const Icon(
                                  Icons.security,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                contentPadding: const EdgeInsets.all(0),
                                isDense: true,
                                errorText:
                                    passwordError ? passwordErrorText : null,
                                errorBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(70)),
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 2.0),
                                ),
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
                                    })),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                            cursorColor: Colors.white,
                          ),
                          onFocusChange: (hasFocus) {
                            setState(() {
                              passwordError = hasFocus
                                  ? false
                                  : passwordController.text.isEmpty;
                              passwordErrorText = delegate.loginFieldErrorEmpty;
                            });
                          },
                        ))),
                DelayedDisplay(
                    delay: const Duration(milliseconds: 1250),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 43, top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            delegate.loginPasswordForgot,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    )),
                DelayedDisplay(
                  delay: const Duration(milliseconds: 1750),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 161, left: 28, right: 28),
                    child: GestureDetector(
                        onTap: () =>
                            login(nameController.text, passwordController.text),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(70),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                    offset: Offset(0, 2.75),
                                    blurRadius: 1.0,
                                    color: Colors.black,
                                    blurStyle: BlurStyle.solid)
                              ]),
                          height: const Size.fromHeight(45).height,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  delegate.titleLogin,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                              ]),
                        )),
                  ),
                ),
                DelayedDisplay(
                  delay: const Duration(milliseconds: 1950),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        delegate.loginDontHaveAccount,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              offset: Offset(0.0, 2.5),
                              blurRadius: 3.0,
                              color: Color.fromARGB(255, 0, 0, 0),
                            )
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          loginData.clear();
                          /*_controller
                              .reverse(from: 1.0)
                              .then((value) => Navigator.pushReplacement(
                                    context,
                                    PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                                secondaryAnimation) =>
                                            const Register(),
                                        transitionsBuilder: (context, animation,
                                                secondaryAnimation, child) =>
                                            child),
                                  ));*/
                        },
                        child: Text(
                          delegate.loginSignUp,
                          style: const TextStyle(
                            color: Color(0xffaf0000),
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                offset: Offset(0.0, 2.5),
                                blurRadius: 3.0,
                                color: Color.fromARGB(255, 0, 0, 0),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
