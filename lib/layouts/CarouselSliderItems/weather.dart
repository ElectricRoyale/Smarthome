import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smarthome/utils/weatherData.dart';

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
                  const Text(
                    "Hockenheim",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
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
                              "assets/thermometer.svg",
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
}
