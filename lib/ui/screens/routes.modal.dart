import 'dart:convert';

import 'package:bee_mobile/utils/location.helper.dart';
import 'package:flutter/material.dart';
import 'package:bee_mobile/utils/servicewrapper.dart';
import 'package:flutter_mapbox_navigation/library.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

Future<void> _onRouteEvent(e) async {
  switch (e.eventType) {
    case MapBoxEvent.navigation_finished:
      print("navigation done");
      break;
    default:
      break;
  }
}

void showRoutesModal(BuildContext context, ServiceWrapper serviceWrapper,
    MapboxMapController _mapController) async {
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

  var routes = await serviceWrapper.getRoutes();
  var location = await acquireCurrentLocation();
  routes = routes.substring(1);
  List<String> routesList = routes.split(r"|");

  List<Widget> widgets = [];

  for (int i = 0; i < routesList.length; i++) {
    var route = json.decode(routesList[i])['coordinates'];
    List<WayPoint> tempWayPoints = [];
    tempWayPoints.add(WayPoint(
        name: "Waypoint {$i}",
        latitude: location.latitude,
        longitude: location.longitude));
    tempWayPoints.add(WayPoint(
        name: "Waypoint {$i}", latitude: route[1], longitude: route[0]));

    var num = i + 1;
    widgets.add(ListTile(
        leading: Icon(Icons.run_circle),
        title: Text('Evacuation Route $num'),
        onTap: () async {
          await _directions.startNavigation(
              wayPoints: tempWayPoints, options: _options);
        }));
  }

  showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(children: widgets);
      });
}
