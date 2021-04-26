import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:bee_mobile/utils/servicewrapper.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mapbox_navigation/library.dart';
import 'package:mapbox_gl/mapbox_gl.dart';


void showRoutesModal(BuildContext context, ServiceWrapper serviceWrapper,
    MapboxMapController _mapController) {
  var response;
  serviceWrapper.getData().then((value) {
    response = value;
  });

  Future<void> _onRouteEvent(e) async {
    switch (e.eventType) {
      case MapBoxEvent.navigation_finished:
        print("navigation done");
        break;
      default:
        break;
    }
  }

  MapBoxNavigation _directions = MapBoxNavigation(onRouteEvent: _onRouteEvent);

  MapBoxOptions _options = MapBoxOptions(
      initialLatitude: 39.529,
      initialLongitude: -119.813,
      zoom: 16.0,
      tilt: 0.0,
      bearing: 0.0,
      enableRefresh: false,
      alternatives: true,
      voiceInstructionsEnabled: true,
      bannerInstructionsEnabled: true,
      allowsUTurnAtWayPoints: true,
      mode: MapBoxNavigationMode.drivingWithTraffic,
      units: VoiceUnits.imperial,
      language: "en");

  print(response);

  showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(children: <Widget>[
          ListTile(
            leading: Icon(Icons.run_circle),
            title: Text('Evacuation Route 1'),
            onTap: () async {
              print('route 1 pressed');
              String jsonString =
                  await rootBundle.loadString('assets/test_linestring.json');
              final data = json.decode(jsonString);
              List<LatLng> coordinates = [];
              List<WayPoint> wayPoints = [];
              for (var i = 0; i < data['coordinates'].length; i++) {
                coordinates.add(LatLng(
                    data['coordinates'][i][1], data['coordinates'][i][0]));

                wayPoints.add(WayPoint(
                    name: "Waypoint {$i}",
                    latitude: data['coordinates'][i][1],
                    longitude: data['coordinates'][i][0]));
              }
              var lineOptions = new LineOptions(
                  geometry: coordinates,
                  lineColor: "#000000",
                  lineWidth: 14.0,
                  lineOpacity: 1.0);

              await _mapController.addLine(lineOptions);
              await _directions.startNavigation(
                  wayPoints: wayPoints, options: _options);
            },
          ),
          ListTile(
            leading: Icon(Icons.run_circle),
            title: Text('Evacuation Route 2'),
            onTap: () => print('route pressed'),
          ),
          ListTile(
            leading: Icon(Icons.run_circle),
            title: Text('Evacuation Route 3'),
            onTap: () => print('route pressed'),
          ),
        ]);
      });
}
