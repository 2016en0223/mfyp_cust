import 'package:firebase_database/firebase_database.dart';

class UserModel {
  String? fullName, email, userID, latitude, longitude, phone;

  UserModel(
      {this.fullName,
      this.email,
      this.latitude,
      this.longitude,
      this.userID,
      this.phone});

  UserModel.fromSnapshot(DataSnapshot snapshot) {
    fullName = (snapshot.value as dynamic)["fullName"];
    latitude = (snapshot.value as dynamic)["latitude"];
    longitude = (snapshot.value as dynamic)["longitude"];
    email = (snapshot.value as dynamic)["email"];
    phone = (snapshot.value as dynamic)["phone"];
    userID = snapshot.key;
  }

  
}
