import 'package:flutter/foundation.dart';

import '../models/location.direction.model.dart';

class MFYPUserInfo extends ChangeNotifier {
  LocationDirection? userCurrentPointLocation;

  void getUserCurrentPoint(LocationDirection userLatLng) {
    userCurrentPointLocation = userLatLng;
    notifyListeners();
  }
}
