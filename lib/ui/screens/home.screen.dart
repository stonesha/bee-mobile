import 'dart:convert';
import 'dart:math';

import 'package:bee_mobile/ui/screens/routes.modal.dart';
import 'package:bee_mobile/ui/screens/settings.modal.dart';
import 'package:bee_mobile/ui/screens/safety.modal.dart';
import 'package:bee_mobile/utils/config.helper.dart';
import 'package:bee_mobile/utils/location.helper.dart';
import 'package:bee_mobile/utils/servicewrapper.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _serviceWrapper = new ServiceWrapper();
  MapboxMapController _mapController;

  _showEvacuationInstructions(context, _serviceWrapper) async {
    var instructionsJson = await _serviceWrapper.getInstructions();
    var instructions = json.decode(instructionsJson);

    var instructionsTitle = instructions['severity'];
    var type = instructions['type'];
    var actualInstructions = instructions['instructions'];
    var instructionsDesc =
        "The type of emergency is a $type. $actualInstructions";

    Alert(
      context: context,
      type: AlertType.warning,
      title: instructionsTitle,
      desc: instructionsDesc,
      buttons: [
        DialogButton(
          child: Text(
            "UNDERSTOOD",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),
      ],
    ).show();
  }

  _showEvacuationWarning(context, _serviceWrapper) {
    Alert(
      context: context,
      type: AlertType.warning,
      title: "EMERGENCY ALERT",
      desc: "You are in an emergency zone and must evacuate.",
      buttons: [
        DialogButton(
          child: Text(
            "ACKNOWLEDGED",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () async {
            await _serviceWrapper.acknowledgeNotification();
            Navigator.pop(context);
            _showEvacuationInstructions(context, _serviceWrapper);
          },
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),
      ],
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: loadConfigFile(),
        builder: (
          BuildContext buildContext,
          AsyncSnapshot<dynamic> snapshot,
        ) {
          if (snapshot.hasData) {
            return MapboxMap(
              accessToken: snapshot.data['mapbox_api_token'],
              initialCameraPosition: CameraPosition(
                target: LatLng(39.52766, -119.81353),
              ),
              onMapCreated: (MapboxMapController controller) async {
                _mapController = controller;
                //acquire current location (returns the LatLng Instance)
                final location = await acquireCurrentLocation();

                //either moveCamera or animateCamera, animateCamera is smoother doe
                await controller.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      zoom: 15.0,
                      target: location,
                    ),
                  ),
                );

                //add circle denoting user location
                await controller.addCircle(CircleOptions(
                  circleRadius: 8.0,
                  circleColor: '#006992',
                  circleOpacity: 0.8,
                  geometry: location,
                  draggable: false,
                ));

                var zonesJSON = await _serviceWrapper.getZones();
                zonesJSON = zonesJSON.substring(1);
                List<String> zones = zonesJSON.split(r"|");
                double minLong = double.infinity;
                double maxLong = double.negativeInfinity;
                double minLat = double.infinity;
                double maxLat = double.negativeInfinity;
                for (int i = 0; i < zones.length; i++) {
                  List<LatLng> tempCoords = [];
                  List<List<LatLng>> coordinates = [];
                  var zone = json.decode(zones[i])['coordinates'];

                  for (int j = 0; j < zone[0].length; j++) {
                    if (zone[0][j][1] < minLat) minLat = zone[0][j][1];
                    if (zone[0][j][1] > maxLat) maxLat = zone[0][j][1];

                    if (zone[0][j][0] < minLong) minLong = zone[0][j][0];
                    if (zone[0][j][0] > maxLong) maxLong = zone[0][j][0];

                    tempCoords.add(LatLng(zone[0][j][1], zone[0][j][0]));
                  }

                  if (location.latitude > minLat &&
                      location.latitude < maxLat &&
                      location.longitude < maxLong &&
                      location.longitude > minLong) {
                    _showEvacuationWarning(context, _serviceWrapper);
                  }

                  coordinates.add(tempCoords);

                  await controller.addFill(FillOptions(
                      geometry: coordinates,
                      draggable: false,
                      fillColor: "#F08080",
                      fillOpacity: 0.5,
                      fillOutlineColor: "#000000"));
                }
              },
              onMapLongClick: (Point<double> point, LatLng coordinates) async {
                await _mapController.addCircle(CircleOptions(
                  circleRadius: 8.0,
                  circleColor: '#FF0000',
                  circleOpacity: 0.8,
                  geometry: coordinates,
                  draggable: false,
                ));
                _serviceWrapper.sendReport(coordinates);
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text("BEE Mobile"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: () async {
                showSettingsModal(context, _serviceWrapper);
              }),
        ],
        flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[Color(0xFF00AFB5), Color(0xFF102E4A)]))),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.my_location),
        backgroundColor: Color(0xFFE3B505),
        foregroundColor: Colors.white,
        onPressed: () async {
          _mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                zoom: 15.0,
                target: await acquireCurrentLocation(),
              ),
            ),
          );
          _serviceWrapper.sendLocation();
        },
      ),
      bottomNavigationBar: ConvexAppBar(
          style: TabStyle.fixed,
          items: [
            TabItem(icon: Icons.directions, title: 'Routes'),
            TabItem(icon: Icons.map, title: 'Map'),
            TabItem(
                icon: Icon(FontAwesomeIcons.firstAid, color: Colors.white),
                title: 'Safety'),
          ],
          initialActiveIndex: 1, //optional, default as 0
          onTap: (int i) {
            if (i == 0) {
              showRoutesModal(context, _serviceWrapper, _mapController);
              i = 1;
            } else if (i == 2) {
              showSafetyModal(context, _serviceWrapper);
            }
          },
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[Color(0xFF102E4A), Color(0xFF00AFB5)])),
    );
  }
}
