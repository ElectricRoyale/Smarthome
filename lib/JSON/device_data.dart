import 'package:smarthome/JSON/energy_sensor_data.dart';

import 'attributes.dart';
import 'context.dart';

class DeviceData {
  String? entityId;
  String? state;
  Attributes? attributes;
  String? lastChanged;
  String? lastUpdated;
  Context? context;
  String energy = 'Unavailable';
  String? icon;
  List<EnergySensorData> energyUsageData = [];
  DeviceData? secondZone;

  DeviceData(
      {this.entityId,
      this.state,
      this.attributes,
      this.lastChanged,
      this.lastUpdated,
      this.context});

  DeviceData.fromJson(Map<String, dynamic> json) {
    entityId = json['entity_id'];
    state = json['state'];
    attributes = json['attributes'] != null
        ? Attributes.fromJson(json['attributes'])
        : null;
    lastChanged = json['last_changed'];
    lastUpdated = json['last_updated'];
    context =
        json['context'] != null ? Context.fromJson(json['context']) : null;
  }

  void update(DeviceData deviceData) {
    entityId = deviceData.entityId;
    state = deviceData.state;
    attributes!.update(deviceData.attributes!);
    lastChanged = deviceData.lastChanged;
    lastUpdated = deviceData.lastUpdated;
    context = deviceData.context;
    secondZone = deviceData.secondZone ?? secondZone;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['entity_id'] = entityId;
    data['state'] = state;
    if (attributes != null) {
      data['attributes'] = attributes!.toJson();
    }
    data['last_changed'] = lastChanged;
    data['last_updated'] = lastUpdated;
    if (context != null) {
      data['context'] = context!.toJson();
    }
    return data;
  }
}
