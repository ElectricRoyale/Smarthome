import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sprintf/sprintf.dart';
import 'package:weather/weather.dart';

class WeatherData {
  final WeatherFactory _weather =
      WeatherFactory("ab4d16747f052431ba606ea20103f65c");
  String _icon = "assets/sun.svg",
      _temperature = "-",
      _sunrise = '-',
      _sunset = '-',
      _temperatureFeelsLike = '-',
      _wind = '-',
      _humidity = '-';
  final List<String> _dayNames = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ];
  final List<Widget> _forecasts = [];

  static final WeatherData _instance = WeatherData._internal();

  factory WeatherData() => _instance;

  WeatherData._internal() {
    init();
  }

  Future<void> init() async {
    forecasts.clear();
    Weather w = await _weather.currentWeatherByCityName('Speyer');
    _icon = _getIcon(w.weatherDescription!);
    _temperature = "${w.temperature!.celsius!.toStringAsPrecision(2)}°";
    _sunrise = sprintf('%02i:%02i', [w.sunrise!.hour, w.sunrise!.minute]);
    _sunset = sprintf('%02i:%02i', [w.sunset!.hour, w.sunset!.minute]);
    _temperatureFeelsLike =
        '${w.tempFeelsLike!.celsius!.toStringAsPrecision(2)}°';
    _wind = '${w.windSpeed!.toStringAsPrecision(2)} km/h';
    _humidity = '${w.humidity!.toStringAsPrecision(2)} g/m³';

    List<Weather> w1 = await _weather.fiveDayForecastByCityName("Hockenheim");
    w1.removeWhere((element) => element.date!.day == DateTime.now().day);
    List<Map<String, dynamic>> days = [];

    while (w1.isNotEmpty) {
      Map<String, dynamic> dayData = {};
      List<Weather> weatherData = [];
      weatherData.addAll(w1.where(
          (element) => element.date!.weekday == w1.elementAt(0).date!.weekday));
      w1.removeRange(0, weatherData.length);
      List<int> mintemp = [];
      List<int> maxtemp = [];
      for (var element in weatherData) {
        mintemp
            .add(int.parse(element.tempMin!.celsius!.toStringAsPrecision(2)));
        maxtemp
            .add(int.parse(element.tempMax!.celsius!.toStringAsPrecision(2)));
      }

      dayData['dayName'] =
          dayNames.elementAt(weatherData.elementAt(0).date!.weekday - 1);
      dayData['tempMin'] =
          mintemp.reduce((curr, next) => curr < next ? curr : next);
      dayData['tempMax'] =
          maxtemp.reduce((curr, next) => curr > next ? curr : next);
      dayData['weatherDescription'] =
          weatherData.elementAt(0).weatherDescription;

      days.add(dayData);
    }

    for (var weatherData in days) {
      _forecasts.add(_forecast(
          weatherData['dayName'],
          _getIcon(weatherData['weatherDescription']),
          '${weatherData['tempMax']}°',
          '${weatherData['tempMin']}°'));
    }
  }

  String _getIcon(String name) {
    switch (name) {
      case 'clear sky':
        return "assets/sun.svg";
      case 'few clouds':
        return "assets/partly_cloudy.svg";
      case 'scattered clouds':
        return 'assets/cloud.svg';
      case 'overcast clouds':
      case 'broken clouds':
        return 'assets/broken_cloud.svg';
      case 'light intensity drizzle':
      case 'drizzle':
      case 'heavy intensity drizzle':
        return 'assets/light_Drizzle.svg';
      case 'light intensity drizzle rain':
      case 'drizzle rain':
      case 'heavy intensity drizzle rain':
        return 'assets/Drizzle.svg';
      case 'shower rain and drizzle':
      case 'heavy shower rain and drizzle':
      case 'shower drizzle':
        return 'assets/heavy_Drizzle.svg';
      case 'light rain':
      case 'moderate rain':
        return 'assets/light_rain.svg';
      case 'heavy intensity rain':
      case 'very heavy rain':
      case 'rain':
      case 'extreme rain':
        return 'rain.svg';
      case 'light intensity shower rain':
      case 'heavy intensity shower rain':
      case 'ragged shower rain':
      case 'shower rain':
        return 'heavy_rain.svg';
      case 'thunderstorm with light drizzle':
      case 'thunderstorm with drizzle':
      case 'thunderstorm with heavy drizzle':
        return 'assets/storm_with_light_rain.svg';
      case 'thunderstorm with light rain':
      case 'thunderstorm with rain':
      case 'thunderstorm with heavy rain':
        return 'assets/storm_with_heavy_rain.svg';
      case 'light thunderstorm':
      case 'thunderstorm':
      case 'heavy thunderstorm':
      case 'ragged thunderstorm':
        return 'assets/cloud_lightning.svg';
      case 'freezing rain':
        return 'assets/hail.svg';
      case 'Sleet':
      case 'Light shower sleet':
      case 'Shower sleet':
      case 'Light rain and snow':
      case 'Rain and snow':
        return 'assets/sleet.svg';
      case 'light snow':
        return 'assets/light_snow.svg';
      case 'Snow':
      case 'Heavy snow':
        return 'assets/snow.svg';
      case 'Shower snow':
      case 'Heavy shower snow':
        return 'assets/snow_storm.svg';
      case 'Haze':
      case 'Smoke':
      case 'volcanic ash':
      case 'mist':
      case 'fog':
      case 'dust':
      case 'sand/ dust whirls':
        return 'assets/dust.svg';
      case 'squalls':
        return 'assets/windy_weather.svg';
      case 'tornado':
        return 'assets/tornado.svg';
      default:
        print(name);
        return 'assets/error.svg';
    }
  }

  Widget _forecast(
      String day, String icon, String maxTemperature, String minTemperature) {
    return Column(
      children: [
        Text(day,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        SvgPicture.asset(
          icon,
          width: 60,
        ),
        Text(maxTemperature,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        Text(minTemperature,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
      ],
    );
  }

  List<Widget> get forecasts => _forecasts;

  List<String> get dayNames => _dayNames;

  get humidity => _humidity;

  get wind => _wind;

  get temperatureFeelsLike => _temperatureFeelsLike;

  get sunset => _sunset;

  get sunrise => _sunrise;

  get temperature => _temperature;

  String get icon => _icon;
}
