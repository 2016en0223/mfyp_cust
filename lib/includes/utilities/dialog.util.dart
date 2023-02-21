import 'package:flutter/material.dart';
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

snackBarMessage(String message, BuildContext context) {
  SnackBar snackBar = SnackBar(
    content: Text("{$message}"),
  );
  return ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
