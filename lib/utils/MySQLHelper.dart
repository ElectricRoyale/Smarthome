import 'dart:typed_data';

import 'package:hive/hive.dart';
import 'package:mysql1/mysql1.dart';

import '../Model/UserData.dart';

class MySQLHelper {
  var settings = ConnectionSettings(
      host: '192.168.0.154',
      port: 3306,
      user: 'pascal',
      password: 'Electric Royale',
      db: 'UserData');
  late MySqlConnection conn;

  Future<bool> isEmpty() async {
    conn = await MySqlConnection.connect(settings);
    var result = await conn.query('select id from UserData.LoginData;');
    return result.isEmpty;
  }

  Future<bool> login(String name, String password) async {
    conn = await MySqlConnection.connect(settings);
    var result = await conn.query(
        'select token, name from UserData.LoginData where name like \'$name%\' and aes_decrypt(password, \'LaK&d;Y+2IT\') = \'$password\';');
    if (result.isNotEmpty) {
      /*final data = UserData(
          profileImage: result.first.fields['Profile_image'] != null
              ? Uint8List.fromList(
                  (result.first.fields['Profile_image'] as Blob).toBytes())
              : null,
          name: result.first.fields['Name'],
          email: result.first.fields['Email_Address'],
          birthday: result.first.fields['Birthday'],
          handyNumber: result.first.fields['Telephonenumber'],
          address: result.first.fields['Address']);*/
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

  Future<String> register(String name, String password, String token) async {
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
