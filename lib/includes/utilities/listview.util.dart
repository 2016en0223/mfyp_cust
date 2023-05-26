import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:mfyp_cust/includes/api_key.dart';
import 'package:mfyp_cust/includes/handlers/user.info.handler.provider.dart';
import 'package:mfyp_cust/includes/models/location.direction.model.dart';
import 'package:mfyp_cust/includes/utilities/dialog.util.dart';
import 'package:provider/provider.dart';

import '../models/predicted_nearby_places.dart';
import '../assistants/requests.dart';

class MFYPListView extends StatelessWidget {
  final MFYPNearBy? predictedNearby;

  const MFYPListView({super.key, this.predictedNearby});

  getPlaceDetails(String? placeID, [context]) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => const MFYPDialog(
              message: "Processing",
            ));
    String placeDetailsURL =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeID&key=$apiKey";
    var urlRequest = await Request.requestURL(placeDetailsURL);
    Get.back();
    if (urlRequest["status"] == "OK") {
      LocationDirection userDirection = LocationDirection();

      userDirection.locationName = urlRequest["result"]["name"];
      userDirection.locationLat =
          urlRequest["result"]["geometry"]["location"]["lat"];
      userDirection.locationLong =
          urlRequest["result"]["geometry"]["location"]["lng"];
      userDirection.placeID = placeID;
      Provider.of<MFYPUserInfo>(context, listen: false)
          .getProviderLatLng(userDirection);
      Get.back(result: "Home");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      subtitle: Text(predictedNearby!.secondaryText!),
      onTap: () => getPlaceDetails(predictedNearby!.placeID, context),
      title: Text(
        predictedNearby!.mainText!,
        overflow: TextOverflow.ellipsis,
      ),
      contentPadding: const EdgeInsets.all(10.0),
      leading: const Icon(Icons.location_city_outlined),
    );
  }
}
