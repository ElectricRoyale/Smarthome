import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smarthome/JSON/energy_sensor_data.dart';
import 'package:smarthome/utils/Home_Assistant_Connection.dart';
import 'package:smarthome/utils/globals.dart';
import 'package:smarthome/utils/widget_functions.dart';

import '../JSON/device_data.dart';

class DashboadData {
  final List<DeviceData> devices = [],
      _lights = [],
      _sockets = [],
      _shutters = [],
      _airConditioners = [],
      _videoDevices = [],
      _heatingSystems = [],
      _kitchenTools = [],
      _washingMachines = [],
      _irrigation = [],
      allDevices = [];

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

  Future? _isInitialized;

  BuildContext? context;

  static final DashboadData _instance = DashboadData._internal();

  factory DashboadData() => _instance;

  DashboadData._internal() {
    init();
  }

  Future<void> init() async {
    initialisation = true;
    List<int> idList = [];
    for (int i = 0; i < 4; i++) {
      idList.add(idNumber++);
    }
    ids = idList;
    DateTime dateTime = DateTime.now();
    HomeAssistantConnection().send([
      '{"type" : "config/area_registry/list", "id" : "${idList.elementAt(0)}"}',
      '{"type" : "config/device_registry/list", "id" : "${idList.elementAt(1)}"}',
      '{"type" : "get_states", "id" : "${idList.elementAt(2)}"}',
      '{"id" : "${idList.elementAt(3)}","type" : "recorder/statistics_during_period", "period" : "hour", "start_time" : "${DateTime(dateTime.year, dateTime.month, dateTime.day - 1, dateTime.hour)}"}',
      '{"id": ${idNumber++}, "type": "subscribe_events", "event_type": "state_changed"}',
    ]);
    _isInitialized = Future.delayed(const Duration(seconds: 2));
  }

  void setData(List<Map> responses) {
    List roomData = responses.elementAt(0)["result"];
    List roomDevices = responses.elementAt(1)["result"];
    List deviceData = responses.elementAt(2)["result"];
    Map<String, dynamic> energySensorResponseData =
        responses.elementAt(3)["result"];
    allDevices.clear();
    devices.clear();
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
        try {
          enddevice.add(devices.firstWhere(
              (id) => id.attributes!.friendlyName == device["name"]));
        } catch (_) {}
      });
      _roomDevicesMap[roomName["area_id"]] = enddevice;
    }
    _lights.clear();
    _lights.addAll(
        devices.where((element) => element.entityId!.contains('light.')));
    for (var element in _lights) {
      element.icon = 'light.svg';
    }
    allDevices.addAll(_lights);
    _sockets.clear();
    _sockets.addAll(
        devices.where((element) => element.entityId!.contains('switch.')));
    for (var element in _sockets) {
      element.icon = 'socket.svg';
    }
    allDevices.addAll(_sockets);
    _shutters.clear();
    _shutters.addAll(
        devices.where((element) => element.entityId!.contains('cover.')));
    for (var element in _shutters) {
      element.icon = 'shutter.svg';
    }
    allDevices.addAll(_shutters);
    _airConditioners.clear();
    _airConditioners
        .addAll(devices.where((element) => element.entityId!.contains('fan.')));
    for (var element in _airConditioners) {
      element.icon = 'Air_conditioner.svg';
    }
    allDevices.addAll(_airConditioners);
    _videoDevices.clear();
    _videoDevices.addAll(devices
        .where((element) => element.entityId!.contains('media_player.')));
    for (var element in _videoDevices) {
      element.icon = 'television.svg';
    }
    allDevices.addAll(_videoDevices);
    _heatingSystems.clear();
    _heatingSystems.addAll(devices
        .where((element) => element.entityId!.contains('heating_system.')));
    for (var element in _heatingSystems) {
      element.icon = 'heating_system.svg';
    }
    allDevices.addAll(_heatingSystems);
    _kitchenTools.clear();
    _kitchenTools.addAll(
        devices.where((element) => element.entityId!.contains('kitchen.')));
    for (var element in _kitchenTools) {
      element.icon = 'kitchen_tools.svg';
    }
    allDevices.addAll(_kitchenTools);
    _washingMachines.clear();
    _washingMachines.addAll(devices
        .where((element) => element.entityId!.contains('washing_machine.')));
    for (var element in _washingMachines) {
      element.icon = 'washing_machine.svg';
    }
    allDevices.addAll(_washingMachines);
    _irrigation.clear();
    _irrigation.addAll(
        devices.where((element) => element.entityId!.contains('irrigation.')));
    for (var element in _irrigation) {
      element.icon = 'garden.svg';
    }
    allDevices.addAll(_heatingSystems);

    Map<String, List<EnergySensorData>> energySensorData = {};
    energySensorResponseData.forEach((key, value) {
      List<EnergySensorData> list = [];
      if (key.endsWith('energy')) {
        value.forEach((v) {
          list.add(EnergySensorData.fromJson(v));
        });
        energySensorData[
            key.substring(key.indexOf('.') + 1, key.indexOf('_energy'))] = list;
      }
    });
    energySensorData.forEach((key, value) {
      allDevices
          .singleWhere((item) => item.entityId!.contains(key))
          .energyUsageData = value;
    });

    _lightEnergy = _energyConsumption(_lights);
    _socketEnergy = _energyConsumption(_sockets);
    _shutterEnergy = _energyConsumption(_shutters);
    _airConditionerEnergy = _energyConsumption(_airConditioners);
    _videoDevicesEnergy = _energyConsumption(_videoDevices);
    _heatingSystemEnergy = _energyConsumption(_heatingSystems);
    _kitchenToolsEnergy = _energyConsumption(_kitchenTools);
    _washingMachineEnergy = _energyConsumption(_washingMachines);
    _irrigationEnergy = _energyConsumption(_irrigation);

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
        energy += double.parse(device.energy.toLowerCase() != 'unavailable'
            ? device.energy
            : '0.0');
      }
      _roomList.add({
        'icon': 'bed.svg',
        'name': '${value['name']}',
        'appliances': roomDeviceIcons(value["area_id"]),
        'energyConsumption': '${energy.toStringAsPrecision(2)} KW USED'
      });
    }
    allDevices.sort((a, b) => a.attributes!.friendlyName!
        .toLowerCase()
        .compareTo(b.attributes!.friendlyName!.toLowerCase()));

    initialisation = false;
//    _isInitialized.
  }

  void updateData(Map<String, dynamic> response) {
    DeviceData deviceData =
        DeviceData.fromJson(response['event']['data']['new_state']);
    try {
      allDevices
          .elementAt(allDevices
              .indexWhere((element) => element.entityId == deviceData.entityId))
          .update(deviceData);
      if (!deviceData.entityId!.contains('sensor')) onUpdate!.call();
    } catch (_) {}
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

  double _energyConsumption(List<DeviceData> roomDevices) {
    double energy = 0;
    for (var device in roomDevices) {
      try {
        energy += double.parse(device.energy = devices
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
    return energy;
  }

  List<DeviceData> get getIrrigations => _irrigation;

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

  Future get isInitialized => _isInitialized!;
}
