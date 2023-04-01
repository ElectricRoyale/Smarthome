library variables.globals;

import '../JSON/device_data.dart';

bool mustAuthenticate = true;
int idNumber = 1;
DeviceData? deviceItem;
bool connectionError = false;
bool initialisation = false;
List<int> ids = [];
Function? onUpdate;

Function logbookRefresh = () async {};
Function mediaRefresh = () async {};
Function deviceGridRefresh = () async {};
Function weatherRefresh = () async {};
Function spotifyControllRefresh = () async {};

void refresh() {
  logbookRefresh.call();
  mediaRefresh.call();
  deviceGridRefresh.call();
  weatherRefresh.call();
  spotifyControllRefresh.call();
}

class EnergyData {
  final double? energy;
  final DateTime time;

  EnergyData(this.time, {this.energy});
}
