import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mfyp_cust/includes/global.dart';
import 'package:mfyp_cust/includes/handlers/user.info.handler.provider.dart';
import 'package:provider/provider.dart';
import '../api_key.dart';
import '../models/direction.details.model.dart';
import '../models/history.model.dart';
import 'requests.dart';

class Assistant {
  static Future<DirectionDetails?> getEncodedPointsFromProviderToUser(
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

  static readRequestKey(context) {
    print("assistance Idan Request");
    FirebaseDatabase.instance
        .ref()
        .child("requests")
        .orderByChild("fullName")
        .equalTo(currentUserModel!.fullName)
        .once()
        .then((snappedValue) {
      if (snappedValue.snapshot.value != null) {
        Map requestKeys = snappedValue.snapshot.value as Map;
        int requestKeyCount = requestKeys.length;
        print("The request key count $requestKeyCount");
        Provider.of<MFYPUserInfo>(context, listen: false)
            .updateRequestKeyCount(requestKeyCount);

        List<String> requestKeyList = [];
        requestKeys.forEach((key, value) {
          requestKeyList.add(key);
          Provider.of<MFYPUserInfo>(context, listen: false)
              .updateRequestKeyList(requestKeyList);
          readRequestHistory(context);
          print("The request key count $requestKeyCount second one");
        });
      }
    });
  }

  static readRequestHistory(context) {
    List<String> allRequestKeys =
        Provider.of<MFYPUserInfo>(context, listen: false).requestKeyHistoryList;
    for (String requestKey in allRequestKeys) {
      FirebaseDatabase.instance
          .ref()
          .child("requests")
          .child(requestKey)
          .once()
          .then((snappedValue) {
        print("The request key $requestKey");
        RequestHistoryModel historyData =
            RequestHistoryModel.fromSnapsot(snappedValue.snapshot);
        if ((snappedValue.snapshot.value as Map)["status"] == "done") {
          //filters only the completed requests

          Provider.of<MFYPUserInfo>(context, listen: false)
              .updateHistoryData(historyData);
        }
        print(
            "The provider counter ${context.read<MFYPUserInfo>().requestHistoryModelList.length}");
      });
    }
  }
}
