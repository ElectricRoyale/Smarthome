import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
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

  final List _roomList = [];
  final Map<String, List<DeviceData>> _roomDevicesMap = {};

  static final DashboadData _instance = DashboadData._internal();

  factory DashboadData() => _instance;

  DashboadData._internal() {
    init();
  }

  void init() async {
    List<Map> responses = await HomeAssistantConnection().send([
      '{"type" : "config/area_registry/list", "id" : "${idNumber++}"}',
      '{"type" : "config/device_registry/list", "id" : "${idNumber++}"}',
      '{"type" : "config/entity_registry/list", "id" : "${idNumber++}"}',
      '{"type" : "get_states", "id" : "${idNumber++}"}'
    ]);
    List roomData = responses.elementAt(2)["result"];
    List roomDevices = responses.elementAt(3)["result"];
    List entitys = responses.elementAt(4)["result"];
    List deviceData = responses.elementAt(5)["result"];
    allDevices = [];
    devices = [];
    for (var element in deviceData) {
      devices.add(DeviceData.fromJson(element));
    }
    _roomDevicesMap.clear();
    for (var roomName in roomData) {
      List<DeviceData> enddevice = [];
      roomDevices
          .where((device) => device["area_id"] == roomName["area_id"])
          .toList()
          .forEach((device) {
           //String name = entitys.singleWhere((entity) => entity["device_id"] == device["id"])["name"];
        enddevice
            .add(devices.firstWhere((id) => id.attributes!.friendlyName == device["name"]));
      });
      _roomDevicesMap[roomName["area_id"]] = enddevice;
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

    _roomList.clear();
    for (var value in roomData) {
      double energy = 0.0;
      for (var device in _roomDevicesMap[value["area_id"]]!) {
        energy += double.parse(
            device.energy != 'Unavailable' ? device.energy : '0.0');
      }
      _roomList.add({
        'icon': 'bed.svg',
        'name': '${value['name']}',
        'appliances': roomDeviceIcons(value["area_id"]),
        'energyConsumption': '$energy KW USED'
      });
    }
    allDevices.sort((a, b) => a.attributes!.friendlyName!
        .toLowerCase()
        .compareTo(b.attributes!.friendlyName!.toLowerCase()));
  }

  List<Widget> roomDeviceIcons(String roomName) {
    List<Widget> items = [];
    for (var device in _roomDevicesMap[roomName]!) {
      IconData icon = Icons.error_outline;
      switch (device.entityId!.substring(0, device.entityId!.indexOf('.'))) {
        case 'light':
          icon = Icons.lightbulb_outlined;
          break;
        case 'switch':
          icon = MdiIcons.powerSocketDe;
          break;
        case 'cover':
          icon = MdiIcons.windowShutter;
          break;
        case 'fan':
          icon = MdiIcons.airConditioner;
          break;
        case 'media_player':
          icon = Icons.tv_rounded;
          break;
        case 'heating_system':
          icon = Icons.hvac_outlined;
          break;
        case 'kitchen':
          icon = Icons.kitchen_outlined;
          break;
        case 'washing_machine':
          icon = Icons.local_laundry_service_outlined;
          break;
        case 'irrigation':
          icon = MdiIcons.wateringCanOutline;
          break;
        default:
          icon = Icons.error_outline;
          break;
      }
      items.add(itemContainer(icon, 24));
    }
    return items;
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
