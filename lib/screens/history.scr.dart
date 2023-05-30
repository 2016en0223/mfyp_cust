import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:mfyp_cust/includes/handlers/user.info.handler.provider.dart';
import 'package:mfyp_cust/includes/widget/history.widget.dart';
import 'package:provider/provider.dart';

import '../includes/utilities/colors.dart';

class MFYPHistoryScreen extends StatefulWidget {
  const MFYPHistoryScreen({super.key});

  @override
  State<MFYPHistoryScreen> createState() => _MFYPHistoryScreenState();
}

class _MFYPHistoryScreenState extends State<MFYPHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Colors.white,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          title: const Text(
            "History",
            style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w900,
                fontSize: 18),
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
        // backgroundColor: Colors.black,
        body: ListView.builder(
            itemCount:
                context.read<MFYPUserInfo>().requestHistoryModelList.length,
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) => MFYPHistoryWidget(
                  requestHistoryModel: context
                      .read<MFYPUserInfo>()
                      .requestHistoryModelList[index],
                )));
  }
}
