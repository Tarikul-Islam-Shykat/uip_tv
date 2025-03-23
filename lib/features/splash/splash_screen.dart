import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uip_tv/features/auth/view/login_screen.dart';
import 'package:uip_tv/features/dashboard/dashboard.dart';
import 'package:uip_tv/utils/size_helper.dart';
import 'package:uip_tv/utils/transitions.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('loginHistory') ?? false;

    log("developer $isLoggedIn");
    if (mounted) {
      if (isLoggedIn) {
        transition().navigateWithpushAndRemoveUntilTransition(
            context, const MainScreen(),
            transitionDirection: TransitionDirection.right);
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
      backgroundColor:
          Colors.black, // Change to your preferred background color
      body: Center(
        child: SizedBox(
          height: Sizer.companyLogoSize(context),
          child: Image.asset(
            'assets/images/logo.png',
          ),
        ),
      ),
    );
  }
}
