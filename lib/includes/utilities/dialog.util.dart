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
snackBarMessage(String message, BuildContext context) {
  SnackBar snackBar = SnackBar(
    content: Text("{$message}"),
  );
  return ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
