import 'package:flutter/material.dart';
import 'package:uip_tv/utils/colors.dart';
import 'package:uip_tv/utils/size_helper.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color textColor;
  //final double height;
  final double width;
  final double borderRadius;
  final bool isFullWidth;
  final bool isLoading;
  final IconData? icon;
  final bool iconPosition; // true for left, false for right
  final double fontSize;
  final FontWeight fontWeight;
  final EdgeInsetsGeometry padding;
  final List<BoxShadow>? shadows;
  final Border? border;

  const CustomButton({
    Key? key,
    required this.text,
    this.onTap,
    this.backgroundColor =
        const Color(0xFFFF3B30), // Default color from UIptv design
    this.textColor = Colors.white,
    //  this.height = 50,
    this.width = double.infinity,
    this.borderRadius = 25,
    this.isFullWidth = true,
    this.isLoading = false,
    this.icon,
    this.iconPosition = true, // Default icon on left
    this.fontSize = 16,
    this.fontWeight = FontWeight.bold,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.shadows,
    this.border,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : width,
      height: Sizer.buttonHeight(context),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Ink(
            decoration: BoxDecoration(
              color: isLoading
                  ? backgroundColor.withOpacity(0.7)
                  : backgroundColor,
              borderRadius: BorderRadius.circular(borderRadius),
              boxShadow: shadows,
              border: border,
            ),
            child: Center(
              child: Padding(
                padding: padding,
                child: isLoading
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: textColor,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (icon != null && iconPosition) ...[
                            Icon(icon, color: textColor, size: fontSize + 4),
                            SizedBox(width: 8),
                          ],
                          Text(
                            text,
                            style: TextStyle(
                              color: textColor,
                              fontSize: Sizer.buttonText(context),
                              fontWeight: fontWeight,
                            ),
                          ),
                          if (icon != null && !iconPosition) ...[
                            SizedBox(width: 8),
                            Icon(icon, color: textColor, size: fontSize + 4),
                          ],
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Preset button variations
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final bool isFullWidth;
  final bool isLoading;
  final IconData? icon;
  final bool iconPosition;
  final Color backgroundColor;

  const PrimaryButton({
    Key? key,
    required this.text,
    this.onTap,
    this.isFullWidth = true,
    this.isLoading = false,
    this.icon,
    this.iconPosition = true,
    this.backgroundColor = AppPallete.buttonColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: text,
      onTap: onTap,
      isFullWidth: isFullWidth,
      isLoading: isLoading,
      icon: icon,
      iconPosition: iconPosition,
      backgroundColor: backgroundColor, // UIptv red
      textColor: Colors.white,
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final bool isFullWidth;
  final bool isLoading;
  final IconData? icon;
  final bool iconPosition;

  const SecondaryButton({
    Key? key,
    required this.text,
    this.onTap,
    this.isFullWidth = true,
    this.isLoading = false,
    this.icon,
    this.iconPosition = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: text,
      onTap: onTap,
      isFullWidth: isFullWidth,
      isLoading: isLoading,
      icon: icon,
      iconPosition: iconPosition,
      backgroundColor: Colors.transparent,
      textColor: const Color(0xFFFF3B30),
      border: Border.all(color: const Color(0xFFFF3B30), width: 1.5),
    );
  }
}

class TextOnlyButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;

  const TextOnlyButton({
    Key? key,
    required this.text,
    this.onTap,
    this.textColor = const Color(0xFFFF3B30),
    this.fontSize = 14,
    this.fontWeight = FontWeight.w500,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
        ),
      ),
    );
  }
}

// // Example usage of buttons in the login screen
// class ButtonExampleUsage extends StatelessWidget {
//   const ButtonExampleUsage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // Primary button (login button)
//         PrimaryButton(
//           text: 'Login',
//           onTap: () {
//             // Handle login
//           },
//           isLoading: false,
//         ),
//         const SizedBox(height: 16),
        
//         // Secondary button (outlined style)
//         SecondaryButton(
//           text: 'Sign Up with Email',
//           onTap: () {
//             // Handle sign up
//           },
//           icon: Icons.email_outlined,
//         ),
//         const SizedBox(height: 16),
        
//         // Text only button (for forgot password)
//         TextOnlyButton(
//           text: 'Forgot Password',
//           onTap: () {
//             // Handle forgot password
//           },
//         ),
        
//         // Custom button with specific properties
//         CustomButton(
//           text: 'Continue with Google',
//           onTap: () {
//             // Handle Google sign in
//           },
//           backgroundColor: Colors.white,
//           textColor: Colors.black87,
//           icon: Icons.g_mobiledata,
//           height: 48,
//           fontSize: 15,
//         ),
//       ],
//     );
//   }
// }