import 'package:firebase_database/firebase_database.dart';

import '../global.dart';

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

  //Assistance Method to Fetch Current Online User Information

  static void readUserInfo() {
    currentFirebaseUser = fAuth.currentUser!;
    databaseReference = FirebaseDatabase.instance
        .ref()
        .child("providers")
        .child(currentFirebaseUser!.uid);
    databaseReference!.once().then((snappedValue) {
      if (snappedValue.snapshot.value != null) {
        currentUserModel = UserModel.fromSnapshot(snappedValue.snapshot);
      }
    });
  }
}
