import 'package:flutter/material.dart';
import 'package:uip_tv/features/auth/view/pin_confirmation_screen.dart';
import 'package:uip_tv/features/auth/widget/custom_button.dart';
import 'package:uip_tv/features/auth/widget/text_form_field.dart';
import 'package:uip_tv/utils/size_helper.dart';
import 'package:uip_tv/utils/transitions.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool _isEmailValid = true;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _validateEmail(String value) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    setState(() {
      _isEmailValid = value.isNotEmpty && emailRegex.hasMatch(value);
    });
  }

  void _attemptLogin() {
    _validateEmail(_emailController.text);
    if (_isEmailValid) {
      transition().navigateWithSlideTransition(
          context, const PinConfirmationScreen(),
          transitionDirection: TransitionDirection.right);
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
                          "Forget password ? ",
                          style: TextStyle(
                              fontSize: Sizer.headingText(context),
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: Sizer.inBetweenDistance(context),
                        ),
                        Text(
                          "No Worries, we\'ll send you a reset instructions.",
                          style: TextStyle(
                            fontSize: Sizer.normal2Text(context),
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: Sizer.inBetweenDistance(context),
                        ),
                        CustomTextField(
                          controller: _emailController,
                          hintText: 'Email Address',
                          prefixIcon: Icons.email_outlined,
                          isValid: _isEmailValid,
                          errorText: 'Please enter a valid email address',
                          showError: !_isEmailValid,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: _validateEmail,
                        ),
                        SizedBox(
                          height: Sizer.inBetweenDistance(context),
                        ),
                        PrimaryButton(
                          text: 'Get Code',
                          onTap: _attemptLogin,
                          isLoading: false,
                        ),
                        SizedBox(
                          height: Sizer.inBetweenDistance(context),
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
