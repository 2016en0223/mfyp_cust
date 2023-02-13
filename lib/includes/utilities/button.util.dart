import 'package:flutter/material.dart';
import 'colors.dart';

class MFYPButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const MFYPButton({Key? key, required this.text, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 20;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        fixedSize: Size.fromWidth(
          width,
        ),
        backgroundColor: AppColor.primaryColor,
        elevation: 0,
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class MFYPTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const MFYPTextButton({Key? key, required this.text, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(color: AppColor.primaryColor),
      ),
    );
  }
}
