//------------------------------Dependencies------------------------------------
// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mfyp_cust/includes/mixins/reverse.geocoding.mixin.dart';
import 'package:mfyp_cust/includes/models/location.direction.model.dart';
import 'package:mfyp_cust/screens/history.scr.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import '../includes/api_key.dart';
import '../includes/global.dart';
import '../includes/handlers/user.info.handler.provider.dart';
import '../includes/mixins/service.provider.mixin.dart';
import '../includes/models/activeprovider.model.dart';
import '../includes/models/direction.details.model.dart';
import '../includes/models/user.model.inc.dart';
import '../includes/assistants/get.encoded.points.assistant.dart';
import '../includes/assistants/requests.dart';
import '../includes/utilities/button.util.dart';
import '../includes/utilities/colors.dart';
import '../includes/utilities/dialog.util.dart';
import '../main.dart';
import 'active.provider.dart';
import 'login.scr.dart';
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
  BitmapDescriptor? activeNearbyIcon;
//-----------------------------------End-----------------------------------------

  @override
  void initState() {
    super.initState();
    initLogin();
    deviceLocationPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        shadowColor: Colors.transparent,
        toolbarHeight: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
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
          googleMapPadding = 170;
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
                    snackBarMessage(
                        "Select the nearest provider to proceed.", context);
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

  initLogin() {
    fAuth.currentUser != null ? UserModel.readUserInfo() : null;
    Timer(const Duration(seconds: 3), () {
      if (fAuth.currentUser == null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (ctx) => const MFYPLogin()));
      }
    });
  }

  getUserCurrentLocation() async {
    userCurrentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    LatLng userCurrentPostionLatLng =
        LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);
    CameraPosition userCurrentLocationCam =
        CameraPosition(target: userCurrentPostionLatLng, zoom: 15);
    newGMController!
        .animateCamera(CameraUpdate.newCameraPosition(userCurrentLocationCam));

    await Geocoding.reverseGeocoding(userCurrentPosition!, context);
    geofireListener();
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
    var getEncodedPoint =
        await getEncodedPointsFromProviderToUser(userLatLng, techSPLatLng);
    Navigator.of(context).pop();

    PolylinePoints points = PolylinePoints();
    List<PointLatLng> decodedpoints =
        points.decodePolyline(getEncodedPoint!.polylinePoints!);
    decodedLatLng.clear();
    if (decodedpoints.isNotEmpty) {
      for (var point in decodedpoints) {
        LatLng points = LatLng(point.latitude, point.longitude);
        decodedLatLng.add(points);
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
    newGMController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
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

  geofireListener() {
    Geofire.initialize("activeProviders");
    Geofire.queryAtLocation(
            userCurrentPosition!.latitude, userCurrentPosition!.longitude, 10)!
        .listen((map) {
      if (map != null) {
        var callBack = map['callBack'];

        switch (callBack) {
          case Geofire.onKeyEntered:
            //This check whenever there is any active provider it will be added to the list
            ActiveProviderModel activeProvider = ActiveProviderModel();
            activeProvider.providerID = map["key"];
            activeProvider.locationLat = map["latitude"];
            activeProvider.locationLong = map["longitude"];
            ActiveProvider.availableProvider.add(activeProvider);

            if (activeProviderLoadedKey == true) {
              displayActiveProviderMarker();
            }
            break;

          case Geofire.onKeyExited:
            ActiveProvider.removeProvider(map["key"]);
            break;

          case Geofire.onKeyMoved:
            /* This check for any available provider and when the location is changed this is triggered */
            ActiveProviderModel activeProvider = ActiveProviderModel();
            activeProvider.providerID = map["key"];
            activeProvider.locationLat = map["latitude"];
            activeProvider.locationLong = map["longitude"];
            ActiveProvider.availableProvider.add(activeProvider);
            ActiveProvider.updateProviderPoint(activeProvider);
            displayActiveProviderMarker();
            break;

          case Geofire.onGeoQueryReady:
            /* This is used to display active provider to the user */
            setState(() {
              activeProviderLoadedKey = true;
            });

            displayActiveProviderMarker();
            break;
        }
      }
    });
  }

  displayActiveProviderMarker() async {
    UserModel? currentUserModelLocal;
    DatabaseReference ref = FirebaseDatabase.instance.ref().child("providers");
    /* This snippet helps to display the nearby provider with marker */
    setState(() {
      markerSet.clear();
      circleSet.clear();

      Set<Marker> providerSet = <Marker>{};

      for (ActiveProviderModel provider in ActiveProvider.availableProvider) {
        LatLng providerPosition =
            LatLng(provider.locationLat!, provider.locationLong!);

        Future.delayed(const Duration(milliseconds: 500), () {
          Marker providerMarker = Marker(
            icon: BitmapDescriptor.defaultMarker,
            markerId: MarkerId(provider.providerID!),
            position: providerPosition,
            rotation: 360,
            infoWindow: InfoWindow(
                title: "Click to proceed",
                onTap: () async {
                  await ref
                      .child(provider.providerID.toString())
                      .once()
                      .then((data) {
                    currentUserModelLocal =
                        UserModel.fromSnapshot(data.snapshot);
                  });
                  QuickAlert.show(
                    context: context,
                    backgroundColor: AppColor.textFieldColor.withAlpha(50),
                    type: QuickAlertType.custom,
                    barrierDismissible: false,
                    showCancelBtn: true,
                    confirmBtnText: "SEND",
                    customAsset: 'assets/image/provider.png',
                    widget: const Text("User Rating"),
                    cancelBtnText: "CANCEL",
                    onCancelBtnTap: () => Navigator.pop(context),
                    confirmBtnColor: AppColor.primaryColor,
                    confirmBtnTextStyle:
                        const TextStyle(fontSize: 12, color: Colors.white),
                    cancelBtnTextStyle: const TextStyle(
                        fontSize: 12, color: AppColor.primaryColor),
                    onConfirmBtnTap: () async {
                      LocationDirection locationDirection = LocationDirection();
                      locationDirection.locationLat = provider.locationLat;
                      locationDirection.locationLong = provider.locationLong;
                      Provider.of<MFYPUserInfo>(context, listen: false).getProviderLatLng(locationDirection);
                      saveRequestInfo();
                      Navigator.pop(context);
                      await Future.delayed(const Duration(milliseconds: 1000));
                      await QuickAlert.show(
                        confirmBtnColor: AppColor.primaryColor,
                        confirmBtnText: "History",
                        onConfirmBtnTap: () => const MFYPHistoryScreen(),
                        cancelBtnText: "OK",
                        showCancelBtn: true,
                        cancelBtnTextStyle:
                            const TextStyle(fontSize: 12, color: Colors.white),
                        onCancelBtnTap: () => Navigator.of(context).pop(),
                        context: context,
                        type: QuickAlertType.success,
                        text: "Request Sent",
                      );
                    },
                    title: currentUserModelLocal!.fullName,
                    text: currentUserModelLocal!.fullName,
                  );
                }),
          );
          providerSet.add(providerMarker);
          setState(() {
            markerSet = providerSet;
          });
        });
      }
    });
  }

  saveRequestInfo() {
    /* This function save the request made by the user and accepted by the provider and this is served to the Firebase */
    prequest = FirebaseDatabase.instance.ref().child("requests").push();
    var userLocation = context.read<MFYPUserInfo>().userCurrentPointLocation;
    var providerLocation = context.read<MFYPUserInfo>().techSPLocation;

    Map userLocationMap = {
      "latitude": userLocation!.locationLat.toString(),
      "longitude": userLocation.locationLong.toString()
    };

    Map providerLocationMap = {
      "latitude": providerLocation!.locationLat.toString(),
      "longitude": providerLocation.locationLong.toString(),
    };

    Map locationMap = {
      "destination": userLocationMap,
      "origin": providerLocationMap,
      "time": DateTime.now().toString(),
      "fullName": currentUserModel!.fullName,
      "phone": currentUserModel!.phone,
      "originAddress": userLocation.locationName,
      "destinationAddress": providerLocation.locationName,
      "providerID": "waiting"
    };
    prequest!.set(locationMap);

    nearbyActiveSPList = ActiveProvider.availableProvider;
    // getNearbySP();
  }

  getNearbySP() async {
    if (nearbyActiveSPList.isEmpty) {
      prequest!.remove();
      /*This removes the service request*/
      setState(() {
        polylineSet.clear();
        markerSet.clear();
        circleSet.clear();
        nearbyActiveSPList.clear();
      });

      snackBarMessage("No provider available at the moment.", context);
      //Using Snackbar display no provider available
      Future.delayed(const Duration(seconds: 3), () {
        MyApp.restartApp(context);
      });

      return;
    }
    await retrieveProviderList(nearbyActiveSPList);
  }

  retrieveProviderList(List nearby) async {
    /* This pieee of code helps to add all the list of available providers from the Firebase to the list to render to users */
    DatabaseReference ref = FirebaseDatabase.instance.ref().child("providers");
    for (int i = 0; nearby.isNotEmpty; i++) {
      await ref
          .child(nearbyActiveSPList[i].providerID.toString())
          .once()
          .then((data) async {
        var providerID = data.snapshot.value;
        providerKeyList.add(providerID);
        if (await Navigator.of(context).push(MaterialPageRoute(
                builder: ((c) => MFYPActiveProvider(request: prequest)))) ==
            "ClearProviderList") {
          providerKeyList.clear();
          /* This piece of code removes the list of available active provider list on pop action as if not clear, the list will keep grow on checking the active provider list subsequently */
        }
      });
    }
  }

//-----------------------------------End-----------------------------------------
}
