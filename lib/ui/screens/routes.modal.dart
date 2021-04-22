import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:bee_mobile/utils/servicewrapper.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

void showRoutesModal(BuildContext context, ServiceWrapper serviceWrapper,
    MapboxMapController _mapController) {
  var response;
  serviceWrapper.getData().then((value) {
    response = value;
  });

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
              for (var i = 0; i < data['coordinates'].length; i++) {
                coordinates.add(LatLng(
                    data['coordinates'][i][0], data['coordinates'][i][1]));
              }
              var lineOptions = new LineOptions(
                  geometry: coordinates,
                  lineColor: "#000000",
                  lineWidth: 14.0,
                  lineOpacity: 1.0);
              await _mapController.addLine(lineOptions);
              print(_mapController.lines);
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
