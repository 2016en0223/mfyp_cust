import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import '../../screens/login.scr.dart';
import '../utilities/colors.dart';

class MFYPBottomNavigation extends StatelessWidget {
  const MFYPBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 48,
      alignment: Alignment.center,
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
          TextButton(
            onPressed: () {
              Get.to(
                () => 
                const MFYPLogin(),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColor.primaryColor.withOpacity(0.1),
            ),
            child: const Text(
              "Sign in",
              style: TextStyle(
                color: AppColor.primaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
