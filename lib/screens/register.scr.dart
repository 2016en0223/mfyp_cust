import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/route_manager.dart';
import '../includes/global.dart';
import '../includes/models/vehicle.information.model.dart';
import '../includes/utilities/button.util.dart';
import '../includes/utilities/colors.dart';
import '../includes/utilities/dialog.util.dart';
import '../includes/utilities/textfield.util.dart';
import '../includes/widget/bottom.navigation.wdg.dart';
import 'login.scr.dart';
import 'main.scr.dart';
import 'welcome.scr.dart';

const String errorMsg = "";

///_____Creating an instance of Firebase Authentication_____

class MFYPSignUpScreen extends StatefulWidget {
  const MFYPSignUpScreen({super.key});

  @override
  State<MFYPSignUpScreen> createState() => _MFYPSignUpScreenState();
}

class _MFYPSignUpScreenState extends State<MFYPSignUpScreen> {
  // List predictedPlacesList = [];
  var geolocator = Geolocator;
  LocationPermission? userLocationPermission;
  List<String> vehicleList = [
    "Toyota",
    "Lexus",
    "Ford",
    "Range Rover",
    "Nissan",
    "Honda"
  ];
  String carDrop = "Car";
  // Initial Selected Value

  // List of items in our dropdown menu

  deviceLocationPermission() async {
    userLocationPermission = await Geolocator.requestPermission();
    if (userLocationPermission == LocationPermission.denied) {
      userLocationPermission = await Geolocator.requestPermission();
    }
    if (userLocationPermission == LocationPermission.whileInUse) {
      userLocationPermission = await Geolocator.requestPermission();
      requestPermission();
    }
    if (userLocationPermission == LocationPermission.always) {
      userLocationPermission = await Geolocator.requestPermission();
      requestPermission();
    }
  }

  @override
  void initState() {
    super.initState();
    deviceLocationPermission();
  }

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  requestPermission() async {
    Position userCPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    userCurrentPosition = userCPosition;
  }

  validateForm() {
    if (fullNameController.text.length < 3) {
      snackBarMessage("name must be atleast 3 Characters.");
    } else if (!emailController.text.contains(regex)) {
      snackBarMessage("Email address is not Valid.");
    } else if (phoneController.text.isEmpty) {
      snackBarMessage("Phone Number is required.");
    } else if (passwordController.text.length < 11) {
      snackBarMessage("Password must be atleast 8 Characters.");
    } else if (passwordController.text != confirmController.text) {
      snackBarMessage("Password do not match.");
    } else {
      saveUserInfoNow();
    }
  }

  saveUserInfoNow() async {
    Get.dialog(const MFYPDialog(
      message: "Setting up...",
    ));
    try {
      final User? credential =
          (await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      ))
              .user;
      if (credential != null) {
        currentFirebaseUser = credential;
        Map credentialMap = {
          "id": credential.uid,
          "email": emailController.text.trim(),
          "fullName": fullNameController.text.trim(),
          "phone": phoneController.text.trim(),
          "latitude": userCurrentPosition!.latitude.toString(),
          "longitude": userCurrentPosition!.longitude.toString(),
        };
        userRef = FirebaseDatabase.instance.ref().child("users");
        userRef!.child(credential.uid).set(credentialMap);
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (ctx) => const MFYPMainScreen()));
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Navigator.of(context).pop();
        snackBarMessage("The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        Navigator.of(context).pop();
        snackBarMessage("The account already exists for that email.");
      }
    } catch (e) {
      Get.back();
      snackBarMessage(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Colors.white,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          title: const Text(
            "Sign Up",
            style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w900,
                fontSize: 18),
          ),
          leading: IconButton(
            onPressed: () {
              Get.to(
                const MFYPWelcomePage(),
              );
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_outlined,
              color: AppColor.primaryColor,
            ),
          ),
        ),
        bottomNavigationBar:
            const MFYPBottomNavigation(), // backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Column(
            children: [
              ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                physics: const BouncingScrollPhysics(),
                children: [
                  // Section 1 - Header
                  Container(
                    margin: const EdgeInsets.only(top: 20, bottom: 12),
                    child: const Text(
                      'User Registration 👋',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 32),
                    child: const Text(
                      "Ensure to put correct information as you will not be able to edit some information after registration.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 12,
                          height: 150 / 100),
                    ),
                  ),

                  // Section 2  - Form
                  // Full Name
                  TextFieldCustom(
                    controller: fullNameController,
                    hintText: 'Full Name',
                    prefixIcon: Container(
                      padding: const EdgeInsets.all(12),
                      child: const Icon(
                        Icons.person_outline,
                        color: AppColor.primaryColor,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  // Username
                  TextFieldCustom(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    hintText: 'Email Address',
                    prefixIcon: Container(
                      padding: const EdgeInsets.all(12),
                      child: const Icon(
                        Icons.email_outlined,
                        color: AppColor.primaryColor,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  // Email
                  TextFieldCustom(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    hintText: "Phone Number",
                    prefixIcon: Container(
                      padding: const EdgeInsets.all(12),
                      child: const Icon(
                        Icons.phone_iphone_outlined,
                        color: AppColor.primaryColor,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  DropdownButton(
                    // Initial Value
                    value: carDrop,

                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),

                    // Array list of items
                    items: vehicleList.map((String car) {
                      return DropdownMenuItem(
                        value: car,
                        child: Text(car),
                      );
                    }).toList(),
                    onChanged: (selectedCar) {
                      setState(() {
                        carDrop = selectedCar!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  // Password
                  TextFieldCustom(
                    controller: passwordController,
                    obscureText: true,

                    hintText: 'Password',
                    prefixIcon: Container(
                      padding: const EdgeInsets.all(12),
                      child: const Icon(
                        Icons.lock_person_outlined,
                        color: AppColor.primaryColor,
                      ),
                    ),
                    //
                  ),

                  const SizedBox(height: 16),
                  // Repeat Password
                  TextFieldCustom(
                    controller: confirmController,
                    obscureText: true,
                    hintText: 'Repeat Password',
                    prefixIcon: Container(
                      padding: const EdgeInsets.all(12),
                      child: const Icon(
                        Icons.lock_person_outlined,
                        color: AppColor.primaryColor,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  // Sign Up Button
                  MFYPButton(
                    text: "Sign Up",
                    onPressed: () {
                      validateForm();
                    },
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  // dropdown() async {
  //   DatabaseReference ref = FirebaseDatabase.instance.ref("car_information");

  //   Iterable<DataSnapshot> event = (await ref.once()).snapshot.children;
  //   for (var car in event) {
  //     vehicleList.add(car.value);
  //   }
  //   return DropdownButton(
  //     // Initial Value
  //     value: carDrop,

  //     // Down Arrow Icon
  //     icon: const Icon(Icons.keyboard_arrow_down),

  //     // Array list of items
  //     items: items.map((String items) {
  //       return DropdownMenuItem(
  //         value: items,
  //         child: Text(items),
  //       );
  //     }).toList(),
  //     // After selecting the desired option,it will
  //     // change button value to selected value
  //     onChanged: (String? newValue) {
  //       setState(() {
  //         dropdownvalue = newValue!;
  //       });
  //     },
  //   );
  // }
}
