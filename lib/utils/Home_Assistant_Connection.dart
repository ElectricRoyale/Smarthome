import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

class HomeAssistantConnection {
  final channel = WebSocketChannel.connect(
      Uri.parse('ws://192.168.0.29:8123/api/websocket'));

  Future<Map> send(String query) async {
    Map response = {};
    channel.sink.add(
        '{"type": "auth", "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiIxNDg2MDJlN2M1NTI0YjE5OGE3M2E0MDc3ZTk3Zjg1NyIsImlhdCI6MTY1NDk4MTM2MiwiZXhwIjoxOTcwMzQxMzYyfQ.qhLmeqGKP1BIPJ98p7Z5LGAtTjADQiRtlOAGec5nm-w"}');
    channel.sink.add(query);
    channel.stream.forEach((data) {
      response = jsonDecode(data.toString());
    });
    await Future.delayed(const Duration(seconds: 2));
    channel.sink.close();
    return response;
  }
}
