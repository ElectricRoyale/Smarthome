library variables.globals;

import 'package:flutter/material.dart';

import '../JSON/device_data.dart';
import '../layouts/unavailable_dialog.dart';

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
}

class EnergyData {
  final double? energy;
  final DateTime time;

  EnergyData(this.time, {this.energy});
}

void checkAvailability(BuildContext context) {
  if (deviceItem == null || deviceItem!.state == 'unavailable') {
    if (ModalRoute.of(context)!.isCurrent) {
      showDialog(
        context: context,
        builder: (context) => UnavailableDialog(
          () => Navigator.of(context, rootNavigator: true)
              .popUntil((route) => route.settings.name == 'overviewpage'),
        ),
      );
    }
  } else if (!ModalRoute.of(context)!.isCurrent) {
    Navigator.of(context).pop();
  }
}
