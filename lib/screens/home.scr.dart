//------------------------------Dependencies------------------------------------
// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/route_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/shared/types.dart';
import 'package:mfyp_cust/includes/mixins/reverse.geocoding.mixin.dart';
import 'package:mfyp_cust/includes/models/location.direction.model.dart';
import 'package:mfyp_cust/main.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import '../includes/assistants/send.fcm.assistant.dart';
import '../includes/global.dart';
import '../includes/handlers/user.info.handler.provider.dart';
import '../includes/mixins/service.provider.mixin.dart';
import '../includes/models/activeprovider.model.dart';
import '../includes/models/user.mixin.model.dart';
import '../includes/models/user.model.inc.dart';
import '../includes/assistants/get.encoded.points.assistant.dart';
import '../includes/utilities/button.util.dart';
import '../includes/utilities/colors.dart';
import '../includes/utilities/dialog.util.dart';
import '../includes/utilities/dimension.util.dart';
import 'login.scr.dart';
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
  bool option = false;
  double? requestUIHeight = Dimension.screenHeight * 0.35;
  double? requestUI2Height = 0;
  double? requestUI3Height = 0;

  AutomateFCM automateFCM = AutomateFCM();

//-----------------------------------End-----------------------------------------

  @override
  void initState() {
    super.initState();
    initLogin();

    getUserCurrentLocation();
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
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              height: requestUIHeight,
              padding: EdgeInsets.symmetric(
                  horizontal: Dimension.radiusFx(20),
                  vertical: Dimension.radiusFx(20)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(Dimension.radiusFx(20)),
                  topLeft: Radius.circular(Dimension.radiusFx(25)),
                ),
                color: AppColor.backgroundColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.navigation_outlined,
                        color: Colors.black87,
                        size: Dimension.radiusFx(24),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        Provider.of<MFYPUserInfo>(context)
                                    .userCurrentPointLocation ==
                                null
                            ? "Loading..."
                            : "${(context.read<MFYPUserInfo>().userCurrentPointLocation!.formattedAddress!).substring(0, 20)}...",
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.car_repair_outlined,
                        color: Colors.black87,
                        size: 24,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: (() async {
                              var searchScreen =
                                  await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) => const MFYPSearchScreen(),
                                ),
                              );
                              if (searchScreen == "Home") {
                                await drawPolylines();
                              }
                            }),
                            child: Text(
                              Provider.of<MFYPUserInfo>(context)
                                          .techSPLocation ==
                                      null
                                  ? "Workshop location"
                                  : Provider.of<MFYPUserInfo>(context)
                                      .techSPLocation!
                                      .locationName!,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w700),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: Dimension.screenWidth * 0.1,
                        right: Dimension.screenWidth * 0.06),
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
                              "Select the nearest provider to proceed.");
                        } else {
                          showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(
                                        Dimension.radiusFx(20)))),
                            backgroundColor: Colors.white,
                            elevation: 20,
                            context: context,
                            builder: (context) {
                              return Wrap(
                                children: [
                                  ListTile(
                                      leading: const Icon(
                                          Icons.library_add_outlined),
                                      title: const Text("Book Appointment"),
                                      onTap: () => Get.back()),
                                  ListTile(
                                    leading:
                                        const Icon(Icons.car_repair_outlined),
                                    title: const Text("On the go"),
                                    onTap: () {
                                      saveRequestInfo();
                                      Get.back();
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.close_outlined),
                                    title: const Text("Cancel"),
                                    onTap: () => Get.back(),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              height: requestUI2Height,
              padding: EdgeInsets.symmetric(
                  horizontal: Dimension.radiusFx(20),
                  vertical: Dimension.radiusFx(20)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(Dimension.radiusFx(20)),
                  topLeft: Radius.circular(Dimension.radiusFx(25)),
                ),
                color: AppColor.backgroundColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: DefaultTextStyle(
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: Dimension.fontSize(15),
                      fontFamily: 'SanFransisco',
                    ),
                    child: AnimatedTextKit(
                      repeatForever: true,
                      animatedTexts: [
                        ScaleAnimatedText(
                            "Request Sent Successfully\nPlease wait for the provider response",
                            duration: const Duration(seconds: 10)),
                      ],
                      onTap: () {
                        print("Tap Event");
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Wrap(
              children: [
                Container(
                  height: requestUI3Height,
                  padding: const EdgeInsets.only(
                    top: 20,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(Dimension.radiusFx(25)),
                        topRight: Radius.circular(Dimension.radiusFx(25)),
                      ),
                      color: AppColor.backgroundColor),
                  child: Column(
                    children: [
                      //-------------Topbar---------------
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 30, right: 10, bottom: 10),
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: AppColor.primaryColor,
                                borderRadius: BorderRadius.circular(
                                  Dimension.radiusFx(10),
                                ),
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(Dimension.radiusFx(5)),
                                child: Text(
                                  "Hello",
                                  style: TextStyle(
                                      fontSize: Dimension.fontSize(16),
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: Dimension.radiusFx(5)),
                                child: Text(
                                  "Hello",
                                  style: TextStyle(
                                      fontSize: Dimension.fontSize(12),
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.textFieldColor),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      //------------End of Topbar------------

                      //----------End of column bar----------------
                      Padding(
                        padding: EdgeInsets.fromLTRB(Dimension.radiusFx(30),
                            Dimension.radiusFx(15), Dimension.radiusFx(30), 0),
                        child: MFYPButton(
                          // space: false,
                          // fixedSize: 100,
                          // padding: EdgeInsets.symmetric(
                          // vertical: Dimension.radiusFx(10),
                          // horizontal: Dimension.radiusFx(20)),
                          // text: button,
                          onPressed: () {}, text: 'ello',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

//-------------------------------User Interface---------------------------------
  googleMap() {
    return GoogleMap(
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
            googleMapPadding = 200;
          });
        });
  }

//-----------------------------------End-----------------------------------------

//---------------------------------Logics---------------------------------------

  initLogin() {
    currentFirebaseUser == null ? null : UserMixin.readUserInfo();
    Timer(const Duration(seconds: 3), () {
      if (currentFirebaseUser == null) {
        Get.off(() => const MFYPLogin());
      }
    });
  }

  getUserCurrentLocation() async {
    userCurrentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    LatLng userCurrentPositionLatLng =
        LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);
    CameraPosition userCurrentLocationCam =
        CameraPosition(target: userCurrentPositionLatLng, zoom: 15);
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
    Get.dialog(
      const MFYPDialog(message: "Please wait..."),
    );

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
          width: 3,
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
    newGMController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 130));
    Marker userMarker = Marker(
      infoWindow: InfoWindow(
          title: "User Location", snippet: userPosition.formattedAddress),
      markerId: const MarkerId("user"),
      position: userLatLng,
    );
    Marker techSPMarker = Marker(
      infoWindow: InfoWindow(
          title: techPosition.locationName, snippet: "Provider Location"),
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
                title: ">>",
                onTap: () async {
                  await ref
                      .child(provider.providerID.toString())
                      .once()
                      .then((data) {
                    currentUserModelLocal =
                        UserModel.fromSnapshot(data.snapshot);
                  });
                  Get.dialog(Dialogs.materialDialog(
                      barrierDismissible: false,
                      barrierColor: Colors.transparent,
                      color: Colors.white,
                      title: "Provider Information",
                      titleStyle: const TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 20),
                      customView: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.person),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: Text(
                                    currentUserModelLocal!.fullName!,
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: Text(
                                    currentUserModelLocal!.email!,
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            const Row(
                              children: [
                                Icon(Icons.phone_android_outlined),
                                SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: Text(
                                    "Contact Number" ?? "hello" ?? "Hi",
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            const Row(
                              children: [
                                Icon(Icons.car_repair_outlined),
                                SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: Text(
                                    "Service Type",
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      customViewPosition: CustomViewPosition.BEFORE_ACTION,
                      context: context,
                      actions: [
                        MFYPTextButton(
                          text: "Back",
                          onPressed: (() {
                            Get.back();
                          }),
                        ),
                        MFYPButton(
                          onPressed: () {
                            LocationDirection locationDirection =
                                LocationDirection();
                            locationDirection.locationLat =
                                provider.locationLat;
                            locationDirection.locationLong =
                                provider.locationLong;
                            locationDirection.providerID = provider.providerID;
                            locationDirection.locationName =
                                currentUserModelLocal!.locationName;
                            Provider.of<MFYPUserInfo>(context, listen: false)
                                .getProviderLatLng(locationDirection);

                            Marker selectedProviderMarker = Marker(
                                icon: BitmapDescriptor.defaultMarker,
                                markerId: MarkerId(provider.providerID!),
                                position: providerPosition,
                                rotation: 360,
                                infoWindow: InfoWindow(
                                  title: currentUserModelLocal!.fullName,
                                  snippet: currentUserModelLocal!.latitude,
                                ));
                            setState(() {
                              markerSet.clear();
                              markerSet.add(selectedProviderMarker);
                            });
                            Get.back();
                            drawPolylines();
                          },
                          text: "Select",
                          fontSize: 14,
                        ),
                      ]) as Widget);
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
    setState(() {
      option = true;
    });
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

    Map userMeetTheProviderMap = {
      "destination": userLocationMap,
      "origin": providerLocationMap,
      "time": DateTime.now().toString(),
      "fullName": currentUserModel!.fullName,
      "phone": currentUserModel!.phone,
      "carType": currentUserModel!.carType,
      "originAddress": userLocation.locationName,
      "destinationAddress": providerLocation.formattedAddress,
      "spec": currentUserModel!.carType
    };

    Map providerMeetTheUser = {
      "destination": userLocationMap,
      "origin": providerLocationMap,
      "fullName": currentUserModel!.fullName,
      "phone": currentUserModel!.phone,
      "time": DateTime.now().toString(),
      "originAddress": providerLocation.locationName,
      "destinationAddress": userLocation.formattedAddress,
      "spec": currentUserModel!.carType
    };
    option
        ? prequest!.set(providerMeetTheUser)
        : prequest!.set(userMeetTheProviderMap);

    String providerID =
        context.read<MFYPUserInfo>().techSPLocation!.providerID.toString();

    prepareNotificationToProvider(providerID);
  }

  void prepareNotificationToProvider(String selectedProviderID) {
    final ref = FirebaseDatabase.instance
        .ref()
        .child("providers")
        .child(selectedProviderID);
    ref.child("status").set(prequest!.key!);

    /* This function sends a notification using Firebase Cloud Messaging */

    final snapped = ref.child("token").once();
    final snappedToken = snapped.snapshot.value.toString();
    if (snappedToken.isNotEmpty) {
      final deviceToken = snappedToken.toString();
      final requestKey = prequest!.key.toString();
      automateFCM.sendFCMNotificationGet(deviceToken, requestKey, context);
      // AutomateFCM.sendFCMNotification(deviceToken, requestKey, context);

      ref.child("status").onValue.listen((eventSnap) {
        final eventValue = eventSnap.snapshot.value.toString();
        requestUI2();
        if (eventValue == "Idle") {
          snackGet("Failed", "Your request was cancelled");
        } else if (eventValue == "accepted") {
          requestUI3();
        }
      });
    } else if (snappedToken.isEmpty) {
      snackGet("Message", "Request failed");
    }

    await ref.child("status").onValue.first.then((eventSnap) {
      final eventValue = eventSnap.snapshot.value.toString();
      if (eventValue == "Idle") {
        MyApp.restartApp(context);
      } else if (eventValue == "arrived") {
        snackGet("Notification", "Provider has arrived");
      }
    });
  }

  requestUI2() {
    setState(() {
      requestUIHeight = 0;
      requestUI2Height = Dimension.screenHeight * 0.35;
    });
  }

  requestUI3() {
    setState(() {
      requestUIHeight = 0;
      requestUI2Height = 0;
      requestUI3Height = Dimension.screenHeight * 0.35;
    });
  }
  // prepareNotificationToProvider(String selectedProviderID) {
  //   DatabaseReference ref = FirebaseDatabase.instance
  //       .ref()
  //       .child("providers")
  //       .child(selectedProviderID);
  //   ref.child("status").set(prequest!.key!);

  //   /* This function send notification using Firebase Cloud Messaging */

  //   ref.child("token").once().then((snapped) {
  //     String snappedToken = snapped.snapshot.value.toString();
  //     if (snappedToken.isNotEmpty) {
  //       String deviceToken = snappedToken.toString();
  //       String requestKey = prequest!.key.toString();
  //       automateFCM.sendFCMNotificationGet(deviceToken, requestKey, context);
  //       // AutomateFCM.sendFCMNotification(deviceToken, requestKey, context);
  //       FirebaseDatabase.instance
  //           .ref()
  //           .child("providers")
  //           .child(selectedProviderID)
  //           .child("status")
  //           .onValue
  //           .listen((eventSnap) {
  //         String eventValue = eventSnap.snapshot.value.toString();

  //         if (eventValue == "Idle") {
  //           snackGet("Failed", "Your request was cancelled");
  //         } else if (eventValue == "accepted") {
  //           snackBarMessage("accepted");
  //           snackGet("Success", "Request Accepted");
  //         }
  //       });
  //     } else if (snappedToken.toString().isEmpty) {
  //       snackGet("Message", "Request failed");
  //     }
  //   });
  //   FirebaseDatabase.instance
  //       .ref()
  //       .child("providers")
  //       .child(selectedProviderID)
  //       .child("status")
  //       .onValue
  //       .listen((eventSnap) {
  //     String eventValue = eventSnap.snapshot.value.toString();

  //     if (eventValue == "arrived") {
  //       snackGet("Notification", "Provider has arrived");
  //     }
  //   });
  // }

//-----------------------------------End-----------------------------------------
}
