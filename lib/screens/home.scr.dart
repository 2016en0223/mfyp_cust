import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mfyp_cust/includes/api_key.dart';
import 'package:mfyp_cust/includes/handlers/user.info.handler.provider.dart';
import 'package:mfyp_cust/includes/models/direction.details.model.dart';
import 'package:mfyp_cust/includes/plugins/request.url.plugins.dart';
import 'package:provider/provider.dart';
import '../includes/global.dart';
import '../includes/mixins/user.reversegeo.mixin.dart';
import '../includes/utilities/button.util.dart';
import '../includes/utilities/colors.dart';
import 'main.scr.dart';
import 'search.scr.dart';

class MFYPHomeScreen extends StatefulWidget {
  const MFYPHomeScreen({super.key});

  @override
  State<MFYPHomeScreen> createState() => _MFYPHomeScreenState();
}

class _MFYPHomeScreenState extends State<MFYPHomeScreen> {
  final Completer<GoogleMapController> _mapControllerCompleter = Completer();

  GoogleMapController? newGMController;
  static const CameraPosition _initialCamera = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 15,
  );

  late Set<Marker> markerSet;
  late Set<Circle> circleSet;
  late List<LatLng> decodedLatLng;
  double googleMapPadding = 0;
  @override
  void initState() {
    super.initState();
    deviceLocationPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          googleMap(),
          requestUI(),
        ],
      ),
    );
  }

  Future<DirectionDetails> drawRouteEncodedPoints(
      LatLng userLatLng, LatLng techSPLatLng) async {
    String directionURL =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${userLatLng.latitude},${userLatLng.longitude}&destination=${techSPLatLng.latitude},${techSPLatLng.longitude}&key=$apiKey";
    var urlRequest = await requestURL(directionURL);

    DirectionDetails directionInfo = DirectionDetails();
    directionInfo.distanceText =
        urlRequest["routes"][0]["legs"]["distance"]["text"];
    directionInfo.distanceValue =
        urlRequest["routes"][0]["legs"]["distance"]["value"];
    directionInfo.durationText =
        urlRequest["routes"][0]["legs"]["duration"]["text"];
    directionInfo.durationValue =
        urlRequest["routes"][0]["legs"]["duration"]["value"];
    directionInfo.polylinePoints =
        urlRequest["routes"][0]["overview_polyline"]["points"];
    return directionInfo;
  }

  // Position? userCurrentPosition;
  var geolocator = Geolocator;
  LocationPermission? userLocationPermission;

  getUserCurrentLocation() async {
    userCurrentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    LatLng userCurrentPostionLatLng =
        LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);
    CameraPosition userCurrentLocationCam =
        CameraPosition(target: userCurrentPostionLatLng, zoom: 15);
    newGMController!
        .animateCamera(CameraUpdate.newCameraPosition(userCurrentLocationCam));

    String test =
        await UserMixin.userReverseGeocoding(userCurrentPosition!, context);

    print("Is this even working at all?  $test");
  }

  googleMap() => GoogleMap(
      initialCameraPosition: _initialCamera,
      mapType: MapType.normal,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      zoomGesturesEnabled: true,
      zoomControlsEnabled: true,
      padding: EdgeInsets.only(bottom: googleMapPadding),
      onMapCreated: (GoogleMapController controller) {
        _mapControllerCompleter.complete(controller);
        newGMController = controller;
        setState(() {
          googleMapPadding = 150;
        });
        getUserCurrentLocation();
      });
  requestUI() {
    double height = MediaQuery.of(context).size.height * 0.25;
    double width = MediaQuery.of(context).size.width * 0.1;
    double widthSubmit = MediaQuery.of(context).size.width * 0.06;
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Container(
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(25),
            topLeft: Radius.circular(25),
          ),
          color: AppColor.backgroundColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: const [
                Icon(
                  Icons.navigation_outlined,
                  color: AppColor.primaryColor,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Your location",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const SizedBox(
                  width: 35,
                ),
                Text(
                  overflow: TextOverflow.ellipsis,
                  Provider.of<MFYPUserInfo>(context).userCurrentPointLocation ==
                          null
                      ? "Loading..."
                      : (context
                              .read<MFYPUserInfo>()
                              .userCurrentPointLocation!
                              .formattedAddress!)
                          .substring(0, 8),
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 35,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: (() {
                        var searchScreen = Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => const MFYPSearchScreen(),
                          ),
                        );
                        if (searchScreen == "Home") {}
                      }),
                      child: Text(
                        Provider.of<MFYPUserInfo>(context).techSPLocation ==
                                null
                            ? "Workshop location"
                            : Provider.of<MFYPUserInfo>(context)
                                .techSPLocation!
                                .locationName!,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    )
                  ],
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: width, right: widthSubmit),
              child: const Divider(
                thickness: 1,
                color: AppColor.primaryColor,
              ),
            ),
            MFYPButton(text: "Request", onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
