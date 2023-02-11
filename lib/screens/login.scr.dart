import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../includes/utilities/button.util.dart';
import '../includes/utilities/colors.dart';
import '../includes/utilities/textfield.util.dart';

class MFYPLogin extends StatefulWidget {
  const MFYPLogin({Key? key}) : super(key: key);

  @override
  State<MFYPLogin> createState() => MFYPLoginState();
}

class MFYPLoginState extends State<MFYPLogin> {
  //TextEditingController? fullNameController = TextEditingController();
  final TextEditingController emailAddressController = TextEditingController();
  final TextEditingController passWordController = TextEditingController();
  //TextEditingController? passWordController = TextEditingController();
  String regex =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              const Padding(
                padding: EdgeInsets.all(20.0),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Login as technician",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              MFYPTextField(
                autovalidateMode: AutovalidateMode.always,
                validator: FormBuilderValidators.compose(
                  [
                    FormBuilderValidators.email(
                      errorText: "A valid email address is required",
                    ),
                    FormBuilderValidators.match(regex)
                  ],
                ),
                controller: emailAddressController,
                keyboardType: TextInputType.name,
                obscureText: false,
                labelText: "Email Address",
                hintText: "Please enter your email address",
                icon: const Icon(
                  Icons.alternate_email_outlined,
                ),
                iconColor: AppColor.textFieldColor,
              ),
              const SizedBox(
                height: 20,
              ),
              MFYPTextField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.minLength(
                    8,
                    errorText: "Password must be at least 8 character",
                    allowEmpty: true,
                  ),
                  FormBuilderValidators.maxLength(15,
                      errorText: "Password cannot exceed 15 character")
                ]),
                controller: passWordController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                labelText: "Password",
                hintText: "Please enter your password",
                icon: const Icon(
                  Icons.lock_outlined,
                ),
                iconColor: AppColor.textFieldColor,
              ),
              const SizedBox(
                height: 30,
              ),
              MFYPButton(text: "Login", onPressed: () {}),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("New user? "),
                  MFYPTextButton(
                    text: "Register here",
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  final emailValidity = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  validate() {
    if (emailAddressController.text.isEmpty ||
        passWordController.text.isEmpty) {
      const snackBar = SnackBar(content: Text("A valid email is required"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (emailAddressController.text.isNotEmpty ||
        passWordController.text.isEmpty) {
      const snackBar = SnackBar(content: Text("Password is invalid"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (emailAddressController.text.contains(emailValidity) &&
        passWordController.text.isNotEmpty) {
      // driverLogin();
    }
  }

  /*driverLogin() async {
    final User? firebaseUser = (await fAuth
            .signInWithEmailAndPassword(
      email: emailAddressController.text.trim(),
      password: passWordController.text.trim(),
    )
            .catchError((msg) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error: $msg");
    }))
        .user;
    if (firebaseUser != null) {
      DatabaseReference driversRef =
          FirebaseDatabase.instance.ref().child("drivers");
      driversRef.child(firebaseUser.uid).once().then((driverKey) {
        final snap = driverKey.snapshot;
        if (snap.value != null) {
          currentFirebaseUser = firebaseUser;
          Fluttertoast.showToast(msg: "Login Successful.");
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => const MFYPSplash()));
        } else {
          Fluttertoast.showToast(msg: "No record exist with this email.");
          fAuth.signOut();
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => const MFYPLogin()));
        }
      });
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error Occurred during Login.");
    }
  }*/
}
