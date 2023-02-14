import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../api_key.dart';
import '../handlers/user.info.handler.provider.dart';
import '../models/location.direction.model.dart';
import '../plugins/request.url.plugins.dart';

class UserMixin {
  static Future<String> userReverseGeocoding(
      Position userCurrentPosition, context) async {
    String formattedAddress = "";

    //This url helps to convert the user latitude and longitude into readable address
    String urlGeocoding =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${userCurrentPosition.latitude},${userCurrentPosition.longitude}&key=$apiKey";

    var urlRequest = await requestURL(urlGeocoding);

    if (urlRequest["status"] == "OK") {
      //The result in JSON format is fed to the location model
      formattedAddress = urlRequest["results"][0]["formatted_address"];
      LocationDirection userCurrentPointLocation = LocationDirection();
      userCurrentPointLocation.locationLat = userCurrentPosition.latitude;
      userCurrentPointLocation.locationLong = userCurrentPosition.longitude;
      userCurrentPointLocation.formattedAddress = formattedAddress;

      Provider.of<MFYPUserInfo>(context, listen: false)
          .getUserCurrentPoint(userCurrentPointLocation);
    }

    // print("Hello + ${urlRequest["status"]} + $formattedAddress");

    return formattedAddress;
  }
}
