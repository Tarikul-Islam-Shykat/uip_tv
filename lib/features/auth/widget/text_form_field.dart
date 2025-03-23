import 'package:flutter/material.dart';
import 'package:uip_tv/utils/colors.dart';
import 'package:uip_tv/utils/size_helper.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? prefixIcon;
  final bool isPassword;
  final bool isObscured;
  final bool isValid;
  final String errorText;
  final bool showError;
  final TextInputType keyboardType;
  final Function(String)? onChanged;
  final VoidCallback? onToggleObscure;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.prefixIcon,
    this.isPassword = false,
    this.isObscured = false,
    this.isValid = true,
    this.errorText = '',
    this.showError = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.onToggleObscure,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isValid ? const Color(0xFF333333) : Colors.red,
              width: 1,
            ),
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword && isObscured,
            keyboardType: keyboardType,
            style: TextStyle(
                color: Colors.white, fontSize: Sizer.normal2Text(context)),
            onChanged: onChanged,
            decoration: InputDecoration(
              labelText: hintText, // Label text visible even when typing
              labelStyle: const TextStyle(
                  color: AppPallete.subtilteTextColor), // Label color
              floatingLabelBehavior:
                  FloatingLabelBehavior.auto, // Keeps label floating
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        isObscured ? Icons.visibility_off : Icons.visibility,
                        color: AppPallete.subtilteTextColor,
                      ),
                      onPressed: onToggleObscure,
                    )
                  : Icon(prefixIcon, color: AppPallete.subtilteTextColor),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: Sizer.customHeight(context, 0.02),
              ),
            ),
          ),
        ),
        if (showError)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 12),
            child: Text(
              errorText,
              style: TextStyle(
                color: Colors.red,
                fontSize: Sizer.normalText(context),
              ),
            ),
          ),
      ],
    );
  }
}
