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
  
  Future<bool> login(String Name, String Password) async {
    conn = await MySqlConnection.connect(settings);
    var result = await conn.query('select Profilbild,Name,EmailAddresse,Birthday,Telephonenumber,Addresse from UserData.logindata where Name like \'$Name%\' and aes_decrypt(Passwort, \'LaK&d;Y+2IT\') = \'$Password\';');
    if(result.isNotEmpty) {
      Box<UserData> userData = Hive.box<UserData>('UserData');
      Blob profilbild = result.first.fields['Profilbild'];
      final data = UserData(
          profileImage: Uint8List.fromList(profilbild.toBytes()),
          name: result.first.fields['Name'],
          email: result.first.fields['EmailAddresse'],
          birthday: result.first.fields['Birthday'],
          handyNumber: result.first.fields['Telephonenumber'],
          address: result.first.fields['Addresse']);
      userData.add(data);
      return true;
    }else{
      return false;
    }
  }
}