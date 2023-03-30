import 'package:flutter/material.dart';
import 'colors.dart';

class MFYPButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? fontSize;
  final FontWeight? fontWeight;
  const MFYPButton(
      {Key? key,
      required this.text,
      required this.onPressed,
      this.fontSize,
      this.fontWeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 20;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
        foregroundColor: AppColor.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        fixedSize: Size.fromWidth(
          width,
        ),
        backgroundColor: AppColor.primaryColor,
        shadowColor: Colors.transparent,
        elevation: 2,
      ),
      child: Text(
        text,
        softWrap: false,
        overflow: TextOverflow.visible,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize ?? 18,
          fontWeight: fontWeight ?? FontWeight.bold,
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
