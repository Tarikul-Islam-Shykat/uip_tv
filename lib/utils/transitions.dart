import 'package:flutter/material.dart';

// ignore: camel_case_types
class transition {
  void navigateWithSlideTransition(
    BuildContext context,
    Widget page, {
    required TransitionDirection transitionDirection, // Enum for direction
  }) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          Offset begin = transitionDirection == TransitionDirection.right
              ? const Offset(1.0, 0.0) // Start from the right
              : const Offset(-1.0, 0.0); // Start from the left

          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }

  void navigateWithPushReplaceTransition(
    BuildContext context,
    Widget page, {
    required TransitionDirection transitionDirection, // Enum for direction
  }) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          Offset begin = transitionDirection == TransitionDirection.right
              ? const Offset(1.0, 0.0) // Start from the right
              : const Offset(-1.0, 0.0); // Start from the left

          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }

  void navigateWithpushAndRemoveUntilTransition(
    BuildContext context,
    Widget page, {
    required TransitionDirection transitionDirection, // Enum for direction
  }) {
    Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            Offset begin = transitionDirection == TransitionDirection.right
                ? const Offset(1.0, 0.0) // Start from the right
                : const Offset(-1.0, 0.0); // Start from the left

            const end = Offset.zero;
            const curve = Curves.easeInOut;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(position: offsetAnimation, child: child);
          },
        ),
        (Route<dynamic> route) => false);
  }
}

enum TransitionDirection { left, right }
