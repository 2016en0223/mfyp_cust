import 'package:flutter/material.dart';
import 'package:mfyp_cust/includes/api_key.dart';
import 'package:mfyp_cust/includes/models/predicted_nearby_places.dart';
import 'package:mfyp_cust/includes/utilities/listview.util.dart';
import '../includes/global.dart';
import '../includes/plugins/request.url.plugins.dart';
import '../includes/utilities/colors.dart';
import 'home.scr.dart';

class MFYPSearchScreen extends StatefulWidget {
  const MFYPSearchScreen({super.key});

  @override
  State<MFYPSearchScreen> createState() => _MFYPSearchScreenState();
}

class _MFYPSearchScreenState extends State<MFYPSearchScreen> {
  List<MFYPNearBy> predictedNearby = [];

  void nearbySearch(String nearby) async {
    if (nearby.isEmpty) {
      return null;
    }
    if (nearby.isNotEmpty) {
      String placeURL =
          "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${userCurrentPosition!.latitude}%2C${userCurrentPosition!.longitude}&radius=1000&type=car_repair&keyword=$nearby&components=country:NG&key=$apiKey&strict_bound=true";
      // String placeURL =
      // "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=auto&types=car_repair&location=${userCurrentPosition!.latitude}%2C${userCurrentPosition!.longitude}&radius=1500&components=country:NG&key=AIzaSyDX7qXPgTueXavLxcLp8VN9M89XnGdmo_U";
      var urlRequest = await requestURL(placeURL);

      if (urlRequest["status"] == "OK") {
        var nearbyPlaces = urlRequest["results"];
        var nearbyPredictionList = (nearbyPlaces as List)
            .map(
              (jsonresponse) => MFYPNearBy.fromJson(jsonresponse),
            )
            .toList();
        setState(() {
          predictedNearby = nearbyPredictionList;
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: AppColor.backgroundColor,
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: (() => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const MFYPHomeScreen(),
                            ),
                          )),
                      child: const Icon(
                        Icons.arrow_back_ios_new_outlined,
                        color: AppColor.primaryColor,
                      ),
                    ),
                    const Center(
                      child: Text(
                        "Search Nearby Shop",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
                const SizedBox(
                  width: 15,
                ),
                Row(
                  children: [
                    const Icon(Icons.location_searching_outlined),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                            hintText: "Search here...",
                            fillColor: AppColor.textFieldColor,
                            filled: true,
                            hintStyle: TextStyle(fontStyle: FontStyle.italic)),
                        keyboardType: TextInputType.text,
                        onChanged: (value) => nearbySearch(value),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
          predictedNearby.isNotEmpty
              ? Expanded(
                  child: ListView.separated(
                      physics: const ClampingScrollPhysics(),
                      itemBuilder: (context, index) => MFYPListView(
                            predictedNearby: predictedNearby[index],
                          ),
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(
                            thickness: 1,
                            height: 1,
                          ),
                      itemCount: predictedNearby.length))
              : Container(),
        ],
      ),
    );
  }
}
