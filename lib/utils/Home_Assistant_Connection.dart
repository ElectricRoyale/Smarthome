import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:smarthome/utils/DashboardData.dart';
import 'package:smarthome/utils/globals.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../Model/UserData.dart';

class HomeAssistantConnection {
  static final HomeAssistantConnection _instance =
      HomeAssistantConnection._internal();

  factory HomeAssistantConnection() => _instance;

  HomeAssistantConnection._internal() {
    _channel.sink.add(
        '{"type": "auth", "access_token": "${userData.values.first.token}"}');
    initHomeAssistant();
  }

  Box<UserData> userData = Hive.box<UserData>('UserData');

  final _channel = WebSocketChannel.connect(
      Uri.parse('ws://192.168.0.154:8123/api/websocket'));

  void initHomeAssistant() {
    _channel.stream.listen((data) {
      Map<String, dynamic> dataMap = jsonDecode(data.toString());
      if (dataMap['type'] == 'event') {
        DashboadData().updateData(dataMap);
      }
    });
  }

  Future<List> collectData(List query) async {
    final channel = WebSocketChannel.connect(
        Uri.parse('ws://192.168.0.154:8123/api/websocket'));
    channel.sink.add(
        '{"type": "auth", "access_token": "${userData.values.first.token}"}');
    for (var request in query) {
      channel.sink.add(request);
    }
    _channel.sink.add(
        '{"id": ${idNumber++}, "type": "subscribe_events", "event_type": "state_changed"}');
    int i = 0;
    var stream = channel.stream.asBroadcastStream();
    stream.listen((element) {
      i++;
      if (i == query.length + 2) channel.sink.close();
    });
    return await stream.toList();
  }

  void send(List query) {
    for (var request in query) {
      _channel.sink.add(request);
    }
  }

  final smbConfig = SmbConfig(
      'Admin', 'HP,segl.Ew,awsSTdzF.DJ,düh.', 'smb:192.168.0.154', '445');
}

class SmbConfig {
  final String username;
  final String password;
  final String hostname;
  final port;

  SmbConfig(this.username, this.password, this.hostname, this.port);
}
