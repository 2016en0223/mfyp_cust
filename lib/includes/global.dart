import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'models/user.model.inc.dart';
import 'utilities/dimension.util.dart';

RegExp regex = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
User? currentFirebaseUser;
DatabaseReference? databaseReference;
UserModel? currentUserModel;
FirebaseAuth? firebaseAuth;
Position? userCurrentPosition;
Set<Marker> markerSet = {};
Set<Circle> circleSet = {};
List providerKeyList = [];
DatabaseReference? userRef;
DatabaseReference? prequest;
FirebaseAuth fAuth = FirebaseAuth.instance;
Dimension radi = Dimension();
String cloudMessagingToken =
    "key=AAAA9AJlyFA:APA91bEn_KntT_quvcOfRWTHzPcWenWPpOzJr4BkJ6SO2zgCwaTHleu7aPsfJgDciZoQHO2qjUUW9nqo0rDz7mPTuhT7YSic48GWKDHkuApMi0ImyhV3mDHdDQPVl-htrFBG6xNqghfR";

