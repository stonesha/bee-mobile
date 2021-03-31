import 'dart:convert';
import 'package:bee_mobile/utils/location.helper.dart';
import 'package:http/http.dart' as http;
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:intl/intl.dart';

class ServiceWrapper {
  var baseurl = "https://bee-webserver.herokuapp.com/";
  var uuid = "f414415c-f952-45b4-a88b-c5d7d80bcf9f";

  Future<http.Response> sendUser() async {
    var location = await acquireCurrentLocation();
    Map<String, dynamic> locationJSON = {
      "user_id": "28549545-313a-43f1-a8c1-3e8fb1b88675",
      "evac_id": "NULL",
      "notification_token": "false",
      "notification_sent_at": "2004-10-19 10:23:54+02",
      "acknowledged": "false",
      "acknowledged_at": "2004-10-19 10:23:54+02",
      "safe": "false",
      "marked_safe_at": "2004-10-19 10:23:54-07",
      "location": "POINT(-118.4079 33.9434)",
      "location_updated_at": "2004-10-19 10:23:54+02",
      "name": "John Smith"
    };

    var response = await http.post(
        Uri.encodeFull(baseurl + "Create_New_User_M/" + uuid),
        body: json.encode(locationJSON),
        headers: {
          "content-type": "application/json",
          "Accept": "application/json"
        });

    print(response.body);

    return response;
  }

  Future<http.Response> sendSafety() async {
    var location = await acquireCurrentLocation();
    Map<String, dynamic> locationJSON = {
      'latitude': location.latitude,
      'longitude': location.longitude,
      'safe': true,
    };

    var response = await http.post(
        Uri.encodeFull(baseurl + "Mark_Safe_M/" + uuid),
        body: json.encode(locationJSON),
        headers: {
          "content-type": "application/json",
          "Accept": "application/json"
        });

    print(response.body);

    return response;
  }

  Future<http.Response> sendNotSafe() async {
    var location = await acquireCurrentLocation();
    Map<String, dynamic> locationJSON = {
      'latitude': location.latitude,
      'longitude': location.longitude,
      'safe': false,
    };

    var response = await http.post(
        Uri.encodeFull(baseurl + "Mark_Not_Safe_M/" + uuid),
        body: json.encode(locationJSON),
        headers: {
          "content-type": "application/json",
          "Accept": "application/json"
        });

    print(response.body);

    return response;
  }

  Future<http.Response> sendReport(LatLng coordinates) async {
    final String dateTimeString =
        DateFormat('yyyy-MM-dd kk:mm:ss').format(DateTime.now()).toString();

    Map<String, dynamic> locationJSON = {
      'latitude': coordinates.latitude,
      'longitude': coordinates.longitude,
      'evac_id': "NULL",
      'report_id': "NULL",
      'type': "nasty",
      'reporter_id': "28549545-313a-43f1-a8c1-3e8fb1b88675",
      "info": "its real bad out there man",
      "reported_at": dateTimeString,
    };

    var response = await http.post(Uri.encodeFull(baseurl + "/User_Report/"),
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
