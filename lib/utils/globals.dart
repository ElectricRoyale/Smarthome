library variables.globals;

import '../JSON/device_data.dart';

bool mustAuthenticate = true;
int idNumber = 1;
DeviceData? deviceItem;
bool connectionError = false;
bool initialisation = false;
List<int> ids = [];
Function? onUpdate;
