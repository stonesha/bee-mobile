import 'dart:convert';
import 'package:bee_mobile/utils/location.helper.dart';
import 'package:http/http.dart' as http;
import 'package:mapbox_gl/mapbox_gl.dart';

class ServiceWrapper {
  var baseurl = "https://bee-webserver.herokuapp.com";
  var uuid = "608107e4-64bd-4843-af59-036646165689";

  Future<http.Response> sendSafety(bool isSafe) async {
    var location = await acquireCurrentLocation();
    Map<String, dynamic> locationJSON = {
      'latitude': location.latitude,
      'longitude': location.longitude,
      'safe': isSafe,
    };

    var response = await http.post(
        Uri.encodeFull(baseurl + "/Mark_Safe_M/" + uuid),
        body: json.encode(locationJSON),
        headers: {
          "content-type": "application/json",
          "Accept": "application/json"
        });

    print(response.body);

    return response;
  }

  Future<http.Response> sendReport(LatLng coordinates) async {
    Map<String, dynamic> locationJSON = {
      "reported_at": "2004-10-19 10:23:54+02",
      "type": "nasty",
      "info": "its real bad out there man",
      "report_id": "NULL",
      "evac_id": "NULL",
      "reporter_id": "28549545-313a-43f1-a8c1-3e8fb1b88675",
      'latitude': coordinates.latitude,
      'longitude': coordinates.longitude
    };

    var response = await http.post(Uri.encodeFull(baseurl + "/User_Report"),
        body: json.encode(locationJSON),
        headers: {
          "content-type": "application/json",
          "Accept": "application/json"
        });

    print(response.body);

    return response;
  }

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

    return response.body;
    /*
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get data');
    }
    */
  }
}
