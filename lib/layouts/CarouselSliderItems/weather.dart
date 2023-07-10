import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:smarthome/Model/weather_locations.dart';
import 'package:smarthome/utils/location_add_dialog.dart';
import 'package:smarthome/utils/weather_data.dart';
import 'package:weather/weather.dart';

import '../../generated/l10n.dart';
import '../../utils/globals.dart';

class WeatherLayout extends StatefulWidget {
  const WeatherLayout({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => WeatherLayoutDesign();
}

class WeatherLayoutDesign extends State<WeatherLayout> {
  TextEditingController temperatureWarmController = TextEditingController(),
      temperatureColdController = TextEditingController(),
      sunriseController = TextEditingController(),
      sunsetController = TextEditingController(),
      windController = TextEditingController(),
      fellTemperatureController = TextEditingController(),
      humidityController = TextEditingController(),
      hygrometerController = TextEditingController();

  List<String> dayNames = [];

  WeatherLocations weatherLocations =
      Hive.box<WeatherLocations>('WeatherLocations').get('WeatherLocation')!;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      temperatureWarmController.text = WeatherData().maxTemperature;
      temperatureColdController.text = WeatherData().minTemperature;
      sunriseController.text = WeatherData().sunrise;
      sunsetController.text = WeatherData().sunset;
      windController.text = WeatherData().wind;
      fellTemperatureController.text = WeatherData().temperatureFeelsLike;
      humidityController.text = WeatherData().humidity;
      hygrometerController.text = WeatherData().hygrometer != '-'
          ? '${WeatherData().hygrometer} mm'
          : WeatherData().hygrometer;
      dayNames = [
        S.of(context).sun,
        S.of(context).mon,
        S.of(context).tue,
        S.of(context).wed,
        S.of(context).thu,
        S.of(context).fri,
        S.of(context).sat,
      ];
      weatherRefresh = () async => setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    weatherRefresh = () async {};
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: const Color(0x12ffffff),
          borderRadius: BorderRadius.circular(20.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, bottom: 20, right: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 235,
                    height: 30,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                        isExpanded: true,
                        isDense: true,
                        icon: const Visibility(
                            visible: false, child: Icon(Icons.arrow_downward)),
                        dropdownColor: const Color(0xff4a4b5e),
                        borderRadius: BorderRadius.circular(15),
                        items:
                            getMenuItems(weatherLocations.weatherLocationList!),
                        value: weatherLocations.weatherLocation,
                        onChanged: (value) async {
                          weatherLocations.weatherLocation = value;
                          Hive.box<WeatherLocations>('WeatherLocations')
                              .put('WeatherLocation', weatherLocations);
                          await WeatherData().init(dayNames);
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                useRootNavigator: false,
                                builder: (BuildContext context) =>
                                    LocationAddDialog(
                                      callback: refresh,
                                    ));
                          },
                          icon: const Icon(
                            Icons.add,
                            size: 30,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                offset: Offset(0.0, 2.5),
                                blurRadius: 3.0,
                                color: Color.fromARGB(255, 0, 0, 0),
                              )
                            ],
                          )),
                      IconButton(
                          onPressed: () async {
                            await WeatherData().init(dayNames);
                            setState(() {});
                          },
                          icon: const Icon(
                            Icons.refresh,
                            size: 30,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                offset: Offset(0.0, 2.5),
                                blurRadius: 3.0,
                                color: Color.fromARGB(255, 0, 0, 0),
                              )
                            ],
                          )),
                    ],
                  ),
                ]),
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: 10,
                bottom: -10,
                top: -11,
                child: SizedBox(
                  height: 176,
                  width: 120,
                  child: Column(
                    children: [
                      TextField(
                        controller: temperatureWarmController,
                        readOnly: true,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: -6, vertical: 12),
                          icon: SimpleShadow(
                            offset: const Offset(0, 2),
                            opacity: 0.6,
                            child: SvgPicture.asset(
                              "assets/thermometer_warm.svg",
                              width: 34,
                              height: 34,
                            ),
                          ),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        textAlignVertical: TextAlignVertical.center,
                        style: const TextStyle(
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: Offset(0.0, 2.5),
                              blurRadius: 3.0,
                              color: Color.fromARGB(255, 0, 0, 0),
                            )
                          ],
                        ),
                      ),
                      TextField(
                        controller: temperatureColdController,
                        readOnly: true,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: -6, vertical: 12),
                          icon: SimpleShadow(
                            offset: const Offset(0, 2),
                            opacity: 0.6,
                            child: SvgPicture.asset(
                              "assets/thermometer_cold.svg",
                              width: 34,
                              height: 34,
                            ),
                          ),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        textAlignVertical: TextAlignVertical.center,
                        style: const TextStyle(
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: Offset(0.0, 2.5),
                              blurRadius: 3.0,
                              color: Color.fromARGB(255, 0, 0, 0),
                            )
                          ],
                        ),
                      ),
                      TextField(
                        controller: sunriseController,
                        readOnly: true,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: -10, vertical: 12),
                          icon: SimpleShadow(
                            offset: const Offset(0, 2),
                            opacity: 0.6,
                            child: SvgPicture.asset(
                              "assets/sunrise.svg",
                              width: 38,
                              height: 38,
                            ),
                          ),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        textAlignVertical: TextAlignVertical.center,
                        style: const TextStyle(
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: Offset(0.0, 2.5),
                              blurRadius: 3.0,
                              color: Color.fromARGB(255, 0, 0, 0),
                            )
                          ],
                        ),
                      ),
                      TextField(
                        controller: sunsetController,
                        readOnly: true,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: -10, vertical: 12),
                          icon: SimpleShadow(
                            offset: const Offset(0, 2),
                            opacity: 0.6,
                            child: SvgPicture.asset(
                              "assets/sunset.svg",
                              width: 38,
                              height: 38,
                            ),
                          ),
                          isDense: true,
                          border: InputBorder.none,
                        ),
                        textAlignVertical: TextAlignVertical.center,
                        style: const TextStyle(
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: Offset(0.0, 2.5),
                              blurRadius: 3.0,
                              color: Color.fromARGB(255, 0, 0, 0),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    SimpleShadow(
                      offset: const Offset(0, 2),
                      opacity: 0.6,
                      child: SvgPicture.asset(
                        WeatherData().icon,
                        width: 125,
                      ),
                    ),
                    Text(WeatherData().temperature,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              offset: Offset(0.0, 2.5),
                              blurRadius: 3.0,
                              color: Color.fromARGB(255, 0, 0, 0),
                            )
                          ],
                        )),
                  ],
                ),
              ),
              Positioned(
                right: 10,
                bottom: -10,
                top: -11,
                child: SizedBox(
                  height: 176,
                  width: 120,
                  child: Wrap(
                    children: [
                      TextField(
                        controller: hygrometerController,
                        readOnly: true,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 2, vertical: 12),
                          suffixIconConstraints:
                              const BoxConstraints(minHeight: 36, minWidth: 24),
                          suffixIcon: SimpleShadow(
                            offset: const Offset(0, 2),
                            opacity: 0.6,
                            child: SvgPicture.asset(
                              "assets/hygrometer.svg",
                              width: 34,
                              height: 34,
                            ),
                          ),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        textAlignVertical: TextAlignVertical.center,
                        style: const TextStyle(
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: Offset(0.0, 2.5),
                              blurRadius: 3.0,
                              color: Color.fromARGB(255, 0, 0, 0),
                            )
                          ],
                        ),
                        textAlign: TextAlign.end,
                      ),
                      TextField(
                        controller: humidityController,
                        readOnly: true,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 1, vertical: 12),
                          suffixIconConstraints:
                              const BoxConstraints(minHeight: 36, minWidth: 36),
                          suffixIcon: SimpleShadow(
                            offset: const Offset(0, 2),
                            opacity: 0.6,
                            child: SvgPicture.asset(
                              "assets/humidity.svg",
                              width: 36,
                              height: 36,
                            ),
                          ),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        textAlignVertical: TextAlignVertical.center,
                        style: const TextStyle(
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: Offset(0.0, 2.5),
                              blurRadius: 3.0,
                              color: Color.fromARGB(255, 0, 0, 0),
                            )
                          ],
                        ),
                        textAlign: TextAlign.end,
                      ),
                      TextField(
                        controller: fellTemperatureController,
                        readOnly: true,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 1, vertical: 12),
                          suffixIconConstraints:
                              const BoxConstraints(minHeight: 36, minWidth: 36),
                          suffixIcon: SimpleShadow(
                            offset: const Offset(0, 2),
                            opacity: 0.6,
                            child: SvgPicture.asset(
                              "assets/feeling_temperature.svg",
                              width: 36,
                              height: 36,
                            ),
                          ),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        textAlignVertical: TextAlignVertical.center,
                        style: const TextStyle(
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: Offset(0.0, 2.5),
                              blurRadius: 3.0,
                              color: Color.fromARGB(255, 0, 0, 0),
                            )
                          ],
                        ),
                        textAlign: TextAlign.end,
                      ),
                      TextField(
                        controller: windController,
                        readOnly: true,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 2, vertical: 12),
                          suffixIconConstraints:
                              const BoxConstraints(minHeight: 36, minWidth: 36),
                          suffixIcon: SimpleShadow(
                            offset: const Offset(0, 2),
                            opacity: 0.6,
                            child: SvgPicture.asset(
                              "assets/wind.svg",
                              width: 36,
                              height: 36,
                            ),
                          ),
                          isDense: true,
                          border: InputBorder.none,
                        ),
                        textAlignVertical: TextAlignVertical.center,
                        style: const TextStyle(
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: Offset(0.0, 2.5),
                              blurRadius: 3.0,
                              color: Color.fromARGB(255, 0, 0, 0),
                            )
                          ],
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: WeatherData().forecasts,
            ),
          ),
        ],
      ),
    );
  }

  refresh(Weather data) async {
    await WeatherData().init(dayNames, w: data);
    setState(() {});
  }

  final rightDeleteIcon = Container(
    alignment: Alignment.centerRight,
    child: const Icon(Icons.delete),
  );

  List<DropdownMenuItem<String>> getMenuItems(List<String> locations) {
    List<DropdownMenuItem<String>> items = [];
    for (var element in locations) {
      items.add(DropdownMenuItem(
        value: element,
        child: Dismissible(
          key: Key(element),
          confirmDismiss: (direction) async {
            return await sureDialog(element);
          },
          direction: weatherLocations.weatherLocation == element
              ? DismissDirection.none
              : DismissDirection.endToStart,
          background: rightDeleteIcon,
          onDismissed: (direction) {
            weatherLocations.weatherLocationList!
                .removeWhere((item) => item == element);
            Hive.box<WeatherLocations>('WeatherLocations')
                .put('WeatherLocation', weatherLocations);
            /*dropdownButton!.items =
                getMenuItems(weatherLocations.weatherLocationList!);*/
            setState(() {});
          },
          //secondaryBackground: rightDeleteIcon,
          child: SizedBox(
              width: 230,
              child: Text(
                element,
                style: const TextStyle(
                  shadows: [
                    Shadow(
                      offset: Offset(0.0, 2.5),
                      blurRadius: 3.0,
                      color: Color.fromARGB(255, 0, 0, 0),
                    )
                  ],
                ),
              )),
        ),
      ));
    }
    return items;
  }

  Future<bool> sureDialog(String element) async {
    //bool delete;
    showDialog(
        context: context,
        builder: (context) {
          final delegate = S.of(context);
          return AlertDialog(
            title: Text(
              delegate.weatherDialogDeleteTitle,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
            ),
            content: Text(
              delegate.weatherDialogDeleteMessage,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(28.0))),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    //delete = false;
                  },
                  child: Text(
                    delegate.weatherDialogDeleteButtonCancel,
                    style: const TextStyle(color: Colors.white),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    //delete = true;
                  },
                  child: Text(
                    delegate.weatherDialogDeleteButtonDelete,
                    style: const TextStyle(color: Colors.white),
                  )),
            ],
            backgroundColor: const Color(0xff4a4b5e),
          );
        });
    return Future.value(true);
  }
}
