import 'package:flutter/material.dart';
import 'colors.dart';
import '/includes/global.dart';
import 'dimension.util.dart';

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

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: Dimension.radiusFx(36), vertical: Dimension.radiusFx(12),),
        foregroundColor: AppColor.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimension.radiusFx(10)),
        ),
        fixedSize: Size.fromWidth(
          Dimension.screenWidth - 20,
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
