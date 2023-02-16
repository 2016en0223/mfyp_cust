//------------------------------Dependencies------------------------------------
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mfyp_cust/includes/mixins/service.provider.mixin.dart';
import 'package:mfyp_cust/includes/models/activeprovider.model.dart';
import 'package:mfyp_cust/main.dart';
import 'package:provider/provider.dart';
import '../includes/api_key.dart';
import '../includes/global.dart';
import '../includes/handlers/user.info.handler.provider.dart';
import '../includes/mixins/user.reversegeo.mixin.dart';
import '../includes/models/direction.details.model.dart';
import '../includes/plugins/polyline.plugin.dart';
import '../includes/plugins/request.url.plugins.dart';
import '../includes/utilities/button.util.dart';
import '../includes/utilities/colors.dart';
import '../includes/utilities/dialog.util.dart';
import 'main.scr.dart';
import 'search.scr.dart';

//----------------------------------End-----------------------------------------
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

//--------------------------------Variables--------------------------------------
  var geolocator = Geolocator;
  LocationPermission? userLocationPermission;
  List<LatLng> decodedLatLng = [];
  Set<Polyline> polylineSet = {};
  double googleMapPadding = 0;
  bool activeProviderLoadedKey = false;
  List<ActiveProviderModel> nearbyActiveSPList = [];
//-----------------------------------End-----------------------------------------

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

//-------------------------------User Interface---------------------------------
  googleMap() => GoogleMap(
      initialCameraPosition: _initialCamera,
      mapType: MapType.normal,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      zoomGesturesEnabled: true,
      zoomControlsEnabled: true,
      padding: EdgeInsets.only(bottom: googleMapPadding),
      polylines: polylineSet,
      markers: markerSet,
      circles: circleSet,
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
                      onTap: (() async {
                        var searchScreen = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => const MFYPSearchScreen(),
                          ),
                        );
                        if (searchScreen == "Home") {
                          await drawPolylines();
                        }
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
            MFYPButton(
                text: "Request",
                onPressed: () {
                  if (Provider.of<MFYPUserInfo>(context, listen: false)
                          .techSPLocation ==
                      null) {
                    SnackBar snackBar = const SnackBar(
                      content: Text(
                        "Select the nearest provider to proceed!",
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    saveRequestInfo();
                  }
                }),
          ],
        ),
      ),
    );
  }
//-----------------------------------End-----------------------------------------

//---------------------------------Logics---------------------------------------

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
    activeSPListener();
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

  Future drawPolylines() async {
    var userPosition = Provider.of<MFYPUserInfo>(context, listen: false)
        .userCurrentPointLocation;
    var techPosition =
        Provider.of<MFYPUserInfo>(context, listen: false).techSPLocation;

    LatLng userLatLng =
        LatLng(userPosition!.locationLat!, userPosition.locationLong!);
    LatLng techSPLatLng =
        LatLng(techPosition!.locationLat!, techPosition.locationLong!);
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            const MFYPDialog(message: "Please wait..."));
    var getEncodedPoint = await getEncodedPoints(userLatLng, techSPLatLng);
    Navigator.of(context).pop();

    PolylinePoints points = PolylinePoints();
    List<PointLatLng> decodedpoints =
        points.decodePolyline(getEncodedPoint!.polylinePoints!);
    if (decodedpoints.isNotEmpty) {
      for (var point in decodedpoints) {
        decodedLatLng.add(LatLng(point.latitude, point.longitude));
      }
    }
    polylineSet.clear();
    setState(() {
      Polyline drawLine = Polyline(
          polylineId: const PolylineId("1"),
          width: 5,
          color: AppColor.primaryColor,
          jointType: JointType.round,
          points: decodedLatLng,
          endCap: Cap.roundCap,
          startCap: Cap.roundCap,
          geodesic: true);
      polylineSet.add(drawLine);
    });
    LatLngBounds bounds;
    if (userLatLng.latitude > techSPLatLng.latitude &&
        userLatLng.longitude > techSPLatLng.longitude) {
      bounds = LatLngBounds(southwest: techSPLatLng, northeast: userLatLng);
    } else if (userLatLng.longitude > techSPLatLng.longitude) {
      bounds = LatLngBounds(
          southwest: LatLng(userLatLng.latitude, techSPLatLng.longitude),
          northeast: LatLng(techSPLatLng.latitude, userLatLng.longitude));
    } else if (userLatLng.latitude > techSPLatLng.longitude) {
      bounds = LatLngBounds(
          southwest: LatLng(techSPLatLng.latitude, userLatLng.longitude),
          northeast: LatLng(userLatLng.latitude, techSPLatLng.longitude));
    } else {
      bounds = LatLngBounds(southwest: userLatLng, northeast: techSPLatLng);
    }
    newGMController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 60));
    Marker userMarker = Marker(
      infoWindow: InfoWindow(
          title: userPosition.locationName, snippet: "User Location"),
      markerId: const MarkerId("user"),
      position: userLatLng,
    );
    Marker techSPMarker = Marker(
      infoWindow: InfoWindow(
          title: techPosition.locationName, snippet: "Workshop Location"),
      markerId: const MarkerId("provider"),
      position: techSPLatLng,
    );
    setState(() {
      markerSet.add(userMarker);
      markerSet.add(techSPMarker);
    });
    Circle userCircle = Circle(
      circleId: const CircleId("user"),
      center: userLatLng,
    );
    Circle techSPCircle = Circle(
      circleId: const CircleId("provider"),
      center: techSPLatLng,
    );
    setState(() {
      circleSet.add(userCircle);
      circleSet.add(techSPCircle);
    });
  }

  activeSPListener() {
    Geofire.initialize("activeProvider");
    Geofire.queryAtLocation(
            userCurrentPosition!.latitude, userCurrentPosition!.longitude, 1)!
        .listen((map) {
      print(map);
      if (map != null) {
        var callBack = map['callBack'];

        //latitude will be retrieved from map['latitude']
        //longitude will be retrieved from map['longitude']

        switch (callBack) {
          case Geofire.onKeyEntered:
            ActiveProviderModel activeTechSP = ActiveProviderModel();
            activeTechSP.providerID = map["key"];
            activeTechSP.locationLat = map["latitude"];
            activeTechSP.locationLong = map["longitude"];
            ActiveProvider.availableProvider.add(activeTechSP);
            if (activeProviderLoadedKey == true) {
              displayActiveProvider();
            }
            break;

          case Geofire.onKeyExited:
            ActiveProvider.removeProvider(map["key"]);
            break;

          case Geofire.onKeyMoved:
            // Update your key's location
            ActiveProviderModel activeTechSP = ActiveProviderModel();
            activeTechSP.providerID = map["key"];
            activeTechSP.locationLat = map["latitude"];
            activeTechSP.locationLong = map["longitude"];
            ActiveProvider.availableProvider.add(activeTechSP);
            ActiveProvider.updateProviderPoint(activeTechSP);
            displayActiveProvider();
            break;

          case Geofire.onGeoQueryReady:
            activeProviderLoadedKey = true;
            displayActiveProvider();
            break;
        }
      }

      setState(() {});
    });
  }

  displayActiveProvider() {
    setState(() {
      markerSet.clear();
      circleSet.clear();

      Set<Marker> providerSet = <Marker>{};

      for (ActiveProviderModel provider in ActiveProvider.availableProvider) {
        LatLng providerPosition =
            LatLng(provider.locationLat!, provider.locationLong!);
        Marker providerMarker = Marker(
          markerId: const MarkerId("providerMarker"),
          position: providerPosition,
          rotation: 360,
        );
        providerSet.add(providerMarker);
        setState(() {
          markerSet = providerSet;
        });
      }
    });
  }

  saveRequestInfo() {
    nearbyActiveSPList = ActiveProvider.availableProvider;
    getNearbySP() async {
      if (nearbyActiveSPList.isEmpty) {
        /*This reomves the service request*/
        setState(() {
          polylineSet.clear();
          markerSet.clear();
          circleSet.clear();
          nearbyActiveSPList.clear();
        });
        //Using Snackbar display no provider available
        Future.delayed(const Duration(seconds: 3), () {
          MyApp.restartApp(context);
        });
      }
    }
  }

//-----------------------------------End-----------------------------------------
}
