import 'package:firebase_database/firebase_database.dart';

import '../global.dart';
class UserModel {
  String? fullName, email, userID, latitude, longitude;

  UserModel(
      {this.fullName, this.email, this.latitude, this.longitude, this.userID});

  UserModel.fromSnapshot(DataSnapshot snapshot) {
    fullName = (snapshot.value as dynamic)["fullName"];
    latitude = (snapshot.value as dynamic)["latitude"];
    longitude = (snapshot.value as dynamic)["longitude"];
    email = (snapshot.value as dynamic)["email"];
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
        print(currentUserModel!.fullName);
        print("Is this model working!");
      }
    });
  }
}
