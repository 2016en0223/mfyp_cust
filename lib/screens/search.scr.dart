import 'package:flutter/material.dart';
import 'package:mfyp_cust/screens/home.scr.dart';

import '../includes/utilities/colors.dart';
import '../includes/utilities/textfield.util.dart';

class MFYPSearchScreen extends StatefulWidget {
  const MFYPSearchScreen({super.key});

  @override
  State<MFYPSearchScreen> createState() => _MFYPSearchScreenState();
}

final TextEditingController searchNearby = TextEditingController();

class _MFYPSearchScreenState extends State<MFYPSearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: AppColor.backgroundColor,
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    SizedBox.fromSize(
                      size: const Size.fromWidth(20),
                    ),
                    GestureDetector(
                      onTap: (() => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const MFYPHomeScreen()))),
                      child: const Icon(
                        Icons.arrow_back_ios_new_outlined,
                        color: AppColor.primaryColor,
                      ),
                    ),
                    Center(
                      child: Text(
                        "Search Nearby Shop",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox.fromSize(
                      size: const Size.fromWidth(20),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 15,
                ),
                Row(
                  children: [
                    const Icon(Icons.location_searching_outlined),
                    SizedBox.fromSize(
                      size: const Size.fromWidth(20),
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: "Search here...",
                      ),
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      controller: searchNearby,
                      onChanged: (value) {},
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
