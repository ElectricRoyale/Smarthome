import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

class HomeAssistantConnection {
  final channel = WebSocketChannel.connect(
      Uri.parse('ws://192.168.0.29:8123/api/websocket'));

  List<Map> response = [];

  Future<void> send(List query) async {
    channel.stream
        .listen((data) async => response.add(jsonDecode(data.toString())));

    channel.sink.add(
        '{"type": "auth", "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiIxNDg2MDJlN2M1NTI0YjE5OGE3M2E0MDc3ZTk3Zjg1NyIsImlhdCI6MTY1NDk4MTM2MiwiZXhwIjoxOTcwMzQxMzYyfQ.qhLmeqGKP1BIPJ98p7Z5LGAtTjADQiRtlOAGec5nm-w"}');

    for (var request in query) {
      channel.sink.add(request);
    }
    await Future.delayed(const Duration(seconds: 2));
    channel.sink.close();
  }

  List<Map> get getResponses => response;
}
