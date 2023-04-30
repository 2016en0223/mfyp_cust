import 'package:firebase_database/firebase_database.dart';

import '../global.dart';
import 'user.model.inc.dart';

class UserMixin {
//Assistance Method to Fetch Current Online User Information

  static void readUserInfo() {
    currentFirebaseUser = fAuth.currentUser;
    databaseReference = FirebaseDatabase.instance.ref().child("users");
    databaseReference!.child(currentFirebaseUser!.uid).once().then((snapped) {
      if (snapped.snapshot.value != null) {
        currentUserModel = UserModel.fromSnapshot(snapped.snapshot);
      }
    });
  }
}
