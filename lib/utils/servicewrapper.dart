import 'dart:convert';
import 'package:bee_mobile/utils/location.helper.dart';
import 'package:http/http.dart' as http;
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

//class to handle all interactions with web server
class ServiceWrapper {
  var baseurl = "https://bee-webserver.herokuapp.com";
  var uuid = Uuid().v4();
  var datetime =
      new DateFormat("yyyy-MM-dd hh:mm:ss").format(new DateTime.now()) + "+02";

  //when user confirms or deny safety
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

  Future<http.Response> sendNotSafe(bool isSafe) async {
    var location = await acquireCurrentLocation();
    Map<String, dynamic> locationJSON = {
      'latitude': location.latitude,
      'longitude': location.longitude,
      'safe': isSafe,
    };

    var response = await http.post(
        Uri.encodeFull(baseurl + "/Mark_Not_Safe_M/" + uuid),
        body: json.encode(locationJSON),
        headers: {
          "content-type": "application/json",
          "Accept": "application/json"
        });

    print(uuid);
    print(response.body);

    return response;
  }

  //to update evacuee name
  Future<http.Response> updateName(String name) async {
    Map<String, dynamic> locationJSON = {
      "user_id": uuid,
      "evac_id": "Null",
      "notification_token": "true",
      "notification_sent_at": "null",
      "acknowledged": "true",
      "acknowledged_at": "null",
      "safe": "false",
      "marked_safe_at": "null",
      "location": "null",
      "location_updated_at": "null",
      "name": name
    };

    var response = await http.post(Uri.encodeFull(baseurl + "/Update_Username"),
        body: json.encode(locationJSON),
        headers: {
          "content-type": "application/json",
          "Accept": "application/json"
        });

    print(response.body);

    return response;
  }

  //to make a report
  Future<http.Response> sendReport(LatLng coordinates, String info) async {
    Map<String, dynamic> locationJSON = {
      "reported_at": datetime,
      "type": "nasty",
      "info": info,
      "report_id": "NULL",
      "evac_id": "NULL",
      "reporter_id": uuid,
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

  //sends location on startup of app and when user taps floating action button
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

  //on startup creates a user in the database
  Future<String> sendUser() async {
    Map<String, dynamic> locationJSON = {
      'user_id': uuid,
      'evac_id': 'null',
      'notification_token': false,
      'notification_sent_at': datetime,
      'acknowledged': false,
      'acknowledged_at': datetime,
      'safe': false,
      'marked_safe_at': datetime,
      'location': 'null',
      'location_updated_at': datetime,
      'name': ''
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

  //sends a response when the user acknowledges the evacuation notification
  Future<String> acknowledgeNotification() async {
    Map<String, dynamic> locationJSON = {
      'user_id': uuid,
      'evac_id': 'null',
      'notification_token': false,
      'notification_sent_at': datetime,
      'acknowledged': false,
      'acknowledged_at': datetime,
      'safe': false,
      'marked_safe_at': datetime,
      'location': 'null',
      'location_updated_at': datetime,
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

  //get all zones
  Future<String> getZones() async {
    final response = await http.get(baseurl + '/Send_Zone');

    return response.body;
  }

  //get all routes
  Future<String> getRoutes() async {
    final response = await http.get(baseurl + '/Send_Point');

    return response.body;
  }

  //get evacuation instructions
  Future<String> getInstructions() async {
    final response = await http.get(baseurl + '/Send_Instructions');

    return response.body;
  }
}
