import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smarthome/utils/Home_Assistant_Connection.dart';
import 'package:smarthome/utils/globals.dart';
import 'package:smarthome/utils/widget_functions.dart';

import '../JSON/device_data.dart';

class DashboadData {
  late List<DeviceData> devices,
      _lights,
      _sockets,
      _shutters,
      _airConditioners,
      _videoDevices,
      _heatingSystems,
      _kitchenTools,
      _washingMachines,
      _irrigations,
      allDevices;

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

  late List _roomList, _roomDevices;
  late Map _roomDevicesMap;

  static final DashboadData _instance = DashboadData._internal();

  factory DashboadData() => _instance;

  DashboadData._internal() {
    init();
  }

  void init() async {
    Map roomData = await HomeAssistantConnection()
        .send('{"type" : "config/area_registry/list", "id" : "${idNumber++}"}');
    Map roomDevices = await HomeAssistantConnection().send(
        '{"type" : "config/device_registry/list", "id" : "${idNumber++}"}');
    _roomDevices = roomDevices["result"];
    _roomDevices.removeWhere((element) => element["area_id"] == null);
    List result = roomData["result"];
    Map deviceData = await HomeAssistantConnection()
        .send('{"type" : "get_states", "id" : "${idNumber++}"}');
    allDevices = [];
    devices = [];
    for (var element in deviceData["result"]) {
      devices.add(DeviceData.fromJson(element));
    }
    List
    _roomDevices.forEach((element) {devices.singleWhere((element) => element)});
    _roomDevicesMap.
    for (var value in result) {
      _roomList.add({
        'icon': 'bed.svg',
        'name': '${value['name']}',
        'appliances': [
          itemContainer(Icons.lightbulb_outline_rounded, 24),
        ],
        'energyConsumption': '0 KW USED'
      });
    }
    _lights = [];
    _lights.addAll(
        devices.where((element) => element.entityId!.contains('light.')));
    for (var element in _lights) {
      element.icon = 'light.svg';
    }
    allDevices.addAll(_lights);
    _sockets = [];
    _sockets.addAll(
        devices.where((element) => element.entityId!.contains('switch.')));
    for (var element in _sockets) {
      element.icon = 'socket.svg';
    }
    allDevices.addAll(_sockets);
    _shutters = [];
    _shutters.addAll(
        devices.where((element) => element.entityId!.contains('cover.')));
    for (var element in _shutters) {
      element.icon = 'shutter.svg';
    }
    allDevices.addAll(_shutters);
    _airConditioners = [];
    _airConditioners
        .addAll(devices.where((element) => element.entityId!.contains('fan.')));
    for (var element in _airConditioners) {
      element.icon = 'Air_conditioner.svg';
    }
    allDevices.addAll(_airConditioners);
    _videoDevices = [];
    _videoDevices.addAll(devices
        .where((element) => element.entityId!.contains('media_player.')));
    for (var element in _videoDevices) {
      element.icon = 'television.svg';
    }
    allDevices.addAll(_videoDevices);
    _heatingSystems = [];
    _heatingSystems.addAll(devices
        .where((element) => element.entityId!.contains('heating_system.')));
    for (var element in _heatingSystems) {
      element.icon = 'heating_system.svg';
    }
    allDevices.addAll(_heatingSystems);
    _kitchenTools = [];
    _kitchenTools.addAll(
        devices.where((element) => element.entityId!.contains('kitchen.')));
    for (var element in _kitchenTools) {
      element.icon = 'kitchen_tools.svg';
    }
    allDevices.addAll(_kitchenTools);
    _washingMachines = [];
    _washingMachines.addAll(devices
        .where((element) => element.entityId!.contains('washing_machine.')));
    for (var element in _washingMachines) {
      element.icon = 'washing_machine.svg';
    }
    allDevices.addAll(_washingMachines);
    _irrigations = [];
    _irrigations.addAll(
        devices.where((element) => element.entityId!.contains('irrigation.')));
    for (var element in _irrigations) {
      element.icon = 'garden.svg';
    }
    allDevices.addAll(_heatingSystems);

    _lightEnergy = 0;
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

    _socketEnergy = 0;
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

    _shutterEnergy = 0;
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

    _airConditionerEnergy = 0;
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

    _videoDevicesEnergy = 0;
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

    _heatingSystemEnergy = 0;
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

    _kitchenToolsEnergy = 0;
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

    _washingMachineEnergy = 0;
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

    _irrigationEnergy = 0;
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
    allDevices.sort((a, b) => a.attributes!.friendlyName!
        .toLowerCase()
        .compareTo(b.attributes!.friendlyName!.toLowerCase()));
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

  List<DeviceData> get getAllDevices => allDevices;

  List get getRooms => _roomList;
}
