import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uip_tv/features/auth/view/forget_password.dart';
import 'package:uip_tv/features/auth/view/sign_up_screen.dart';
import 'package:uip_tv/features/auth/widget/custom_button.dart';
import 'package:uip_tv/features/auth/widget/text_form_field.dart';
import 'package:uip_tv/features/payment/view/payment_screen.dart';
import 'package:uip_tv/provider/api_provider.dart';
import 'package:uip_tv/provider/operation_provider.dart';
import 'package:uip_tv/utils/colors.dart';
import 'package:uip_tv/utils/custom_toast/toast_service.dart';
import 'package:uip_tv/utils/size_helper.dart';
import 'package:uip_tv/utils/transitions.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateEmail(String value) {
    var op = Provider.of<AuthOperationProvider>(context, listen: false);
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    op.setEmailValid(value: value.isNotEmpty && emailRegex.hasMatch(value));
  }

  void _validatePassword(String value) {
    var op = Provider.of<AuthOperationProvider>(context, listen: false);
    op.setPasswordValid(value: value.isNotEmpty);
  }

  void _attemptLogin() async {
    var op = Provider.of<AuthOperationProvider>(context, listen: false);
    var ap = Provider.of<ApiDataProvider>(context, listen: false);

    _validateEmail(_emailController.text);
    _validatePassword(_passwordController.text);

    if (op.isEmailValid && op.isPasswordValid) {
      SharedPreferences loginHistory = await SharedPreferences.getInstance();
      await loginHistory.setBool('loginHistory', true);
      transition().navigateWithSlideTransition(context, const PaymentScreen(),
          transitionDirection: TransitionDirection.right);
      _emailController.text = "";
      _passwordController.text = "";
    }
  }

  @override
  void initState() {
    super.initState();
    var op = Provider.of<AuthOperationProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      op.setLoginObscurPassword(value: false);
      op.setEmailValid(value: true);
      op.setPasswordValid(value: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthOperationProvider>(builder: (context, op, child) {
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
                          Center(
                            child: SizedBox(
                              height: Sizer.companyLogoSize(context),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/logo.png',
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: Sizer.inBetweenDistance(context),
                          ),
                          CustomTextField(
                            controller: _emailController,
                            hintText: 'Email Address',
                            prefixIcon: Icons.email_outlined,
                            isValid: op.isEmailValid,
                            errorText: 'Please enter a valid email address',
                            showError: !op.isEmailValid,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: _validateEmail,
                          ),
                          SizedBox(
                            height: Sizer.inBetweenDistance(context),
                          ),
                          CustomTextField(
                            controller: _passwordController,
                            hintText: 'Password',
                            prefixIcon: Icons.lock_outline,
                            isPassword: true,
                            isObscured: op.isLoginObscurPassword,
                            isValid: op.isPasswordValid,
                            errorText: 'Password cannot be empty',
                            showError: !op.isPasswordValid,
                            onChanged: _validatePassword,
                            onToggleObscure: () {
                              op.setLoginObscurPassword(
                                  value: op.isLoginObscurPassword);
                            },
                          ),
                          SizedBox(
                            height: Sizer.inBetweenDistance(context),
                          ),
                          PrimaryButton(
                            text: 'Login',
                            onTap: _attemptLogin,
                            isLoading: false,
                          ),
                          SizedBox(
                            height: Sizer.inBetweenDistance(context),
                          ),
                          TextButton(
                            onPressed: () async {
                              _emailController.text = "";
                              _passwordController.text = "";

                              transition().navigateWithSlideTransition(
                                  context, const ForgetPasswordScreen(),
                                  transitionDirection:
                                      TransitionDirection.right);
                            },
                            child: Text(
                              'Forgot Password',
                              style: TextStyle(
                                color: AppPallete.buttonColor,
                                fontSize: Sizer.normal2Text(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Sign Up text always at the bottom
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 16.0,
                  top: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: Sizer.normal2Text(context),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        _emailController.text = "";
                        _passwordController.text = "";
                        transition().navigateWithSlideTransition(
                            context, const SignUpScreen(),
                            transitionDirection: TransitionDirection.right);
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: AppPallete.buttonColor,
                          fontWeight: FontWeight.bold,
                          fontSize: Sizer.normal2Text(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
