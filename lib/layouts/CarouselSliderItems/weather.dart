import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:smarthome/Model/weatherLocations.dart';
import 'package:smarthome/utils/locationAddDialog.dart';
import 'package:smarthome/utils/weatherData.dart';
import 'package:weather/weather.dart';

class WeatherLayout extends StatefulWidget {
  const WeatherLayout({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WeatherLayoutDesign();
}

class _WeatherLayoutDesign extends State<WeatherLayout> {
  TextEditingController sunriseController = TextEditingController(),
      sunsetController = TextEditingController(),
      windController = TextEditingController(),
      fellTemperatureController = TextEditingController(),
      humidityController = TextEditingController();

  WeatherLocations weatherLocations =
      Hive.box<WeatherLocations>('WeatherLocations').get('WeatherLocation')!;

  @override
  void initState() {
    super.initState();
    sunriseController.text = WeatherData().sunrise;
    sunsetController.text = WeatherData().sunset;
    windController.text = WeatherData().wind;
    fellTemperatureController.text = WeatherData().temperatureFeelsLike;
    humidityController.text = WeatherData().humidity;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      width: double.infinity,
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
                      child: DropdownButton<String>(
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
                          await WeatherData().init();
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
                          )),
                      IconButton(
                          onPressed: () async {
                            await WeatherData().init();
                            setState(() {});
                          },
                          icon: const Icon(
                            Icons.refresh,
                            size: 30,
                            color: Colors.white,
                          )),
                    ],
                  ),
                ]),
          ),
          IntrinsicHeight(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned(
                  left: 10,
                  bottom: -10,
                  child: SizedBox(
                    height: 90,
                    width: 120,
                    child: Column(
                      children: [
                        TextField(
                          controller: sunriseController,
                          readOnly: true,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: -10, vertical: 12),
                            icon: SvgPicture.asset(
                              "assets/sunrise.svg",
                              width: 38,
                              height: 38,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                          textAlignVertical: TextAlignVertical.center,
                          style: const TextStyle(color: Colors.white),
                        ),
                        TextField(
                          controller: sunsetController,
                          readOnly: true,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: -10, vertical: 12),
                            icon: SvgPicture.asset(
                              "assets/sunset.svg",
                              width: 38,
                              height: 38,
                            ),
                            isDense: true,
                            border: InputBorder.none,
                          ),
                          textAlignVertical: TextAlignVertical.center,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        WeatherData().icon,
                        width: 125,
                      ),
                      Text(WeatherData().temperature,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Positioned(
                  right: 10,
                  bottom: -10,
                  child: SizedBox(
                    height: 140,
                    width: 120,
                    child: Column(
                      children: [
                        TextField(
                          controller: humidityController,
                          readOnly: true,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 12),
                            suffixIconConstraints: const BoxConstraints(
                                minHeight: 36, minWidth: 36),
                            suffixIcon: SvgPicture.asset(
                              "assets/hygrometer.svg",
                              width: 36,
                              height: 36,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                          textAlignVertical: TextAlignVertical.center,
                          style: const TextStyle(color: Colors.white),
                          textAlign: TextAlign.end,
                        ),
                        TextField(
                          controller: fellTemperatureController,
                          readOnly: true,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 12),
                            suffixIconConstraints: const BoxConstraints(
                                minHeight: 36, minWidth: 36),
                            suffixIcon: SvgPicture.asset(
                              "assets/feeling_temperature.svg",
                              width: 36,
                              height: 36,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                          textAlignVertical: TextAlignVertical.center,
                          style: const TextStyle(color: Colors.white),
                          textAlign: TextAlign.end,
                        ),
                        TextField(
                          controller: windController,
                          readOnly: true,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 12),
                            suffixIconConstraints: const BoxConstraints(
                                minHeight: 36, minWidth: 36),
                            suffixIcon: SvgPicture.asset(
                              "assets/wind.svg",
                              width: 36,
                              height: 36,
                            ),
                            isDense: true,
                            border: InputBorder.none,
                          ),
                          textAlignVertical: TextAlignVertical.center,
                          style: const TextStyle(color: Colors.white),
                          textAlign: TextAlign.end,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
    await WeatherData().init(w: data);
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
          confirmDismiss: (direction) {
            return sureDialog(element);
          },
          direction: weatherLocations.weatherLocation == element
              ? DismissDirection.none
              : DismissDirection.endToStart,
          background: rightDeleteIcon,
          //secondaryBackground: rightDeleteIcon,
          child: SizedBox(width: 230, child: Text(element)),
        ),
      ));
    }
    return items;
  }

  Future<bool> sureDialog(String element) {
    Future<bool> delete = Future.value(false);
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Delete?',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
            ),
            content: const Text(
              'Do you really want to delete this City?',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      weatherLocations.weatherLocationList!
                          .removeWhere((item) => item == element);
                    });
                    Navigator.of(context).pop();
                    delete = Future.value(true);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    delete = Future.value(false);
                  },
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.white),
                  )),
            ],
            backgroundColor: const Color(0xff4a4b5e),
          );
        });
    return delete;
  }
}
