import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:uip_tv/features/auth/view/login_screen.dart';
import 'package:uip_tv/features/auth/widget/custom_button.dart';
import 'package:uip_tv/features/auth/widget/text_form_field.dart';
import 'package:uip_tv/utils/colors.dart';
import 'package:uip_tv/utils/custom_toast/toast_service.dart';
import 'package:uip_tv/utils/size_helper.dart';
import 'package:uip_tv/utils/transitions.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _newpasswordController = TextEditingController();
  final TextEditingController _confirmPasswordwordController =
      TextEditingController();

  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  bool _isPasswordValid = true;

  @override
  void dispose() {
    _newpasswordController.dispose();
    _confirmPasswordwordController.dispose();
    super.dispose();
  }

  void _validatePassword(String value, String value2) {
    setState(() {
      _isPasswordValid = value.isNotEmpty && value.isNotEmpty;
      // _isPasswordValid = value == value2;
    });
  }

  void _attemptLogin() {
    _validatePassword(
      _newpasswordController.text,
      _confirmPasswordwordController.text,
    );
    if (_isPasswordValid) {
      if (_newpasswordController.text.trim() !=
          _confirmPasswordwordController.text.trim()) {
        ToastService.showToast(
          context: context,
          heading: "Warning",
          message: "Password Not Matching.",
          type: ToastType.error,
        );
      } else {
        transition().navigateWithpushAndRemoveUntilTransition(
            context, const LoginScreen(),
            transitionDirection: TransitionDirection.right);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Sizer.deviceDefaultPadding(context)),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: Sizer.inBetweenMaxDistance(context),
                        ),
                        Text(
                          "Reset Your Password",
                          style: TextStyle(
                              fontSize: Sizer.headingText(context),
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: Sizer.inBetweenDistance(context),
                        ),
                        Text(
                          "Vulputate massa in libero diam commodo lorem platea sagittis lectus. Volutpat tristique enim risus blandit sit.",
                          style: TextStyle(
                            fontSize: Sizer.normal2Text(context),
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: Sizer.inBetweenDistance(context),
                        ),
                        CustomTextField(
                          controller: _newpasswordController,
                          hintText: 'Enter New Password',
                          prefixIcon: Icons.lock_outline,
                          isPassword: true,
                          isObscured: _obscureNewPassword,
                          isValid: _isPasswordValid,
                          errorText: 'Password cannot be empty',
                          showError: !_isPasswordValid,
                          // onChanged: _validatePassword,
                          onToggleObscure: () {
                            setState(() {
                              _obscureNewPassword = !_obscureNewPassword;
                            });
                          },
                        ),
                        SizedBox(
                          height: Sizer.inBetweenDistance(context),
                        ),
                        CustomTextField(
                          controller: _confirmPasswordwordController,
                          hintText: 'Confirm Password',
                          prefixIcon: Icons.lock_outline,
                          isPassword: true,
                          isObscured: _obscureConfirmPassword,
                          isValid: _isPasswordValid,
                          errorText: 'Password cannot be empty',
                          showError: !_isPasswordValid,
                          onToggleObscure: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                        ),
                        SizedBox(
                          height: Sizer.inBetweenDistance(context),
                        ),
                        PrimaryButton(
                          text: 'Reset Now',
                          onTap: _attemptLogin,
                          isLoading: false,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Sign Up text always at the bottom
          ],
        ),
      ),
    );
  }
}
