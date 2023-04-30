import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mfyp_cust/includes/global.dart';
import 'package:mfyp_cust/includes/utilities/colors.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

// ignore: must_be_immutable
class MFYPActiveProvider extends StatefulWidget {
  DatabaseReference? request;

  MFYPActiveProvider({super.key, this.request});

  @override
  State<MFYPActiveProvider> createState() => _MFYPActiveProviderState();
}

class _MFYPActiveProviderState extends State<MFYPActiveProvider> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        backgroundColor: AppColor.primaryColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            widget.request!.remove();
            SystemNavigator.pop();
          },
          icon: const Icon(
            Icons.close_outlined,
            color: Colors.white,
          ),
        ),
        title: const Text(
          "Active Provider",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      // Navigator.of(context).pop("ClearProviderList"),
      body: ListView.builder(
        itemCount: providerKeyList.length,
        itemBuilder: (BuildContext ontext, int index) => Card(
            elevation: 3,
            shadowColor: AppColor.primaryColor,
            margin: const EdgeInsets.all(5),
            child: ListTile(
              title: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    providerKeyList[index]["fullName"],
                  ),
                  SmoothStarRating(
                    rating: 3.5,
                    color: AppColor.primaryColor,
                    borderColor: Colors.black,
                    allowHalfRating: true,
                    starCount: 5,
                  ),
                ],
              ),
              // subtitle: providerKeyList[index]["car_specialist"],
            )),
      ),
    );
  }
}
