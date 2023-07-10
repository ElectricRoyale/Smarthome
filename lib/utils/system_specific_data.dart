import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SystemSpecificData {
  String _deviceId = '';
  String _appId = '';
  String _appName = '';
  String _appVersion = '';
  String _deviceName = '';
  String _manufacturer = '';
  String _model = '';
  String _osName = '';
  String _osVersion = '';
  bool _supportEncryption = false;

  Future<SystemSpecificData> getSystemSpecificData() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _appId = packageInfo.buildSignature;
    _appName = packageInfo.appName;
    _appVersion = packageInfo.version;
    _deviceName = Platform.localeName;
    _osName = Platform.operatingSystem;
    _supportEncryption = true;
    if (Platform.isAndroid) {
      AndroidDeviceInfo deviceInfo = await DeviceInfoPlugin().androidInfo;
      _deviceId = deviceInfo.id;
      _manufacturer = deviceInfo.manufacturer;
      _model = deviceInfo.model;
      _osVersion = deviceInfo.version.release;
    } else if (Platform.isIOS) {
      IosDeviceInfo deviceInfo = await DeviceInfoPlugin().iosInfo;
      _deviceId = deviceInfo.identifierForVendor ?? deviceInfo.utsname.nodename;
      _manufacturer = 'apple';
      _model = deviceInfo.model;
      _osVersion = deviceInfo.systemVersion;
    } else if (Platform.isWindows) {
      WindowsDeviceInfo deviceInfo = await DeviceInfoPlugin().windowsInfo;
      _deviceId = deviceInfo.deviceId;
      _manufacturer = deviceInfo.buildLab;
      _model = deviceInfo.productName;
      _osVersion = deviceInfo.majorVersion.toString();
    } else if (Platform.isMacOS) {
      MacOsDeviceInfo deviceInfo = await DeviceInfoPlugin().macOsInfo;
      _deviceId = deviceInfo.hostName;
      _manufacturer = 'apple';
      _model = deviceInfo.model;
      _osVersion = deviceInfo.majorVersion.toString();
    } else {
      throw PlatformException(
          code: 'The platform which is use is not supported');
    }
    return this;
  }

  bool get supportEncryption => _supportEncryption;

  String get osVersion => _osVersion;

  String get osName => _osName;

  String get model => _model;

  String get manufacturer => _manufacturer;

  String get deviceName => _deviceName;

  String get appVersion => _appVersion;

  String get appName => _appName;

  String get appId => _appId;

  String get deviceId => _deviceId;
}
