import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:uip_tv/utils/colors.dart';
import 'package:uip_tv/utils/size_helper.dart';
import 'package:uip_tv/utils/transitions.dart';

class BottomSuccessSheet extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData? icon;
  final String? iconAssetPath; // For custom image asset
  final Color iconBackgroundColor;
  final Color iconColor;
  final String buttonText;
  final VoidCallback? onButtonPressed;
  final int autoDismissSeconds;
  final bool settingUpCustomer;

  const BottomSuccessSheet({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon, // Made optional to use either icon or image
    this.iconAssetPath, // Added for custom image
    this.iconBackgroundColor = Colors.blue,
    this.iconColor = Colors.white,
    this.buttonText = 'OK, Got it',
    this.onButtonPressed,
    this.autoDismissSeconds = 3,
    this.settingUpCustomer = false,
  }) : assert(icon != null || iconAssetPath != null,
            'Either icon or iconAssetPath must be provided');

  @override
  State<BottomSuccessSheet> createState() => _BottomSuccessSheetState();
}

class _BottomSuccessSheetState extends State<BottomSuccessSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  Timer? _dismissTimer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
    _animationController.forward();
    if (widget.autoDismissSeconds > 0) {
      _dismissTimer = Timer(Duration(seconds: widget.autoDismissSeconds), () {
        _animateOut();
      });
    }
  }

  void _animateOut() {
    _animationController.reverse().then((_) {
      if (mounted && Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
              0, MediaQuery.of(context).size.height * 0.5 * _animation.value),
          child: child,
        );
      },
      child: Container(
        width: double.infinity, // Ensure full width for responsiveness
        padding: EdgeInsets.symmetric(
          horizontal:
              MediaQuery.of(context).size.width * 0.05, // Responsive padding
          vertical: 24,
        ),
        decoration: BoxDecoration(
          color: AppPallete.subtleColor2,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 0,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
              CrossAxisAlignment.start, // Left align all content
          children: [
            // Close button - right aligned
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(
                  color: Colors.white,
                  Icons.close,
                  size: Sizer.customHeight(context, 0.03),
                ),
                onPressed: () {
                  _animateOut();
                },
              ),
            ),
            Center(
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: Sizer.inBetweenDistance(context)),
                    child: Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.25,
                        height: MediaQuery.of(context).size.width * 0.25,
                        child: widget.iconAssetPath != null
                            ? Image.asset(
                                widget.iconAssetPath!,
                                width:
                                    MediaQuery.of(context).size.width * 0.00001,
                                height:
                                    MediaQuery.of(context).size.width * 0.0001,
                              )
                            : Icon(
                                widget.icon,
                                color: Colors.white,
                                size: MediaQuery.of(context).size.width * 0.09,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: Sizer.inBetweenDistance(context)),

            Text(
              widget.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: Sizer.headingText(context), // Responsive font
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left, // Explicitly left-aligned
            ),
            const SizedBox(height: 8),

            Text(
              widget.subtitle,
              style: TextStyle(
                fontSize: Sizer.normalText(context), // Responsive font
                color: Colors.grey,
              ),
              textAlign: TextAlign.left, // Explicitly left-aligned
            ),
            SizedBox(height: Sizer.inBetweenMaxDistance(context)),

            widget.settingUpCustomer
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // _animateOut();
                            // transition().navigateWithSlideTransition(
                            //     context, const MyCartScreen(),
                            //     transitionDirection: TransitionDirection.right);
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.height * 0.02,
                            ),
                            backgroundColor: AppPallete.buttonColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            "Confirm",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Sizer.buttonText(context),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (widget.onButtonPressed != null) {
                              widget.onButtonPressed!();
                            }
                            _animateOut();
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.height * 0.02,
                            ),
                            backgroundColor: AppPallete.buttonColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Sizer.buttonText(context),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (widget.onButtonPressed != null) {
                          widget.onButtonPressed!();
                        }
                        _animateOut();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.02,
                        ),
                        backgroundColor: AppPallete.buttonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        widget.buttonText,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Sizer.buttonText(context),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

            // Safe area for bottom padding
          ],
        ),
      ),
    );
  }
}
