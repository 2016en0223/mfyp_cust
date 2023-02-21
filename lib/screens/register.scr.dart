import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mfyp_cust/includes/utilities/dialog.util.dart';
import 'package:mfyp_cust/includes/utilities/textfield.util.dart';
import 'package:mfyp_cust/screens/login.scr.dart';
import 'package:mfyp_cust/screens/main.scr.dart';
import '../includes/global.dart';
import '../includes/utilities/button.util.dart';
import '../includes/utilities/colors.dart';

const String errorMsg = "";

///_____Creating an instance of Firebase Authentication_____

class MFYPSignUpScreen extends StatefulWidget {
  const MFYPSignUpScreen({super.key});

  @override
  State<MFYPSignUpScreen> createState() => _MFYPSignUpScreenState();
}

class _MFYPSignUpScreenState extends State<MFYPSignUpScreen> {
  var geolocator = Geolocator;
  LocationPermission? userLocationPermission;

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
      snackBarMessage("name must be atleast 3 Characters.", context);
    } else if (!emailController.text.contains(regex)) {
      snackBarMessage("Email address is not Valid.", context);
    } else if (phoneController.text.isEmpty) {
      snackBarMessage("Phone Number is required.", context);
    } else if (passwordController.text.length < 8) {
      snackBarMessage("Password must be atleast 8 Characters.", context);
    } else if (passwordController.text != confirmController.text) {
      snackBarMessage("Password do not match.", context);
    } else {
      saveUserInfoNow();
    }
  }

  saveUserInfoNow() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c) {
          return const MFYPDialog(
            message: "Processing...",
          );
        });
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
          "name": fullNameController.text.trim(),
          "phone": phoneController.text.trim(),
          "address": addressController.text.trim(),
          "latitude": userCurrentPosition!.latitude.toString(),
          "longitude": userCurrentPosition!.longitude.toString(),
        };
        userRef = FirebaseDatabase.instance.ref().child("users");
        userRef!.child(credential.uid).set(credentialMap);
        print("Is this working?");
        Future.delayed(const Duration(seconds: 3), () {
          print("Just checking to confirm if it's working well!");
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (ctx) => const MFYPMainScreen()));
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        snackBarMessage("The password provided is too weak.", context);
      } else if (e.code == 'email-already-in-use') {
        snackBarMessage("The account already exists for that email.", context);
      }
    } catch (e) {
      snackBarMessage(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: AppColor.primaryColor,
        elevation: 0,
        title: const Text('Sign up',
            style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600)),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: SvgPicture.asset('assets/icons/Arrow-left.svg'),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        height: 48,
        alignment: Alignment.center,
        child: TextButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const MFYPLogin(),
              ),
            );
          },
          style: TextButton.styleFrom(
            foregroundColor: AppColor.secondary.withOpacity(0.1),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an account?',
                style: TextStyle(
                  color: AppColor.secondary.withOpacity(0.7),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Text(
                ' Sign in',
                style: TextStyle(
                  color: AppColor.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
      // backgroundColor: Colors.black,
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        physics: const BouncingScrollPhysics(),
        children: [
          // Section 1 - Header
          Container(
            margin: const EdgeInsets.only(top: 20, bottom: 12),
            child: const Text(
              'Welcome to MarketKy  👋',
              style: TextStyle(
                color: AppColor.secondary,
                fontWeight: FontWeight.w700,
                fontFamily: 'poppins',
                fontSize: 20,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 32),
            child: Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing \nelit, sed do eiusmod ',
              style: TextStyle(
                  color: AppColor.secondary.withOpacity(0.7),
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
          //Location
          TextFieldCustom(
              controller: addressController,
              hintText: 'Address', //
              prefixIcon: Container(
                padding: const EdgeInsets.all(12),
                child: const Icon(
                  Icons.location_city_outlined,
                  color: AppColor.primaryColor,
                ),
              )),

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
    );
  }
}
