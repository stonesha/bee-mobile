import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

Future<LatLng> acquireCurrentLocation() async {
  //initilaizes plugin and starts listening for potential platform events
  Location location = new Location();

  //whether or not the locationservice is enabled
  bool serviceEnabled;

  //status of a permission request to use location services
  PermissionStatus permissionGranted;

  //check if the location service is enabled and if not request it
  //if user refuses, return null
  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();

    if (!serviceEnabled) {
      return null;
    }
  }

  //check location permissions, similar in android apps
  //check if permissions granted, if not first request,
  //then read result, only proceed if permission is granted
  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return null;
    }
  }

  final locationData = await location.getLocation();

  return LatLng(locationData.latitude, locationData.longitude);
}
