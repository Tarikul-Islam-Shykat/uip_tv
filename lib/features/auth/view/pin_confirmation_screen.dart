import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uip_tv/features/auth/view/reset_password_screen.dart';
import 'package:uip_tv/features/auth/widget/custom_button.dart';
import 'package:uip_tv/provider/operation_provider.dart';
import 'package:uip_tv/utils/colors.dart';
import 'package:uip_tv/utils/size_helper.dart';
import 'package:uip_tv/utils/transitions.dart';

class PinConfirmationScreen extends StatefulWidget {
  const PinConfirmationScreen({super.key});

  @override
  State<PinConfirmationScreen> createState() => _PinConfirmationScreenState();
}

class _PinConfirmationScreenState extends State<PinConfirmationScreen> {
  bool enabelSubmitButton = false;
  final List<TextEditingController> _controllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    4,
    (index) => FocusNode(),
  );

  int _currentFocusIndex = 0;

  late Timer _timer;
  int _timeLeft = 10;
  bool _canResend = false;

  void _startTimer() {
    setState(() {
      _timeLeft = 10;
      _canResend = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    var op = Provider.of<AuthOperationProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNodes[0]);
      op.setIsPinCompleted(value: false);
      _startTimer();
    });
    for (int i = 0; i < _focusNodes.length; i++) {
      _focusNodes[i].addListener(() {
        if (_focusNodes[i].hasFocus) {
          setState(() {
            _currentFocusIndex = i;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer

    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _handleKeyEvents(RawKeyEvent event, int index) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.backspace) {
        if (_controllers[index].text.isEmpty && index > 0) {
          FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
          _controllers[index - 1].clear();
        }
      }
    }

    bool isAnyEmpty = _controllers.any((controller) => controller.text.isEmpty);
    if (isAnyEmpty) {
      Provider.of<AuthOperationProvider>(context, listen: false)
          .setIsPinCompleted(value: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthOperationProvider>(builder: (context, op, child) {
      return Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Sizer.deviceDefaultPadding(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: Sizer.inBetweenMaxDistance(context),
              ),
              Text(
                "Enter Your verification Code",
                style: TextStyle(
                    fontSize: Sizer.headingText(context),
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: Sizer.inBetweenDistance(context),
              ),
              Text(
                "Sed varius eget arcu posuere varius tincidunt lectus. Eros justo sollicitudin egestas lorem ipsum. Bibendum.",
                style: TextStyle(
                  fontSize: Sizer.normal2Text(context),
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: Sizer.inBetweenDistance(context),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  4,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    width: Sizer.customWidth(context, 0.1), // Responsive width
                    height: Sizer.customHeight(context, 0.055),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _focusNodes[index].hasFocus
                            ? AppPallete.subtleColor
                            : Colors.grey,
                        width: _focusNodes[index].hasFocus ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color: _focusNodes[index].hasFocus
                          ? AppPallete.subtleColor
                          : AppPallete.subtleColor,
                    ),
                    child: RawKeyboardListener(
                      focusNode: FocusNode(),
                      onKey: (event) => _handleKeyEvents(event, index),
                      child: TextField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        decoration: InputDecoration(
                          counterText: '',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: Sizer.customHeight(context, 0.01)),
                          isDense: true,
                        ),
                        style: TextStyle(
                            fontSize: Sizer.customHeight(context, 0.03),
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            if (index < 3) {
                              op.setIsPinCompleted(value: false);
                              FocusScope.of(context)
                                  .requestFocus(_focusNodes[index + 1]);
                            } else {
                              op.setIsPinCompleted(value: true);
                              FocusScope.of(context).unfocus();
                            }
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: Sizer.inBetweenDistance(context)),
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Resend Code in $_timeLeft Sec.',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: Sizer.inBetweenMaxDistance(context)),
              PrimaryButton(
                text: 'Verify Now',
                onTap: () {
                  transition().navigateWithSlideTransition(
                      context, const ResetPasswordScreen(),
                      transitionDirection: TransitionDirection.right);
                },
                isLoading: false,
              ),
            ],
          ),
        ),
      );
    });
  }
}
