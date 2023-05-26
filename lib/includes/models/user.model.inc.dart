import 'package:firebase_database/firebase_database.dart';

class UserModel {
  String? fullName,
      email,
      userID,
      latitude,
      longitude,
      phone,
      carType,
      locationName;

  UserModel(
      {this.fullName,
      this.email,
      this.latitude,
      this.longitude,
      this.userID,
      this.phone,
      this.carType,
      this.locationName});

  UserModel.fromSnapshot(DataSnapshot snapshot) {
    fullName = (snapshot.value as dynamic)["fullName"];
    latitude = (snapshot.value as dynamic)["latitude"];
    longitude = (snapshot.value as dynamic)["longitude"];
    email = (snapshot.value as dynamic)["email"];
    phone = (snapshot.value as dynamic)["phone"];
    carType = (snapshot.value as dynamic)["carType"];
    locationName = (snapshot.value as dynamic)["locationName"];
    userID = snapshot.key;
  }
}
