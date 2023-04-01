import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:smarthome/Model/weatherLocations.dart';
import 'package:sprintf/sprintf.dart';
import 'package:weather/weather.dart';

class WeatherData {
  final WeatherFactory weather =
      WeatherFactory("ab4d16747f052431ba606ea20103f65c");
  String _icon = "assets/error.svg",
      _temperature = "-",
      _sunrise = '-',
      _sunset = '-',
      _minTemperature = '-',
      _maxTemperature = '-',
      _temperatureFeelsLike = '-',
      _wind = '-',
      _hygrometer = '-',
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

  Future? _isInitialized;

  final List<Widget> _forecasts = [];

  static final WeatherData _instance = WeatherData._internal();

  factory WeatherData() => _instance;

  WeatherData._internal() {
    _isInitialized = init();
  }

  Box<WeatherLocations> weatherLocations =
      Hive.box<WeatherLocations>('WeatherLocations');

  Future<void> init({Weather? w}) async {
    forecasts.clear();

    String cityName = (weatherLocations.get('WeatherLocation') != null
        ? weatherLocations.get('WeatherLocation')!.weatherLocation
        : await locationName())!;

    w ??= await weather.currentWeatherByCityName(cityName);
    _icon = _getIcon(w.weatherDescription!);
    _temperature = "${w.temperature!.celsius!.toStringAsPrecision(2)}°";
    _sunrise = sprintf('%02i:%02i', [w.sunrise!.hour, w.sunrise!.minute]);
    _sunset = sprintf('%02i:%02i', [w.sunset!.hour, w.sunset!.minute]);
    _minTemperature = "${w.tempMin!.celsius!.toStringAsPrecision(2)}°";
    _maxTemperature = "${w.tempMax!.celsius!.toStringAsPrecision(2)}°";
    _temperatureFeelsLike =
        '${w.tempFeelsLike!.celsius!.toStringAsPrecision(2)}°';
    _wind = '${w.windSpeed!.toStringAsPrecision(2)} km/h';
    _hygrometer = w.rainLast3Hours?.toStringAsPrecision(2) ?? '-';
    _humidity = '${w.humidity!.toStringAsPrecision(2)}%';

    List<Weather> w1 = await weather.fiveDayForecastByCityName(cityName);
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
        mintemp.add(element.tempMin!.celsius!.round());
        maxtemp.add(element.tempMax!.celsius!.round());
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

  Future<String> locationName() async {
    Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best)
        .timeout(const Duration(seconds: 5));
    List<Placemark> test =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    String name = test.first.locality!;
    WeatherLocations weatherSave =
        WeatherLocations(weatherLocationList: [name], weatherLocation: name);
    weatherLocations.put('WeatherLocation', weatherSave);
    return name;
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
        if (kDebugMode) {
          print(name);
        }
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
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  offset: Offset(0.0, 2.5),
                  blurRadius: 3.0,
                  color: Color.fromARGB(255, 0, 0, 0),
                )
              ],
            )),
        SimpleShadow(
          opacity: 0.6,
          offset: const Offset(0, 2),
          child: SvgPicture.asset(
            icon,
            width: 60,
          ),
        ),
        Text(maxTemperature,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  offset: Offset(0.0, 2.5),
                  blurRadius: 3.0,
                  color: Color.fromARGB(255, 0, 0, 0),
                )
              ],
            )),
        Text(minTemperature,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
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
    );
  }

  List<Widget> get forecasts => _forecasts;

  List<String> get dayNames => _dayNames;

  get humidity => _humidity;

  get wind => _wind;

  get temperatureFeelsLike => _temperatureFeelsLike;

  get minTemperature => _minTemperature;

  get maxTemperature => _maxTemperature;

  get sunset => _sunset;

  get sunrise => _sunrise;

  get temperature => _temperature;

  get hygrometer => _hygrometer;

  String get icon => _icon;

  Future get isInitialized => _isInitialized!;
}
