import 'package:firebase_database/firebase_database.dart';

class VehicleInformation {
  String? carName;

  VehicleInformation({this.carName});
  VehicleInformation.fromJson(DataSnapshot snapshot) {
    carName = (snapshot.value as dynamic)["toto"];
  }
}
