import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mfyp_cust/includes/utilities/button.util.dart';
import 'package:mfyp_cust/includes/utilities/textfield.util.dart';
import 'package:mfyp_cust/screens/account.scr.dart';

import '../includes/utilities/colors.dart';
import 'login_layout.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<RegisterPage> {
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
                MaterialPageRoute(builder: (context) => const LoginPage()));
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
            hintText: 'Full Name',
            prefixIcon: Container(
              padding: const EdgeInsets.all(12),
              child: SvgPicture.asset('assets/icons/Profile.svg',
                  color: AppColor.primary),
            ),
          ),
          const SizedBox(height: 16),
          // Username
          TextFieldCustom(
            hintText: 'Username',
            prefixIcon: Container(
              padding: const EdgeInsets.all(12),
              child: const Text('@',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: AppColor.primary)),
            ),
          ),

          const SizedBox(height: 16),
          // Email
          TextFieldCustom(
            keyboardType: TextInputType.emailAddress,
            hintText: 'youremail@email.com',
            prefixIcon: Container(
              padding: const EdgeInsets.all(12),
              child: SvgPicture.asset('assets/icons/Message.svg',
                  color: AppColor.primary),
            ),
          ),

          const SizedBox(height: 16),
          //Location
          const TextFieldCustom(
            obscureText: true,
            hintText: 'Address', //
          ),

          const SizedBox(height: 16),
          // Password
          TextFieldCustom(
            obscureText: true,

            hintText: 'Password',
            prefixIcon: Container(
              padding: const EdgeInsets.all(12),
              child: SvgPicture.asset('assets/icons/Lock.svg',
                  color: AppColor.primary),
            ),
            //
            suffixIcon: IconButton(
              onPressed: () {},
              icon: SvgPicture.asset('assets/icons/Hide.svg',
                  color: AppColor.primary),
            ),
          ),

          const SizedBox(height: 16),
          // Repeat Password
          TextFieldCustom(
            obscureText: true,
            hintText: 'Repeat Password',
            prefixIcon: Container(
              padding: const EdgeInsets.all(12),
              child: SvgPicture.asset('assets/icons/Lock.svg',
                  color: AppColor.primary),
            ),
            suffixIcon: IconButton(
              onPressed: () {},
              icon: SvgPicture.asset('assets/icons/Hide.svg',
                  color: AppColor.primary),
            ),
          ),

          const SizedBox(height: 24),
          // Sign Up Button
          MFYPButton(
            text: "Sign Up",
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MFYPAccount()));
            },
          ),
        ],
      ),
    );
  }
}
