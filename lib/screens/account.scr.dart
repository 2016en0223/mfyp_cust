import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:mfyp_cust/includes/global.dart';
import 'package:mfyp_cust/includes/utilities/dimension.util.dart';
import '../includes/utilities/colors.dart';

class MFYPProfilePage extends StatefulWidget {
  @override
  _MFYPProfilePageState createState() => _MFYPProfilePageState();
}

class _MFYPProfilePageState extends State<MFYPProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: const Text(
          "Profile",
          style: TextStyle(
              color: Colors.black87, fontWeight: FontWeight.w900, fontSize: 18),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
            color: AppColor.primaryColor,
          ),
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          // Section 1 - Profile Picture - Username - Name
          Container(
            width: Dimension.screenWidth,
            padding: EdgeInsets.symmetric(
                horizontal: Dimension.radiusFx(16),
                vertical: Dimension.radiusFx(24)),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                // Profile Picture
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.grey,
                    image: DecorationImage(
                      image: AssetImage('assets/images/pp.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Fullname
                Container(
                  margin: EdgeInsets.only(bottom: 4, top: 14),
                  child: Text(
                    'Nadsya Utari',
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.8),
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  ),
                ),
                // Username
                Text(
                  '@UtariNad',
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.8), fontSize: 14),
                ),
              ],
            ),
          ),
          // Section 2 - Account Menu
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 16),
                  child: Text(
                    'ACCOUNT INFORMATION',
                    style: TextStyle(
                        color: AppColor.secondary.withOpacity(0.5),
                        letterSpacing: 6 / 100,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: ListTile(
                    tileColor: AppColor.textFieldColor.withOpacity(0.2),
                    onTap: () {},
                    leading: Icon(
                      Icons.arrow_back_ios_new_outlined,
                      color: AppColor.primaryColor,
                    ),
                    title: Text(
                      "Name",
                      style: TextStyle(
                          fontSize: Dimension.fontSize(18),
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      currentUserModel!.fullName!,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                ListTile(
                  tileColor: AppColor.textFieldColor,
                  onTap: () {},
                  leading: Icon(
                    Icons.arrow_back_ios_new_outlined,
                    color: AppColor.primaryColor,
                  ),
                  title: Text(
                    "Name",
                    style: TextStyle(
                        fontSize: Dimension.fontSize(18),
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    currentUserModel!.fullName!,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),

          // Section 3 - Settings
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 16),
                  child: Text(
                    'SETTINGS',
                    style: TextStyle(
                        color: AppColor.secondary.withOpacity(0.5),
                        letterSpacing: 6 / 100,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                ListTile(
                  onTap: () {},
                  leading: Icon(
                    Icons.arrow_back_ios_new_outlined,
                    color: AppColor.primaryColor,
                  ),
                  title: Text('Wishlist'),
                  subtitle: Text('Lorem ipsum Dolor sit Amet'),
                ),
                ListTile(
                  onTap: () {},
                  leading: Icon(
                    Icons.arrow_back_ios_new_outlined,
                    color: AppColor.primaryColor,
                  ),
                  title: Text('Wishlist'),
                  subtitle: Text('Lorem ipsum Dolor sit Amet'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
