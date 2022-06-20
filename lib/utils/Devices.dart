import '../JSON/device_data.dart';
import 'CURL_Request.dart';

class Devices {
  List<DeviceData> _devices = [];
  List<DeviceData> _lights = [];
  List<DeviceData> _sockets = [];
  List<DeviceData> _shutters = [];
  List<DeviceData> _airConditioners = [];
  List<DeviceData> _videoDevices = [];
  List<DeviceData> _heatingSystems = [];
  List<DeviceData> _kitchenTools = [];
  List<DeviceData> _washingMachines = [];
  List<DeviceData> _irrigations = [];
  double _lightEnergy = 0,
      _socketEnergy = 0,
      _shutterEnergy = 0,
      _airConditionerEnergy = 0,
      _videoDevicesEnergy = 0,
      _heatingSystemEnergy = 0,
      _kitchenToolsEnergy = 0,
      _washingMachineEnergy = 0,
      _irrigationEnergy = 0;
  List<double> _energyList = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];

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
        _devices.where((element) => element.entityId!.contains('switch')));
    _sockets.addAll(
        _devices.where((element) => element.entityId!.contains('switch')));
    _shutters.addAll(
        _devices.where((element) => element.entityId!.contains('cover')));
    _airConditioners.addAll(
        _devices.where((element) => element.entityId!.contains('switch')));
    _videoDevices.addAll(
        _devices.where((element) => element.entityId!.contains('switch')));
    _heatingSystems.addAll(
        _devices.where((element) => element.entityId!.contains('switch')));
    _kitchenTools.addAll(
        _devices.where((element) => element.entityId!.contains('switch')));
    _washingMachines.addAll(
        _devices.where((element) => element.entityId!.contains('switch')));
    _irrigations.addAll(
        _devices.where((element) => element.entityId!.contains('switch')));

    _lights.forEach((device) => _lightEnergy += _devices
        .singleWhere((sensor) => sensor.entityId!.contains(
            'sensor.${device.entityId!.substring(device.entityId!.indexOf('.'))}_energy'))
        .state! as double);
    _sockets.forEach((device) => _socketEnergy += _devices
        .singleWhere((sensor) => sensor.entityId!.contains(
            'sensor.${device.entityId!.substring(device.entityId!.indexOf('.'))}_energy'))
        .state! as double);
    _shutters.forEach((device) => _shutterEnergy += _devices
        .singleWhere((sensor) => sensor.entityId!.contains(
            'sensor.${device.entityId!.substring(device.entityId!.indexOf('.'))}_energy'))
        .state! as double);
    _airConditioners.forEach((device) => _airConditionerEnergy += _devices
        .singleWhere((sensor) => sensor.entityId!.contains(
            'sensor.${device.entityId!.substring(device.entityId!.indexOf('.'))}_energy'))
        .state! as double);
    _videoDevices.forEach((device) => _videoDevicesEnergy += _devices
        .singleWhere((sensor) => sensor.entityId!.contains(
            'sensor.${device.entityId!.substring(device.entityId!.indexOf('.'))}_energy'))
        .state! as double);
    _heatingSystems.forEach((device) => _heatingSystemEnergy += _devices
        .singleWhere((sensor) => sensor.entityId!.contains(
            'sensor.${device.entityId!.substring(device.entityId!.indexOf('.'))}_energy'))
        .state! as double);
    _kitchenTools.forEach((device) => _kitchenToolsEnergy += _devices
        .singleWhere((sensor) => sensor.entityId!.contains(
            'sensor.${device.entityId!.substring(device.entityId!.indexOf('.'))}_energy'))
        .state! as double);
    _washingMachines.forEach((device) => _washingMachineEnergy += _devices
        .singleWhere((sensor) => sensor.entityId!.contains(
            'sensor.${device.entityId!.substring(device.entityId!.indexOf('.'))}_energy'))
        .state! as double);
    _irrigations.forEach((device) => _irrigationEnergy += _devices
        .singleWhere((sensor) => sensor.entityId!.contains(
            'sensor.${device.entityId!.substring(device.entityId!.indexOf('.'))}_energy'))
        .state! as double);
    _energyList.addAll([
      _lightEnergy,
      _socketEnergy,
      _shutterEnergy,
      _airConditionerEnergy,
      _videoDevicesEnergy,
      _heatingSystemEnergy,
      _kitchenToolsEnergy,
      _washingMachineEnergy,
      _irrigationEnergy
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

  List<double> get getEnergyList => _energyList;
}
