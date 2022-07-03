import 'package:flutter/foundation.dart';

import '../JSON/device_data.dart';
import 'CURL_Request.dart';

class Devices {
  late List<DeviceData> devices,
      _lights,
      _sockets,
      _shutters,
      _airConditioners,
      _videoDevices,
      _heatingSystems,
      _kitchenTools,
      _washingMachines,
      _irrigations;

  double _lightEnergy = 0,
      _socketEnergy = 0,
      _shutterEnergy = 0,
      _airConditionerEnergy = 0,
      _videoDevicesEnergy = 0,
      _heatingSystemEnergy = 0,
      _kitchenToolsEnergy = 0,
      _washingMachineEnergy = 0,
      _irrigationEnergy = 0;

  final List<String> _energyList = List.filled(9, '0.0');

  static final Devices _instance = Devices._internal();

  factory Devices() => _instance;

  Devices._internal() {
    init();
  }

  void init() async {
    List<dynamic> deviceData = await CURL_Request()
        .getRequest(Uri.parse('http://192.168.0.29:8123/api/states'));
    devices = [];
    for (var element in deviceData) {
      devices.add(DeviceData.fromJson(element));
    }
    _lights = [];
    _lights.addAll(
        devices.where((element) => element.entityId!.contains('ligth.')));
    _sockets = [];
    _sockets.addAll(
        devices.where((element) => element.entityId!.contains('switch.')));
    _shutters = [];
    _shutters.addAll(
        devices.where((element) => element.entityId!.contains('cover.')));
    _airConditioners = [];
    _airConditioners
        .addAll(devices.where((element) => element.entityId!.contains('fan.')));
    _videoDevices = [];
    _videoDevices.addAll(devices
        .where((element) => element.entityId!.contains('media_player.')));
    _heatingSystems = [];
    _heatingSystems.addAll(
        devices.where((element) => element.entityId!.contains('switch.')));
    _kitchenTools = [];
    _kitchenTools.addAll(
        devices.where((element) => element.entityId!.contains('switch.')));
    _washingMachines = [];
    _washingMachines.addAll(
        devices.where((element) => element.entityId!.contains('switch.')));
    _irrigations = [];
    _irrigations.addAll(
        devices.where((element) => element.entityId!.contains('switch.')));

    for (var device in _lights) {
      try {
        _lightEnergy += double.parse(device.energy = devices
            .singleWhere((sensor) =>
                sensor.attributes!.unitOfMeasurement == 'kWh' &&
                sensor.entityId!.contains(device.entityId!
                    .substring(device.entityId!.indexOf('.') + 1)))
            .state!);
      } catch (_) {
        if (kDebugMode) {
          print('no sensor available for energy usage');
        }
      }
    }
    for (var device in _sockets) {
      try {
        _socketEnergy += double.parse(device.energy = devices
            .singleWhere((sensor) =>
                sensor.attributes!.unitOfMeasurement == 'kWh' &&
                sensor.entityId!.contains(device.entityId!
                    .substring(device.entityId!.indexOf('.') + 1)))
            .state!);
      } catch (_) {
        if (kDebugMode) {
          print('no sensor available for energy usage');
        }
      }
    }
    for (var device in _shutters) {
      try {
        _shutterEnergy += double.parse(device.energy = devices
            .singleWhere((sensor) =>
                sensor.attributes!.unitOfMeasurement == 'kWh' &&
                sensor.entityId!.contains(device.entityId!
                    .substring(device.entityId!.indexOf('.') + 1)))
            .state!);
      } catch (_) {
        if (kDebugMode) {
          print('no sensor available for energy usage');
        }
      }
    }
    for (var device in _airConditioners) {
      try {
        _airConditionerEnergy += double.parse(device.energy = devices
            .singleWhere((sensor) =>
                sensor.attributes!.unitOfMeasurement == 'kWh' &&
                sensor.entityId!.contains(device.entityId!
                    .substring(device.entityId!.indexOf('.') + 1)))
            .state!);
      } catch (_) {
        if (kDebugMode) {
          print('no sensor available for energy usage');
        }
      }
    }
    for (var device in _videoDevices) {
      try {
        _videoDevicesEnergy += double.parse(device.energy = devices
            .singleWhere((sensor) =>
                sensor.attributes!.unitOfMeasurement == 'kWh' &&
                sensor.entityId!.contains(device.entityId!
                    .substring(device.entityId!.indexOf('.') + 1)))
            .state!);
      } catch (_) {
        if (kDebugMode) {
          print('no sensor available for energy usage');
        }
      }
    }
    for (var device in _heatingSystems) {
      try {
        _heatingSystemEnergy += double.parse(device.energy = devices
            .singleWhere((sensor) =>
                sensor.attributes!.unitOfMeasurement == 'kWh' &&
                sensor.entityId!.contains(device.entityId!
                    .substring(device.entityId!.indexOf('.') + 1)))
            .state!);
      } catch (_) {
        if (kDebugMode) {
          print('no sensor available for energy usage');
        }
      }
    }
    for (var device in _kitchenTools) {
      try {
        _kitchenToolsEnergy += double.parse(device.energy = devices
            .singleWhere((sensor) =>
                sensor.attributes!.unitOfMeasurement == 'kWh' &&
                sensor.entityId!.contains(device.entityId!
                    .substring(device.entityId!.indexOf('.') + 1)))
            .state!);
      } catch (_) {
        if (kDebugMode) {
          print('no sensor available for energy usage');
        }
      }
    }
    for (var device in _washingMachines) {
      try {
        _washingMachineEnergy += double.parse(device.energy = devices
            .singleWhere((sensor) =>
                sensor.attributes!.unitOfMeasurement == 'kWh' &&
                sensor.entityId!.contains(device.entityId!
                    .substring(device.entityId!.indexOf('.') + 1)))
            .state!);
      } catch (_) {
        if (kDebugMode) {
          print('no sensor available for energy usage');
        }
      }
    }
    for (var device in _irrigations) {
      try {
        _irrigationEnergy += double.parse(device.energy = devices
            .singleWhere((sensor) =>
                sensor.attributes!.unitOfMeasurement == 'kWh' &&
                sensor.entityId!.contains(device.entityId!
                    .substring(device.entityId!.indexOf('.') + 1)))
            .state!);
      } catch (_) {
        if (kDebugMode) {
          print('no sensor available for energy usage');
        }
      }
    }

    _energyList.setAll(0, [
      _lightEnergy.toStringAsPrecision(2),
      _socketEnergy.toStringAsPrecision(2),
      _shutterEnergy.toStringAsPrecision(2),
      _airConditionerEnergy.toStringAsPrecision(2),
      _videoDevicesEnergy.toStringAsPrecision(2),
      _heatingSystemEnergy.toStringAsPrecision(2),
      _kitchenToolsEnergy.toStringAsPrecision(2),
      _washingMachineEnergy.toStringAsPrecision(2),
      _irrigationEnergy.toStringAsPrecision(2)
    ]);
  }

  List<DeviceData> get getIrrigations => _irrigations;

  List<DeviceData> get getWashingMachines => _washingMachines;

  List<DeviceData> get getKitchenTools => _kitchenTools;

  List<DeviceData> get getHeatingSystems => _heatingSystems;

  List<DeviceData> get getVideoDevices => _videoDevices;

  List<DeviceData> get getAirConditioners => _airConditioners;

  List<DeviceData> get getShutters => _shutters;

  List<DeviceData> get getSockets => _sockets;

  List<DeviceData> get getLights => _lights;

  List<String> get getEnergyList => _energyList;
}
