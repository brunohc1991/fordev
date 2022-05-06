import 'dart:convert';

import 'package:http/http.dart';
import 'package:meta/meta.dart';
import '../../data/http/http.dart';

class httpAdapter implements HttpClient {
  final Client client;

  httpAdapter(this.client);

  @override
  Future<Map> request(
      {@required String url, @required String method, Map body}) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json'
    };

    final jsonBody = body != null ? jsonEncode(body) : null;
    final response = await client.post(url, headers: headers, body: jsonBody);

    return _handelResponse(response);
  }

  Map _handelResponse(Response response) {
    if (response.statusCode == 200) {
      return response.body.isEmpty ? null : jsonDecode(response.body);
    } else {
      return null;
    }
  }
}