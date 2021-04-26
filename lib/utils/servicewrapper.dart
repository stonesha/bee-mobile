import 'dart:convert';
import 'package:bee_mobile/utils/location.helper.dart';
import 'package:http/http.dart' as http;
import 'package:mapbox_gl/mapbox_gl.dart';

class ServiceWrapper {
  var baseurl = "https://bee-webserver.herokuapp.com";
  var uuid = "140afcc5-cc8a-453b-98fc-5c851aed4aea";

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

    print(uuid);
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
      'longitude': location.longitude,
      'user_id': uuid,
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
  }

  Future<String> sendUser(name) async {
    var uuid = "140afcc5-cc8a-453b-98fc-5c851aed43ef";
    Map<String, dynamic> locationJSON = {
      'user_id': uuid,
      'evac_id': 'null',
      'notification_token': false,
      'notification_sent_at': '2021-04-26 10:23:54+02',
      'acknowledged': false,
      'acknowledged_at': '2021-04-26 10:23:54+02',
      'safe': false,
      'marked_safe_at': '2021-04-26 10:23:54+02',
      'location': 'null',
      'location_updated_at': '2021-04-26 10:23:54+02',
      'name': name
    };

    var response = await http.post(
        Uri.encodeFull(baseurl + "/Create_New_User_M"),
        body: json.encode(locationJSON),
        headers: {
          "content-type": "application/json",
          "Accept": "application/json"
        });

    print(response.body);

    return response.body;
  }

  Future<String> acknowledgeNotification() async {
    var uuid = "140afcc5-cc8a-453b-98fc-5c851aed4aea";
    Map<String, dynamic> locationJSON = {
      'user_id': uuid,
      'evac_id': 'null',
      'notification_token': false,
      'notification_sent_at': '2021-04-26 10:23:54+02',
      'acknowledged': false,
      'acknowledged_at': '2021-04-26 10:23:54+02',
      'safe': false,
      'marked_safe_at': '2021-04-26 10:23:54+02',
      'location': 'null',
      'location_updated_at': '2021-04-26 10:23:54+02',
      'name': 'null'
    };

    var response = await http.post(
        Uri.encodeFull(baseurl + "/Acknowledge_Notification"),
        body: json.encode(locationJSON),
        headers: {
          "content-type": "application/json",
          "Accept": "application/json"
        });

    print(response.body);

    return response.body;
  }

  Future<String> getZones() async {
    final response = await http.get(baseurl + '/Send_Zone');

    return response.body;
  }

  Future<String> getRoutes() async {
    final response = await http.get(baseurl + '/Send_Point');

    return response.body;
  }

  Future<String> getInstructions() async {
    final response = await http.get(baseurl + '/Send_Instructions');

    return response.body;
  }
}
