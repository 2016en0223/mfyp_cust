import 'package:flutter/material.dart';
import 'package:mfyp_cust/includes/global.dart';
import 'package:mfyp_cust/includes/utilities/colors.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

class MFYPActiveProvider extends StatefulWidget {
  const MFYPActiveProvider({super.key});

  @override
  State<MFYPActiveProvider> createState() => _MFYPActiveProviderState();
}

class _MFYPActiveProviderState extends State<MFYPActiveProvider> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
      ),
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
                    providerKeyList[index]["name"],
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
              subtitle: providerKeyList[index]["car_specialist"],
            )),
      ),
    );
  }
}
