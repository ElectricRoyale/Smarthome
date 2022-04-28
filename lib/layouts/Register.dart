import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sprintf/sprintf.dart';

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
  bool _isObscure = true;
  Image _profileImage = Image.asset('assets/person.png');
  DateTime birthday = DateTime(2000, 1, 1);

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
                                    child: Row(
                                      children: [
                                        Align(
                                            alignment: Alignment.centerLeft,
                                            child:
                                        Column(
                                            children: [
                                          IconButton(
                                            onPressed: () {},
                                            icon: SvgPicture.asset(
                                              "assets/gallery.svg",
                                              width: 100,
                                              height: 100,
                                            ),
                                            iconSize: 70,
                                          ),
                                          const Text(
                                            'Gallery',
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        ])),
                                        Column(children: [
                                          IconButton(
                                              onPressed: () {},
                                              icon: SvgPicture.asset(
                                                  "assets/gallery.svg")),
                                          const Text(
                                            'Gallery',
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        ]),
                                      ],
                                    ),
                                    height: 130,
                                    clipBehavior: Clip.hardEdge,
                                  );
                                });
                          },
                          elevation: 0.0,
                          child: _profileImage,
                          shape: const CircleBorder(
                              side:
                                  BorderSide(color: Colors.white, width: 2.0)),
                          minWidth: 106.0,
                          height: 106.0,
                        ))),
                const DelayedDisplay(
                    delay: Duration(milliseconds: 1000),
                    child: Padding(
                      padding: EdgeInsets.only(top: 30, left: 28, right: 28),
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
                          hintText: 'First name, Last name',
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
                const DelayedDisplay(
                    delay: Duration(milliseconds: 1000),
                    child: Padding(
                      padding: EdgeInsets.only(top: 10, left: 28, right: 28),
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
                          hintText: 'E-Mail Address',
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
                          const EdgeInsets.only(top: 10, left: 28, right: 28),
                      child: OutlinedButton(
                        onPressed: () {
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
                                backgroundPicker:
                                    BACKGROUND_END,
                                backgroundHeader: const Color(0xffaf0000),
                                backgroundHeaderMonth:
                                  BACKGROUND_END,
                              ),
                              styleYearPicker: MaterialRoundedYearPickerStyle(
                                textStyleYear: const TextStyle(
                                    fontSize: 21, color: Colors.white),
                                textStyleYearSelected: const TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                heightYearRow: 32,
                                backgroundPicker:
                                    BACKGROUND_END,
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
                    delay: const Duration(milliseconds: 1600),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 28, right: 28),
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
                    delay: const Duration(milliseconds: 2150),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 70, left: 28, right: 28),
                      child: TextButton(
                        onPressed: () {},
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
}
