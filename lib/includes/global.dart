import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'models/user.model.inc.dart';

User? currentFirebaseUser;
DatabaseReference? databaseReference;
UserModel? currentUserModel;
FirebaseAuth? firebaseAuth;
