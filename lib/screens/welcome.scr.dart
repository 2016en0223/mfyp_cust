import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import '/screens/login.scr.dart';
import '/screens/register.scr.dart';
import '../includes/utilities/button.util.dart';
import '../includes/utilities/colors.dart';
import '../includes/utilities/dimension.util.dart';

class MFYPWelcomePage extends StatelessWidget {
  const MFYPWelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: Dimension.screenWidth,
        height: Dimension.screenHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Section 1 - Illustration
            Container(
                margin: EdgeInsets.only(top: Dimension.radiusFx(32)),
                width: Dimension.screenWidth,
                child: Image(
                  fit: BoxFit.scaleDown,
                  image: const AssetImage("assets/image/user.png"),
                  width: Dimension.radiusFx(200),
                  height: Dimension.radiusFx(200),
                )),
            // Section 2 - with Caption
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: Dimension.radiusFx(12)),
                  child: Text(
                    "MFYP User's App",
                    style: TextStyle(
                      color: AppColor.secondary,
                      fontWeight: FontWeight.w700,
                      fontSize: Dimension.fontSize(32),
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
                  MFYPButton(
                    onPressed: () {
                      Get.to(() => const MFYPLogin());
                    },
                    text: "Login",
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MFYPButton(
                    onPressed: () {
                      Get.to(() => const MFYPSignUpScreen());
                    },

                    text: "Get Started",

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
