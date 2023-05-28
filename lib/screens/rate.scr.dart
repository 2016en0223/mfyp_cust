import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:mfyp_cust/includes/global.dart';
import 'package:rating_dialog/rating_dialog.dart';
import '../includes/utilities/colors.dart';
import '../includes/utilities/dimension.util.dart';

class MFYPRateProvider extends StatefulWidget {
  final String assignedProvider;
  const MFYPRateProvider({super.key, required this.assignedProvider});

  @override
  State<MFYPRateProvider> createState() => _MFYPRateProviderState();
}

class _MFYPRateProviderState extends State<MFYPRateProvider> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: RatingDialog(
            initialRating: 1.0,
            title: const Text(
              "Rate Provider Experience",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            // encourage your user to leave a high rating?
            submitButtonTextStyle: TextStyle(
                color: AppColor.primaryColor,
                fontWeight: FontWeight.w900,
                fontSize: Dimension.fontSize(20)),
            starColor: AppColor.primaryColor,
            starSize: 25,
            message: const Text(
              "Please do well to rate the provider to enable user choose better.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15),
            ),
            // your app's logo?
            image: Image(
              height: Dimension.radiusFx(200),
              width: Dimension.radiusFx(200),
              fit: BoxFit.scaleDown,
              image: const AssetImage("assets/image/provider.png"),
            ),
            submitButtonText: 'Submit',
            enableComment: false,
            onCancelled: () => Get.back(),
            // onSubmitted: (response) {
            //   DatabaseReference ref = FirebaseDatabase.instance
            //       .ref()
            //       .child("providers")
            //       .child(widget.assignedProvider)
            //       .child("rating");
            //   ref.once().then(
            //     (snap) {
            //       if (snap.snapshot.value == null) {
            //         ref.set(starRatingValue.toString());
            //         SystemNavigator.pop();
            //       } else {
            //         double retrieveRating =
            //             double.parse(snap.snapshot.value.toString());
            //         double newRatingAverage =
            //             (retrieveRating + starRatingValue) / 2;
            //         if (response.rating == 1.0) {
            //           starRatingValue = response.rating;
            //           ref.set(newRatingAverage.toString());
            //           setState(() {
            //             starRatingTitle = "Very Bad";
            //           });
            //         }
            //         if (response.rating == 2.0) {
            //           starRatingValue = response.rating;
            //           ref.set(newRatingAverage.toString());
            //           setState(() {
            //             starRatingTitle = "Bad";
            //           });
            //         }
            //         if (response.rating == 3.0) {
            //           starRatingValue = response.rating;
            //           ref.set(newRatingAverage.toString());
            //           setState(() {
            //             starRatingTitle = "Good";
            //           });
            //         }
            //         if (response.rating == 4.0) {
            //           starRatingValue = response.rating;
            //           ref.set(newRatingAverage.toString());
            //           setState(() {
            //             starRatingTitle = "Very Good";
            //           });
            //         }
            //         if (response.rating == 5.0) {
            //           starRatingValue = response.rating;
            //           ref.set(newRatingAverage.toString());
            //           setState(() {
            //             starRatingTitle = "Excellent";
            //           });
            //         }
            //         SystemNavigator.pop();
            //       }
            //     },
            //   );
            onSubmitted: (response) async {
              starRatingValue = response.rating;
              final ref = FirebaseDatabase.instance
                  .ref()
                  .child("providers")
                  .child(widget.assignedProvider)
                  .child("rating");
              final snap = await ref.once();
              if (snap.snapshot.value == null) {
                ref.set(starRatingValue.toString());
                SystemNavigator.pop();
              } else {
                final retrieveRating =
                    double.parse(snap.snapshot.value.toString());
                final newRatingAverage = (retrieveRating + starRatingValue) / 2;
                switch ((response.rating).round()) {
                  case 1:
                    setState(() {
                      starRatingTitle = "Very Bad";
                    });
                    starRatingValue = response.rating;
                    ref.set(newRatingAverage.toString());
                    break;
                  case 2:
                    setState(() {
                      starRatingTitle = "Bad";
                    });
                    starRatingValue = response.rating;
                    ref.set(newRatingAverage.toString());
                    break;
                  case 3:
                    setState(() {
                      starRatingTitle = "Good";
                    });
                    starRatingValue = response.rating;
                    ref.set(newRatingAverage.toString());
                    break;
                  case 4:
                    setState(() {
                      starRatingTitle = "Very Good";
                    });
                    starRatingValue = response.rating;
                    ref.set(newRatingAverage.toString());
                    break;
                  case 5:
                    setState(() {
                      starRatingTitle = "Excellent";
                    });
                    starRatingValue = response.rating;
                    ref.set(newRatingAverage.toString());
                    break;
                }

                SystemNavigator.pop();
              }
            }));
  }
}
