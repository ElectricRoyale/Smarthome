import 'dart:convert';

import 'package:smarthome/utils/DashboardData.dart';
import 'package:smarthome/utils/globals.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HomeAssistantConnection {
  static final HomeAssistantConnection _instance =
      HomeAssistantConnection._internal();

  factory HomeAssistantConnection() => _instance;

  HomeAssistantConnection._internal() {
    init();
  }

  final _channel = WebSocketChannel.connect(
      Uri.parse('ws://192.168.0.152:8123/api/websocket'));

  Future<void> init() async {
    List<Map> responses = [];
    _channel.sink.add(
        '{"type": "auth", "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJmNWU0NjQwMmJiYzI0YTNkYjE5MzAzMTczMGZhNjg2OCIsImlhdCI6MTY2NTc3NDY0MiwiZXhwIjoxOTgxMTM0NjQyfQ.d7cU7XtQ4SsadgpbCJOsitLktfjj1QbgzH30m---Pm8"}');
    _channel.stream.listen((data) async {
      Map<String, dynamic> dataMap = jsonDecode(data.toString());
      if (dataMap['type'] == 'event') {
        DashboadData().updateData(dataMap);
      } else if (initialisation) {
        Map dataMap = jsonDecode(data.toString());
        if (dataMap.containsKey('id') && ids.contains(dataMap['id'])) {
          responses.add(dataMap);
        }
        if (responses.length == 4) {
          DashboadData().setData(responses);
          responses = [];
          initialisation = false;
        }
      }
    });
  }

  void send(List query) {
    for (var request in query) {
      _channel.sink.add(request);
    }
  }
}
