import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../api_key.dart';
import '../models/direction.details.model.dart';
import 'requests.dart';

Future<DirectionDetails?> getEncodedPointsFromProviderToUser(
    LatLng userLatLng, LatLng techSPLatLng) async {
  String directionURL =
      "https://maps.googleapis.com/maps/api/directions/json?origin=${userLatLng.latitude},${userLatLng.longitude}&destination=${techSPLatLng.latitude},${techSPLatLng.longitude}&key=$apiKey";
  var urlRequest = await Request.requestURL(directionURL);

  if (urlRequest == "Error Occured!") {
    return null;
  }

  DirectionDetails directionInfo = DirectionDetails();
  directionInfo.distanceText =
      urlRequest["routes"][0]["legs"][0]["distance"]["text"];
  directionInfo.distanceValue =
      urlRequest["routes"][0]["legs"][0]["distance"]["value"];
  directionInfo.durationText =
      urlRequest["routes"][0]["legs"][0]["duration"]["text"];
  directionInfo.durationValue =
      urlRequest["routes"][0]["legs"][0]["duration"]["value"];
  directionInfo.polylinePoints =
      urlRequest["routes"][0]["overview_polyline"]["points"];
  return directionInfo;
}
