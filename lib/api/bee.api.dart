import 'dart:convert';
import 'package:http/http.dart' as http;

class BeeApi {
  final String baseURL;

  const BeeApi({this.baseURL = ''});

  Future<Map<String, dynamic>> makeGetRequest(
    String endpoint, {
    Map<String, dynamic> queryParams,
    Map<String, dynamic> headers,
  }) async {
    final http.Response response = await http.get(
      Uri.https(baseURL, endpoint, queryParams),
      headers: headers,
    );

    if (response.statusCode != 200) {
      return null;
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
