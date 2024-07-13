import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebAuth extends StatelessWidget {
  const WebAuth(this.authorizationEndpoint, this.clientId, this.tokenEndpoint,
      {Key? key})
      : super(key: key);

  final Uri authorizationEndpoint, tokenEndpoint;
  final String clientId;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.sizeOf(context);
    return WebViewWidget(
        controller: WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (String url) async {
                Map<String, dynamic> body = {
                  "grant_type": "authorization_code",
                  "code": Uri.parse(url).queryParameters['code']!,
                  "client_id": clientId
                };
                var result = await post(tokenEndpoint,
                    body: body,
                    headers: {
                      "Content-Type": "application/x-www-form-urlencoded"
                    },
                    encoding: Encoding.getByName("utf-8"));

                String host = Hive.box('Settings').get('host');
                final channel = WebSocketChannel.connect(Uri.parse(
                    'ws://${host.substring(host.indexOf('://') + 3)}/api/websocket'));

                channel.sink.add(
                    '{"type": "auth", "access_token": "${jsonDecode(result.body)['access_token']}"}');
                channel.stream.listen((data) {
                  Map<String, dynamic> dataMap = jsonDecode(data.toString());
                  if (dataMap['id'] == 1) {
                    channel.sink.close();
                    Navigator.pop(context, dataMap['result']);
                  }
                });
                channel.sink.add(
                    '{"id": 1, "type": "auth/long_lived_access_token", "client_name": "GPS Logger", "lifespan": 3652}');
              },
            ),
          )
          ..loadRequest(authorizationEndpoint));
  }
}
