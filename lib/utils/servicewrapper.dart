import 'dart:convert';
import 'package:bee_mobile/utils/location.helper.dart';
import 'package:http/http.dart' as http;

class ServiceWrapper {
  var baseurl = "https://bee-webserver.herokuapp.com/Input_Location_M";

  Future<String> sendLocation() async {
    var location = await acquireCurrentLocation();
    Map<String, dynamic> locationJSON = {
      'latitude': location.latitude,
      'longitude': location.longitude
    };

    var response = await http.post(
        Uri.encodeFull("https://bee-webserver.herokuapp.com/Input_Location_M"),
        body: json.encode(locationJSON),
        headers: {
          "content-type": "application/json",
          "Accept": "application/json"
        });

    print(response.body);

    return response.body;
  }

  Future<String> getData() async {
    final response =
        await http.get('https://bee-webserver.herokuapp.com/Return_Location_M');

    print(response.body);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return json.decode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to get data');
    }
  }
}
