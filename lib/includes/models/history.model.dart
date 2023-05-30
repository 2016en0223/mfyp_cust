import 'package:firebase_database/firebase_database.dart';

class RequestHistoryModel {
  String? fullName, dateTime, destinationAddress, status;

  RequestHistoryModel(
      {this.fullName, this.dateTime, this.destinationAddress, this.status});

      RequestHistoryModel.fromSnapsot(DataSnapshot dataSnapshot) {
        fullName = (dataSnapshot.value as dynamic)["fullName"];
        dateTime = (dataSnapshot.value as dynamic)["time"];
        destinationAddress = (dataSnapshot.value as dynamic)["destinationAddress"];
        status = (dataSnapshot.value as dynamic)["status"];
      }
}
