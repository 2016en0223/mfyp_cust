import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mfyp_cust/screens/login.scr.dart';
import 'package:mfyp_cust/screens/register.scr.dart';

import '../includes/utilities/colors.dart';

class MFYPWelcomePage extends StatelessWidget {
  const MFYPWelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Section 1 - Illustration
            Container(
                margin: const EdgeInsets.only(top: 32),
                width: MediaQuery.of(context).size.width,
                child: const Image(
                  image: AssetImage("assets/image/user.png"),
                )),
            // Section 2 - Marketky with Caption
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: const Text(
                    "MFYP User's App",
                    style: TextStyle(
                      color: AppColor.secondary,
                      fontWeight: FontWeight.w700,
                      fontSize: 32,
                      fontFamily: "SanFrancisco",
                    ),
                  ),
                ),
                Text(
                  "Service and repair got easy.",
                  style: TextStyle(
                      color: AppColor.secondary.withOpacity(0.7), fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            // Section 3 - Get Started Button
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              margin: const EdgeInsets.only(bottom: 30),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const MFYPLogin()));
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 36, vertical: 18),
                      backgroundColor: AppColor.primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          fontFamily: "SanFrancisco"),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const MFYPSignUpScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 36, vertical: 18),
                      backgroundColor: AppColor.border,
                      shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            color: AppColor.textFieldColor,
                          ),
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                    ),
                    child: const Text(
                      "Get Started",
                      style: TextStyle(
                          color: AppColor.primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          fontFamily: "SanFrancisco"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
