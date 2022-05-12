import 'dart:typed_data';

import 'package:hive/hive.dart';
import 'package:mysql1/mysql1.dart';

import '../Model/UserData.dart';

class MySQLHelper {
  var settings = ConnectionSettings(
      host: '192.168.0.51',
      port: 3308,
      user: 'Pascal',
      password: 'Electric Royale',
      db: 'UserData'
  );
  late MySqlConnection conn;

  Future<bool> login(String name, String password) async {
    conn = await MySqlConnection.connect(settings);
    var result = await conn.query('select Profilbild,Name,EmailAddresse,Birthday,Telephonenumber,Addresse from UserData.logindata where Name like \'$name%\' and aes_decrypt(Passwort, \'LaK&d;Y+2IT\') = \'$password\';');
    if(result.isNotEmpty) {
      final data = UserData(
          profileImage: result.first.fields['Profilbild'] != null ? Uint8List.fromList((result.first.fields['Profilbild'] as Blob).toBytes()) : null,
          name: result.first.fields['Name'],
          email: result.first.fields['EmailAddresse'],
          birthday: result.first.fields['Birthday'],
          handyNumber: result.first.fields['Telephonenumber'],
          address: result.first.fields['Addresse']);
      Box<UserData> userData = Hive.box<UserData>('UserData');
      userData.isNotEmpty ? userData.putAt(0, data) : userData.add(data);
      Box loginData = Hive.box('LoginData');
      loginData.put('name', result.first.fields['Name']);
      loginData.put('password', password);
      return true;
    }else{
      return false;
    }
  }
  Future<String> register(Uint8List? profileImage, String name, String email, String birthday, String password)async {
    conn = await MySqlConnection.connect(settings);
    var rs = await conn.query('select Name from logindata where Name = ?', [name]);
    if (rs.isEmpty) {
      var result = await conn.query(
          'insert into logindata ( `Profilbild`, `Name`, `EmailAddresse`, `Birthday`, `Passwort`) VALUES (?, ?, ?, ?, aes_encrypt(?, \'LaK&d;Y+2IT\'));',
          [profileImage, name, email, birthday, password]);
      return result.insertId != null ? 'successful' : 'failed';
    }else{
      return 'isDuplicated';
    }
  }
}