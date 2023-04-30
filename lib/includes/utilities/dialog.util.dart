import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mfyp_cust/includes/utilities/colors.dart';

import '../global.dart';

class MFYPDialog extends StatelessWidget {
  final String message;
  const MFYPDialog({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColor.listViewDivider,
      child: Flexible(
        child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: AppColor.listViewDivider,
              borderRadius: BorderRadius.circular(10)),
          child: Row(children: [
            const SizedBox(width: 15),
            const CircularProgressIndicator.adaptive(
              valueColor: AlwaysStoppedAnimation<Color>(AppColor.primaryColor),
            ),
            const SizedBox(width: 15),
            Text(message)
          ]),
        ),
      ),
    );
  }
  
}

class MFYPDialogAction extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget>? actions;
  const MFYPDialogAction(
      {super.key,
      required this.title,
      required this.content,
      required this.actions});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Container(
        height: 50,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: AppColor.listViewDivider,
            borderRadius: BorderRadius.circular(10)),
        child: content,
      ),
      actions: actions,
      backgroundColor: AppColor.listViewDivider,
    );
  }
}
snackBarMessage(String message, [Color? textColor, ToastGravity? gravity]) {
  return Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: gravity ?? ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: const Color.fromARGB(142, 0, 0, 0),
      textColor: textColor ?? Colors.white,
      fontSize: 16.0);
}

snackGet(String title, String message) {
  return Get.snackbar(title, message,
      messageText: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      titleText: Text(
        title,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20),
      ),
      margin: EdgeInsets.only(
          top: radi.snackbarPosition(80, "Height"),
          right: radi.snackbarPosition(20, "Width"),
          left: radi.snackbarPosition(20, "Width")),
      colorText: Colors.white,
      duration: const Duration(milliseconds: 1500),
      shouldIconPulse: true,
      backgroundColor: const Color.fromARGB(120, 0, 0, 0));
}
