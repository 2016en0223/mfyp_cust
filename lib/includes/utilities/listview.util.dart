import 'package:flutter/material.dart';
import 'package:mfyp_cust/includes/api_key.dart';
import 'package:mfyp_cust/includes/plugins/request.url.plugins.dart';
import 'package:mfyp_cust/includes/utilities/dialog.util.dart';

import '../models/predicted_nearby_places.dart';

class MFYPListView extends StatelessWidget {
  final MFYPNearBy? predictedNearby;

  MFYPListView({this.predictedNearby});

  getPlaceDetails(String? placeID, [context]) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => const MFYPDialog(
              message: "Processing",
            ));
    String placeDetailsURL =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeID&key=$apiKey";
    var urlRequest = await requestURL(placeDetailsURL);
    if (urlRequest["status"] == "OK") {}
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
