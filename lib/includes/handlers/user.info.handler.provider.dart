import 'package:flutter/foundation.dart';
import 'package:mfyp_cust/includes/models/user.model.inc.dart';

import '../models/location.direction.model.dart';

class MFYPUserInfo extends ChangeNotifier {
  LocationDirection? userCurrentPointLocation, techSPLocation;
  UserModel? activeProvider;

  void getUserCurrentPoint(LocationDirection userLatLng) {
    userCurrentPointLocation = userLatLng;
    notifyListeners();
  }

  // void getServiceProviderPoint(LocationDirection spLatLng) {
  //   techSPLocation = spLatLng;
  //   notifyListeners();
  // }

  void getProviderLatLng(LocationDirection latLng) {
    techSPLocation = latLng;
    notifyListeners();
  }

  void getProviderDetails(UserModel activeProviderDetails) {
    activeProvider = activeProviderDetails;
    notifyListeners();
  }
}
