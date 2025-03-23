import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uip_tv/features/auth/view/login_screen.dart';
import 'package:uip_tv/features/auth/view/sign_up_screen.dart';
import 'package:uip_tv/features/auth/widget/custom_button.dart';
import 'package:uip_tv/features/auth/widget/text_form_field.dart';
import 'package:uip_tv/provider/operation_provider.dart';
import 'package:uip_tv/utils/colors.dart';
import 'package:uip_tv/utils/custom_toast/toast_service.dart';
import 'package:uip_tv/utils/size_helper.dart';
import 'package:uip_tv/utils/transitions.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  // bool _isEmailValid = true;
  // bool _isUserNameValid = true;
  bool _rememberMe = false;
  // bool _isPasswordValid = true;

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

  void _validateUserName(String value) {
    var op = Provider.of<AuthOperationProvider>(context, listen: false);
    op.setUserValid(value: value.isNotEmpty);
  }

  void _validatePassword(String value) {
    var op = Provider.of<AuthOperationProvider>(context, listen: false);
    op.setPasswordValid(value: value.isNotEmpty);
  }

  void _attemptLogin() {
    if (_rememberMe == false) {
      ToastService.showToast(
          context: context,
          heading: "Check Term and Condtion",
          message: "Please check the terms and condition.",
          type: ToastType.warning);
      return;
    }
    var op = Provider.of<AuthOperationProvider>(context, listen: false);

    _validateEmail(_emailController.text);
    _validatePassword(_passwordController.text);
    _validateUserName(_userNameController.text);

    if (op.isEmailValid && op.isPasswordValid && op.isUserNameValid) {
      transition().navigateWithpushAndRemoveUntilTransition(
          context, const LoginScreen(),
          transitionDirection: TransitionDirection.right);
    }
  }

  @override
  void initState() {
    var op = Provider.of<AuthOperationProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      op.setLoginObscurPassword(value: false);
      op.setEmailValid(value: true);
      op.setPasswordValid(value: true);
      op.setUserValid(value: true);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var op = Provider.of<AuthOperationProvider>(context, listen: false);
        op.setLoginObscurPassword(value: false);
        op.setEmailValid(value: true);
        op.setPasswordValid(value: true);
        return true;
      },
      child: Consumer<AuthOperationProvider>(builder: (context, op, child) {
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
                              "Sign Up",
                              style: TextStyle(
                                  fontSize: Sizer.headingText(context),
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: Sizer.inBetweenDistance(context),
                            ),
                            Text(
                              "Integer ultricies dolor enim id sed pulvinar sagittis in. Morbi venenatis nunc turpis morbi. Vitae ullamcorper vehicula praesent lorem. ",
                              style: TextStyle(
                                fontSize: Sizer.normal2Text(context),
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: Sizer.inBetweenDistance(context),
                            ),
                            CustomTextField(
                              controller: _userNameController,
                              hintText: 'User Name',
                              prefixIcon: Icons.person,
                              isValid: op.isUserNameValid,
                              errorText: 'Please enter your user name',
                              showError: !op.isUserNameValid,
                              onChanged: _validateUserName,
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
                                // setState(() {
                                //   _obscurePassword = !_obscurePassword;
                                // });
                              },
                            ),
                            SizedBox(
                              height: Sizer.inBetweenDistance(context),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      value: _rememberMe,
                                      onChanged: (value) {
                                        setState(() {
                                          _rememberMe = value ?? false;
                                        });
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                      checkColor: Colors.white,
                                      activeColor: AppPallete.buttonColor,
                                      visualDensity: VisualDensity.compact,
                                    ),
                                    Text(
                                      "I agreed to the terms & Conditions.",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: Sizer.normal2Text(context),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: Sizer.inBetweenDistance(context),
                            ),
                            PrimaryButton(
                              text: 'Sign Up',
                              onTap: _attemptLogin,
                              isLoading: false,
                            ),
                            SizedBox(
                              height: Sizer.inBetweenDistance(context),
                            ),
                            Center(
                              child: Text(
                                "Or Sign Up With",
                                style: TextStyle(
                                  fontSize: Sizer.normal2Text(context),
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: Sizer.inBetweenDistance(context),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _SocialButton(
                                  icon:
                                      'assets/icons/google.png', // Make sure to add these image assets
                                  onTap: () {
                                    // Handle Google sign up
                                  },
                                ),
                                const SizedBox(width: 16),
                                _SocialButton(
                                  icon: 'assets/icons/fb.png',
                                  onTap: () {
                                    // Handle Facebook sign up
                                  },
                                ),
                                const SizedBox(width: 16),
                                _SocialButton(
                                  icon: 'assets/icons/xicon.png',
                                  onTap: () {
                                    // Handle X (Twitter) sign up
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Sign Up text always at the bottom
                Padding(
                  padding: EdgeInsets.only(
                    bottom: 16.0,
                    top: 8.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already Have An Account? ",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: Sizer.normal2Text(context),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          transition().navigateWithpushAndRemoveUntilTransition(
                              context, const LoginScreen(),
                              transitionDirection: TransitionDirection.right);
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Login',
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
      }),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;

  const _SocialButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(8),
        child: Image.asset(icon),
      ),
    );
  }
}
