import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mfyp_cust/includes/utilities/textfield.util.dart';
import 'package:mfyp_cust/screens/register.scr.dart';

import '../includes/utilities/colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text('Sign in',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w600)),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_outlined,
              color: AppColor.primaryColor,
            ),
          ),
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        bottomNavigationBar: bottom(),
        body: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            physics: const BouncingScrollPhysics(),
            children: [
              // Section 1 - Header
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 12),
                child: const Text(
                  'Welcome Back! 😁',
                  style: TextStyle(
                    color: AppColor.primaryColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 32),
                child: Text(
                  "This page enables registered user to sign in into the project!",
                  style: TextStyle(
                      color: AppColor.primaryColor.withOpacity(0.7),
                      fontSize: 12,
                      height: 150 / 100),
                ),
              ),
              // Section 2 - Form
              // Email
              TextFieldCustom(
                // controller: emailController,
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
              const SizedBox(height: 25),
              // Password
              TextFieldCustom(
                // controller: passwordController,
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
              const SizedBox(height: 24),
              // Sign In button
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const MFYPSignUpScreen()));
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
                  backgroundColor: AppColor.primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),
                child: const Text(
                  'Sign in',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      fontFamily: 'poppins'),
                ),
              ),
            ]));
  }

  Widget bottom() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 48,
      alignment: Alignment.center,
      child: TextButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const MFYPSignUpScreen()));
        },
        style: TextButton.styleFrom(
          foregroundColor: AppColor.primaryColor.withOpacity(0.1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Dont have an account?',
              style: TextStyle(
                color: AppColor.primaryColor.withOpacity(0.7),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Text(
              ' Sign up',
              style: TextStyle(
                color: AppColor.primaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
