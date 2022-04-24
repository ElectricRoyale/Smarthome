import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:connectivity/connectivity.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:local_auth/local_auth.dart';

import 'package:smarthome/layouts/Register.dart';
import 'package:smarthome/layouts/mainlayout.dart';
import 'package:smarthome/utils/LoadingScreen.dart';
import 'package:smarthome/utils/MySQLHelper.dart';
import '../utils/constants.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  final LocalAuthentication auth = LocalAuthentication();

  bool _isObscure = true,
      nameError = false,
      passwordError = false,
      connectionError = false;
  String nameErrorText = '', passwordErrorText = '';
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  late BuildContext errorDialogContext;

  Box loginData = Hive.box('LoginData');

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  late final AnimationController _controller = AnimationController(
      reverseDuration: const Duration(milliseconds: 800),
      vsync: this,
      value: 1.0);

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.decelerate,
  );

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
          checkConnection();
        }
        break;
      case ConnectivityResult.mobile:
        if (connectionError) {
          Navigator.pop(errorDialogContext);
        }
        connectionErrorDialog(
            'No internet connection! Please turn on your wifi, for connecting to server!',
            false);
        break;
      case ConnectivityResult.none:
        if (connectionError) {
          Navigator.pop(errorDialogContext);
        }
        connectionErrorDialog(
            'No internet connection! Please check your wifi, for connecting to server!',
            false);
        break;
      default:
        if (connectionError) {
          Navigator.pop(errorDialogContext);
        }
        connectionErrorDialog(
            'No internet connection! Please check your wifi, for connecting to server!',
            false);
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    //checkConnection();
    /*initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);*/
    Future.delayed(const Duration(milliseconds: 2900), () => biometricLogin());
  }

  Future<void> _cancelAuthentication() async {
    await auth.stopAuthentication();
  }

  void biometricLogin() async {
    if (loginData.isNotEmpty) {
      nameController.text = loginData.get('name');
      if (await auth.isDeviceSupported() && await auth.canCheckBiometrics) {
        if (await auth.authenticate(
            localizedReason: 'Please complete the biometrics to proceed.',
            options: const AuthenticationOptions(
              biometricOnly: true,
              stickyAuth: true,
            ))) {
          passwordController.text = loginData.get('password');
          login(loginData.get('name'), loginData.get('password'));
        }
      }
    }
  }

  void checkConnection() {
    Socket.connect('192.168.0.51', 80,
            timeout: const Duration(milliseconds: 500))
        .then((value) {
      if (connectionError) {
        Navigator.pop(errorDialogContext);
        connectionError = false;
      }
    }).catchError((error) {
      if (connectionError) Navigator.pop(errorDialogContext);
      connectionErrorDialog(
          'Can\'t build a connect to the Server! Please check your Internet connection and the connection of the Server!',
          true);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _connectivitySubscription.cancel();
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
            return LoadingDialog();
          });
      if (await MySQLHelper().login(name, password)) {
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
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Login',
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

  void connectionErrorDialog(String error, bool retry) {
    connectionError = true;
    _cancelAuthentication();
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
                      if (retry)
                        TextButton(
                            onPressed: () {}, child: const Text('Retry')),
                    ],
                  ),
                ]),
              ),
            ),
          );
        });
  }
}
