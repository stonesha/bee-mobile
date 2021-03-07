import 'package:bee_mobile/ui/screens/routes.screen.dart';
import 'package:bee_mobile/utils/config.helper.dart';
import 'package:bee_mobile/utils/location.helper.dart';
import 'package:bee_mobile/utils/servicewrapper.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _serviceWrapper = new ServiceWrapper();

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
        flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[Color(0xFF00AFB5), Color(0xFF102E4A)]))),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.navigation),
        backgroundColor: Color(0xFFE3B505),
        foregroundColor: Colors.white,
        onPressed: _serviceWrapper.sendLocation,
      ),
      bottomNavigationBar: ConvexAppBar(
          style: TabStyle.fixed,
          items: [
            TabItem(icon: Icons.directions, title: 'Routes'),
            TabItem(icon: Icons.map, title: 'Map'),
            TabItem(icon: Icons.settings, title: 'Settings'),
          ],
          initialActiveIndex: 1, //optional, default as 0
          onTap: (int i) {
            if (i == 0) {
              showRoutesModal(context);
            }
          },
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[Color(0xFF102E4A), Color(0xFF00AFB5)])),
    );
  }
}
