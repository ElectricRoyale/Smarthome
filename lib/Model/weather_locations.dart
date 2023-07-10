import 'package:hive/hive.dart';

part 'weather_locations.g.dart';

@HiveType(typeId: 1)
class WeatherLocations extends HiveObject {
  @HiveField(0)
  late List<String>? weatherLocationList;

  @HiveField(1)
  late String? weatherLocation;

  WeatherLocations({this.weatherLocationList, this.weatherLocation});
}
