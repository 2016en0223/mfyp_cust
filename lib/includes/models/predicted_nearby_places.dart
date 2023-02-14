import 'package:flutter/material.dart';

class MFYPNearBy {
  MFYPNearBy({this.placeID, this.mainText, this.secondaryText});
  String? placeID, mainText, secondaryText;

  MFYPNearBy.fromJson(Map<String, dynamic> json) {
    placeID = json["place_id"];
    mainText = json["main_text"];
    secondaryText = json["secondary_text"];
  }
}
