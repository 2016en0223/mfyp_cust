import 'package:flutter/material.dart';
import 'package:mfyp_cust/includes/utilities/button.util.dart';
import 'package:mfyp_cust/includes/utilities/colors.dart';

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
snackBarMessage(String message, [ctx]) {
  SnackBar snackBar = SnackBar(
    duration: const Duration(milliseconds: 1000),
    closeIconColor: Colors.white,
    showCloseIcon: true,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
    behavior: SnackBarBehavior.floating,
    dismissDirection: DismissDirection.endToStart,
    margin: EdgeInsets.only(
        right: MediaQuery.of(ctx).size.width * 0.1,
        left: MediaQuery.of(ctx).size.width * 0.1,
        bottom: MediaQuery.of(ctx).size.height * 0.1),
    elevation: 15,
    backgroundColor: const Color.fromARGB(101, 1, 97, 112),
    content: Text(
      message,
      textAlign: TextAlign.center,
      overflow: TextOverflow.clip,
      softWrap: true,
      style: const TextStyle(fontSize: 12),
    ),
  );
  return ScaffoldMessenger.of(ctx).showSnackBar(snackBar);
}
