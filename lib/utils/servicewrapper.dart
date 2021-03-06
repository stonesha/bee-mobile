import 'dart:convert';
import 'package:bee_mobile/utils/location.helper.dart';
import 'package:http/http.dart' as http;

class ServiceWrapper {
  var baseurl = "https://bee-webserver.herokuapp.com/";

  Future<http.Response> sendLocation() async {
    var location = await acquireCurrentLocation();
    Map<String, dynamic> locationJSON = {
      'latitude': location.latitude,
      'longitude': location.longitude
    };

    var response = await http.post(
        Uri.encodeFull(baseurl + "/Input_Location_M"),
        body: json.encode(locationJSON),
        headers: {
          "content-type": "application/json",
          "Accept": "application/json"
        });

    print(response.body);

    return response;
  }

  Future<String> getData() async {
    final response = await http.get(baseurl + '/Return_Location_M');

    print(response.body);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get data');
    }
  }
}
