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

  final channel = WebSocketChannel.connect(
      Uri.parse('ws://192.168.0.29:8123/api/websocket'));

  Future<void> init() async {
    List<Map> responses = [];
    channel.sink.add(
        '{"type": "auth", "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiIxNDg2MDJlN2M1NTI0YjE5OGE3M2E0MDc3ZTk3Zjg1NyIsImlhdCI6MTY1NDk4MTM2MiwiZXhwIjoxOTcwMzQxMzYyfQ.qhLmeqGKP1BIPJ98p7Z5LGAtTjADQiRtlOAGec5nm-w"}');
    channel.stream.listen((data) async {
      Map<String, dynamic> dataMap = jsonDecode(data.toString());
      if (dataMap['type'] == 'event') {
        DashboadData().updateData(dataMap);
      } else if (initialisation) {
        Map dataMap = jsonDecode(data.toString());
        if (dataMap.containsKey('id') && ids.contains(dataMap['id'])) {
          responses.add(dataMap);
        }
        if (responses.length == 3) {
          DashboadData().setData(responses);
          responses = [];
          initialisation = false;
        }
      }
    });
  }

  void send(List query) {
    for (var request in query) {
      channel.sink.add(request);
    }
  }
}
