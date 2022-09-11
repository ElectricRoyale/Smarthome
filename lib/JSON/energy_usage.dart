import 'energy_sensor_data.dart';

class EnergyUsage {
  Map<String, List<EnergySensorData>> energySensorList = {};

  EnergyUsage({required this.energySensorList});

  EnergyUsage.fromJson(Map<String, dynamic> json) {
    json.forEach((key, value) {});
  }

  Map<String, dynamic> toJson(String name) {
    return energySensorList;
  }
}
