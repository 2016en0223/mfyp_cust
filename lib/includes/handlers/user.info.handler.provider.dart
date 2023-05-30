import 'package:flutter/foundation.dart';
import 'package:mfyp_cust/includes/models/user.model.inc.dart';

import '../models/history.model.dart';
import '../models/location.direction.model.dart';

class MFYPUserInfo extends ChangeNotifier {
  LocationDirection? userCurrentPointLocation, techSPLocation;
  UserModel? activeProvider;
  int requestKeyCount = 0;
  List<String> requestKeyHistoryList = [];
  List<RequestHistoryModel> requestHistoryModelList = [];

  void getUserCurrentPoint(LocationDirection userLatLng) {
    userCurrentPointLocation = userLatLng;
    notifyListeners();
  }

  void getProviderLatLng(LocationDirection latLng) {
    techSPLocation = latLng;
    notifyListeners();
  }

  void getProviderDetails(UserModel activeProviderDetails) {
    activeProvider = activeProviderDetails;
    notifyListeners();
  }

  void updateRequestKeyCount(int requestKeyCountAssign) {
    requestKeyCount = requestKeyCountAssign;
    notifyListeners();
  }

  void updateRequestKeyList(List<String> requestKeyList) {
    requestKeyHistoryList = requestKeyList;
    notifyListeners();
  }

  void updateHistoryData(RequestHistoryModel historyData) {
    requestHistoryModelList.add(historyData);
    notifyListeners();
  }
}
