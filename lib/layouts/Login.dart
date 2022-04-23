import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';

import 'package:smarthome/layouts/Register.dart';
import '../utils/constants.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  bool _isObscure = true;

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
  }

  @override
  void dispose() {
    super.dispose();
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
        child:Scaffold(
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
            const DelayedDisplay(
                delay: Duration(milliseconds: 1000),
                child: Padding(
                      padding: EdgeInsets.only(top: 130, left: 28, right: 28),
                      child: TextField(
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(70)),
                            borderSide:
                                BorderSide(color: Colors.white, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(70)),
                            borderSide:
                                BorderSide(color: Colors.white, width: 2.0),
                          ),
                          hintText: 'Name',
                          hintStyle: TextStyle(color: Colors.white),
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 30,
                          ),
                          contentPadding: EdgeInsets.all(0),
                          isDense: true,
                        ),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        cursorColor: Colors.white,
                      ),
                    )),
            DelayedDisplay(
                delay: const Duration(milliseconds: 1200),
                child: Padding(
                      padding:
                          const EdgeInsets.only(top: 60, left: 28, right: 28),
                      child: TextField(
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
                                })),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        cursorColor: Colors.white,
                      ),
                    )),
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
                        onPressed: () {},
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
                          /*setState(() {
                            animate = true;
                          });*/
                          _controller.reverse(from: 1.0).then((value) => Navigator.pushReplacement(
                                        context,
                                        PageRouteBuilder(
                                            pageBuilder: (context, animation,
                                                    secondaryAnimation) =>
                                                const Register(),
                                            transitionsBuilder: (context,
                                                    animation,
                                                    secondaryAnimation,
                                                    child) =>
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