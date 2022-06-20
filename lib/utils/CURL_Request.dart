import 'dart:convert';

import 'package:http/http.dart' as http;

class CURL_Request {
  Future<List<dynamic>> getRequest(Uri url) async {
    var response = await http.get(
      url,
      headers: {
        'Authorization':
            'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiIxNDg2MDJlN2M1NTI0YjE5OGE3M2E0MDc3ZTk3Zjg1NyIsImlhdCI6MTY1NDk4MTM2MiwiZXhwIjoxOTcwMzQxMzYyfQ.qhLmeqGKP1BIPJ98p7Z5LGAtTjADQiRtlOAGec5nm-w' /*${Hive.box('Settings').get('Token')}'*/,
        'Content-Type': 'application/json',
      },
    );
    return jsonDecode(response.body);
  }

  Future<List<dynamic>> postRequest(Uri url) async {
    var response = await http.post(
      url,
      headers: {
        'Authorization':
            'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiIxNDg2MDJlN2M1NTI0YjE5OGE3M2E0MDc3ZTk3Zjg1NyIsImlhdCI6MTY1NDk4MTM2MiwiZXhwIjoxOTcwMzQxMzYyfQ.qhLmeqGKP1BIPJ98p7Z5LGAtTjADQiRtlOAGec5nm-w' /*${Hive.box('Settings').get('Token')}'*/,
        'Content-Type': 'application/json',
      },
    );
    return jsonDecode(response.body);
  }
}
