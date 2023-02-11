import 'package:firebase_database/firebase_database.dart';

import '../global.dart';

class UserModel {
  String? firstName, lastName, emailID, userID;

  UserModel({this.firstName, this.lastName, this.emailID, this.userID});

  UserModel.fromSnapshot(DataSnapshot snapshot) {
    firstName = (snapshot.value as dynamic)["firstName"];
    lastName = (snapshot.value as dynamic)["lastName"];
    emailID = (snapshot.value as dynamic)["emailAddress"];
    userID = snapshot.key;
  }

  //Assistance Method to Fetch Current Online User Information

  static void readUserInfo() {
    currentFirebaseUser = firebaseAuth!.currentUser!;
    databaseReference = FirebaseDatabase.instance
        .ref()
        .child("technician")
        .child(currentFirebaseUser!.uid);
    databaseReference!.once().then((snappedValue) {
      if (snappedValue.snapshot.value != null) {
        currentUserModel = UserModel.fromSnapshot(snappedValue.snapshot);
      }
    });
  }
}
