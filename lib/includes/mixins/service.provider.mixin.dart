import '../models/activeprovider.model.dart';

class ActiveProvider {
  static List<ActiveProviderModel> availableProvider = [];
  static void removeProvider(String unavailable) {
    int indexNumber =
        availableProvider.indexWhere((info) => info.providerID == unavailable);
    availableProvider.removeAt(indexNumber);
  }

  static void updateProviderPoint(ActiveProviderModel update) {
    int indexNumber = availableProvider
        .indexWhere((info) => info.providerID == update.providerID);
    availableProvider[indexNumber].locationLat = update.locationLat;
    availableProvider[indexNumber].locationLong = update.locationLong;
  }
}
