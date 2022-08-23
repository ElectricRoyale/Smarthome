import 'dart:async';

import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_auth_invisible/flutter_local_auth_invisible.dart';
import 'package:hive/hive.dart';
import 'package:smarthome/layouts/Register.dart';
import 'package:smarthome/layouts/mainlayout.dart';
import 'package:smarthome/utils/LoadingScreen.dart';
import 'package:smarthome/utils/MySQLHelper.dart';
import 'package:smarthome/utils/error_dialog.dart';

import '../utils/DashboardData.dart';
import '../utils/constants.dart';
import '../utils/globals.dart';
import '../utils/weatherData.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> with TickerProviderStateMixin {
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
    await LocalAuthentication.stopAuthentication();
  }

  void biometricLogin() async {
    if (loginData.isNotEmpty && !connectionError) {
      nameController.text = loginData.get('name');
      if (await LocalAuthentication.isDeviceSupported() &&
          await LocalAuthentication.canCheckBiometrics) {
        if (await LocalAuthentication.authenticate(
            localizedReason: 'Unlock the app.',
            sensitiveTransaction: true,
            stickyAuth: true,
            biometricOnly: true)) {
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
      await DashboadData().isInitialized;
      await WeatherData().isInitialized;
      if (await MySQLHelper().login(name, password)) {
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
                          'Login',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 36),
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
                              hintText: 'Name',
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
                              nameErrorText = 'Flied can\'t be empty!';
                            });
                          },
                        ))),
                DelayedDisplay(
                    delay: const Duration(milliseconds: 1200),
                    child: Padding(
                        padding:
                            const EdgeInsets.only(top: 60, left: 28, right: 28),
                        child: Focus(
                          child: TextField(
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
                                hintText: 'Password',
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
                              passwordErrorText = 'Flied can\'t be empty!';
                            });
                          },
                        ))),
                DelayedDisplay(
                    delay: const Duration(milliseconds: 1250),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 43, top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const [
                          Text(
                            'Forgot Password?',
                            style: TextStyle(
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
                      child: TextButton(
                        onPressed: () =>
                            login(nameController.text, passwordController.text),
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(70)),
                          backgroundColor: Colors.white,
                          fixedSize: const Size.fromHeight(45),
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Login',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 17),
                              ),
                            ]),
                      ),
                    )),
                DelayedDisplay(
                  delay: const Duration(milliseconds: 1950),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Don\'t have an Account?',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          loginData.clear();
                          _controller
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
                                  ));
                        },
                        child: const Text(
                          'SingUp',
                          style: TextStyle(
                              color: Color(0xffaf0000),
                              fontWeight: FontWeight.bold),
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
