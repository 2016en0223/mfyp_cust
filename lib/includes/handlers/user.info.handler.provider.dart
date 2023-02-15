import 'package:flutter/foundation.dart';

import '../models/location.direction.model.dart';

class MFYPUserInfo extends ChangeNotifier {
  LocationDirection? userCurrentPointLocation, techSPLocation;

  void getUserCurrentPoint(LocationDirection userLatLng) {
    userCurrentPointLocation = userLatLng;
    notifyListeners();
  }

  void getServiceProviderPoint(LocationDirection spLatLng) {
    techSPLocation = spLatLng;
    notifyListeners();
  }
}
