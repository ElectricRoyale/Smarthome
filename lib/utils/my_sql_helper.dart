import 'dart:convert';
import 'dart:typed_data';

import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:mysql1/mysql1.dart';
import 'package:smarthome/utils/system_specific_data.dart';

import '../Model/user_data.dart';

class MySQLHelper {
  var settings = ConnectionSettings(
      host: Hive.box('Settings').get('host').toString().substring(
          Hive.box('Settings').get('host').toString().indexOf('://') + 3,
          Hive.box('Settings').get('host').toString().lastIndexOf(':')),
      port: 3306,
      user: 'pascal',
      password: 'Electric Royale',
      db: 'UserData',
      timeout: const Duration(seconds: 5));
  late MySqlConnection conn;

  Future<bool> canConnect() async {
    try {
      conn = await MySqlConnection.connect(settings);
    } catch (_) {
      return false;
    }
    return true;
  }

  Future<bool> isEmpty() async {
    conn = await MySqlConnection.connect(settings);
    var result = await conn.query('select id from UserData.LoginData;');
    return result.isEmpty;
  }

  Future<bool> login(String name, String password) async {
    conn = await MySqlConnection.connect(settings);
    var result = await conn.query(
        "select token, name from UserData.LoginData where name like '$name%' and aes_decrypt(password, 'LaK&d;Y+2IT') = ?;",
        [password]);
    if (result.isNotEmpty) {
      final data = UserData(
          name: result.first.fields['name'],
          token: result.first.fields['token']);
      Box<UserData> userData = Hive.box<UserData>('UserData');
      userData.isNotEmpty ? userData.putAt(0, data) : userData.add(data);
      Box loginData = Hive.box('LoginData');
      loginData.put('name', result.first.fields['name']);
      loginData.put('password', password);
      return true;
    } else {
      return false;
    }
  }

  Future<String> register(String name, String password,
      Uri registrationEndpoint, String token) async {
    SystemSpecificData specificData =
        await SystemSpecificData().getSystemSpecificData();
    await post(registrationEndpoint,
        body: jsonEncode({
          "device_id": specificData.deviceId,
          "app_id": specificData.appId,
          "app_name": specificData.appName,
          "app_version": specificData.appVersion,
          "device_name": specificData.deviceName,
          "manufacturer": specificData.manufacturer,
          "model": specificData.model,
          "os_name": specificData.osName,
          "os_version": specificData.osVersion,
          "supports_encryption": specificData.supportEncryption,
        }),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        });
    conn = await MySqlConnection.connect(settings);
    var rs =
        await conn.query('select Name from LoginData where Name = ?', [name]);
    if (rs.isEmpty) {
      var result = await conn.query(
          'insert into LoginData (`Name`, `Password`, `token`) VALUES (?, aes_encrypt(?, \'LaK&d;Y+2IT\'), ?);',
          [name, password, token]);
      return result.insertId != null ? 'successful' : 'failed';
    } else {
      return 'isDuplicated';
    }
  }

  Future<void> update(
      Uint8List? profileImage,
      String name,
      String email,
      String birthday,
      String address,
      String telephonenumber,
      String oldname) async {
    conn = await MySqlConnection.connect(settings);
    conn.query(
        'update LoginData set Profile_image = ?, Name = ?, Email_Address = ?, Birthday = ?, Address = ?, Telephonenumber = ? where Name = ?;',
        [
          profileImage,
          name,
          email,
          birthday,
          address,
          telephonenumber,
          oldname
        ]);
  }
}
