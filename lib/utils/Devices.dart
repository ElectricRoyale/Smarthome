import '../JSON/device_data.dart';
import 'CURL_Request.dart';

class Devices {
  List<DeviceData> _devices = [],
      _lights = [],
      _sockets = [],
      _shutters = [],
      _airConditioners = [],
      _videoDevices = [],
      _heatingSystems = [],
      _kitchenTools = [],
      _washingMachines = [],
      _irrigations = [];

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
    for (var element in deviceData) {
      _devices.add(DeviceData.fromJson(element));
    }
    _lights.addAll(
        _devices.where((element) => element.entityId!.contains('switch.')));
    _sockets.addAll(
        _devices.where((element) => element.entityId!.contains('switch.')));
    _shutters.addAll(
        _devices.where((element) => element.entityId!.contains('cover.')));
    _airConditioners.addAll(
        _devices.where((element) => element.entityId!.contains('switch.')));
    _videoDevices.addAll(
        _devices.where((element) => element.entityId!.contains('switch.')));
    _heatingSystems.addAll(
        _devices.where((element) => element.entityId!.contains('switch.')));
    _kitchenTools.addAll(
        _devices.where((element) => element.entityId!.contains('switch.')));
    _washingMachines.addAll(
        _devices.where((element) => element.entityId!.contains('switch.')));
    _irrigations.addAll(
        _devices.where((element) => element.entityId!.contains('switch.')));

    /*_lights.forEach((device) => _lightEnergy += _devices
        .singleWhere((sensor) =>
            sensor.entityId! ==
            'sensor${device.entityId!.substring(device.entityId!.indexOf('.'))}_energy')
        .state! as double);
    _sockets.forEach((device) => _socketEnergy += _devices
        .singleWhere((sensor) =>
            sensor.entityId! ==
            'sensor${device.entityId!.substring(device.entityId!.indexOf('.'))}_energy')
        .state! as double);*/
    for (var device in _shutters) {
      _shutterEnergy += double.parse(_devices
          .singleWhere((sensor) =>
              sensor.entityId! ==
              'sensor${device.entityId!.substring(device.entityId!.indexOf('.'))}_energy')
          .state!);
    }
    /* _airConditioners.forEach((device) => _airConditionerEnergy += _devices
        .singleWhere((sensor) =>
            sensor.entityId! ==
            'sensor${device.entityId!.substring(device.entityId!.indexOf('.'))}_energy')
        .state! as double);
    _videoDevices.forEach((device) => _videoDevicesEnergy += _devices
        .singleWhere((sensor) =>
            sensor.entityId! ==
            'sensor${device.entityId!.substring(device.entityId!.indexOf('.'))}_energy')
        .state! as double);
    _heatingSystems.forEach((device) => _heatingSystemEnergy += _devices
        .singleWhere((sensor) =>
            sensor.entityId! ==
            'sensor${device.entityId!.substring(device.entityId!.indexOf('.'))}_energy')
        .state! as double);
    _kitchenTools.forEach((device) => _kitchenToolsEnergy += _devices
        .singleWhere((sensor) =>
            sensor.entityId! ==
            'sensor${device.entityId!.substring(device.entityId!.indexOf('.'))}_energy')
        .state! as double);
    _washingMachines.forEach((device) => _washingMachineEnergy += _devices
        .singleWhere((sensor) =>
            sensor.entityId! ==
            'sensor${device.entityId!.substring(device.entityId!.indexOf('.'))}_energy')
        .state! as double);
    _irrigations.forEach((device) => _irrigationEnergy += _devices
        .singleWhere((sensor) =>
            sensor.entityId! ==
            'sensor${device.entityId!.substring(device.entityId!.indexOf('.'))}_energy')
        .state! as double);*/

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
