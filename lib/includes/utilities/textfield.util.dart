import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'colors.dart';

class MFYPTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? labelText;
  final String? hintText;
  final EdgeInsetsGeometry? contentPadding;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final Widget? prefixIcon;
  final Widget? icon;
  final Color? iconColor;
  final Color? prefixIconColor;
  final Color? cursorColor;
  final int? maxLength;
  final MaxLengthEnforcement? maxLengthEnforcement;

  const MFYPTextField({
    Key? key,
    required this.controller,
    required this.keyboardType,
    this.obscureText = false,
    this.labelText,
    this.hintText,
    this.contentPadding = const EdgeInsets.symmetric(
      vertical: 0,
    ),
    this.validator,
    this.autovalidateMode,
    this.hintStyle,
    this.labelStyle,
    this.prefixIcon,
    this.prefixIconColor,
    this.icon,
    this.iconColor = AppColor.textFieldColor,
    this.cursorColor = AppColor.textFieldColor,
    this.maxLength,
    this.maxLengthEnforcement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: maxLength,
      maxLengthEnforcement: maxLengthEnforcement,
      autofocus: true,
      cursorColor: cursorColor,
      autovalidateMode: autovalidateMode,
      validator: validator,
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.black54),
      decoration: InputDecoration(
        floatingLabelStyle: const TextStyle(
          color: AppColor.primaryColor,
          fontSize: 20,
        ),
        icon: icon,
        iconColor: iconColor,
        focusColor: AppColor.textFieldColor,
        hoverColor: AppColor.textFieldColor,
        fillColor: Colors.black,
        prefixIcon: prefixIcon,
        prefixIconColor: prefixIconColor,
        contentPadding: contentPadding,
        labelText: labelText,
        hintText: hintText,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColor.textFieldColor),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColor.textFieldColor,
          ),
        ),
        hintStyle: const TextStyle(
          color: AppColor.textFieldColor,
          fontSize: 15,
          fontStyle: FontStyle.italic,
        ),
        labelStyle: const TextStyle(
          color: AppColor.textFieldColor,
          fontSize: 15,
        ),
      ),
    );
  }
}

class TextFieldCustom extends StatelessWidget {
  final Function(String?)? onChanged;
  final TextEditingController? controller;
  final bool obscureText;
  final String? hintText, labelText;
  final Widget? prefixIcon, suffixIcon;
  final TextInputType? keyboardType;
  final TextStyle? style;
  const TextFieldCustom(
      {super.key,
      this.controller,
      this.obscureText = false,
      this.hintText,
      this.labelText,
      this.prefixIcon,
      this.suffixIcon,
      this.keyboardType,
      this.style,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      controller: controller,
      keyboardType: keyboardType,
      autofocus: false,
      obscureText: obscureText,
      style: style,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        labelStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
        ),
        prefixIcon: prefixIcon,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        enabledBorder: OutlineInputBorder(
          borderSide:
              const BorderSide(color: AppColor.textFieldColor, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColor.primaryColor, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        fillColor: AppColor.primarySoft,
        filled: true,
        //
        suffixIcon: suffixIcon,
      ),
    );
  }
}
