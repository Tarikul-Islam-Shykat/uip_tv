import 'package:flutter/material.dart';
import 'toast_widget.dart';
import 'dart:async';
import 'dart:collection';

enum ToastType {
  error,
  warning,
  success,
}

class ToastMessage {
  final String heading;
  final String message;
  final ToastType type;
  final Duration duration;
  final BuildContext context;

  ToastMessage({
    required this.heading,
    required this.message,
    required this.type,
    required this.duration,
    required this.context,
  });
}

class ToastService {
  static _ToastAnimationState? _currentToastState;
  static bool _isVisible = false;
  static OverlayEntry? _currentToast;
  static Timer? _dismissTimer;
  static bool _isProcessing = false;

  // Queue to store toast messages
  static final Queue<ToastMessage> _toastQueue = Queue<ToastMessage>();

  static void showToast({
    required BuildContext context,
    required String heading,
    required String message,
    required ToastType type,
    Duration duration = const Duration(seconds: 3),
  }) {
    // Create a new toast message
    final toastMessage = ToastMessage(
      heading: heading,
      message: message,
      type: type,
      duration: duration,
      context: context,
    );

    // Add the toast to the queue
    _toastQueue.add(toastMessage);

    // If no toast is currently being processed, start processing the queue
    if (!_isProcessing) {
      _processNextToast();
    }
  }

  static void _processNextToast() {
    // If there are no toasts in the queue, exit processing
    if (_toastQueue.isEmpty) {
      _isProcessing = false;
      return;
    }

    _isProcessing = true;

    // If there's a toast currently showing, dismiss it first
    if (_isVisible) {
      _dismissCurrentToast().then((_) {
        // After dismissal, show the next toast
        _showNextToastFromQueue();
      });
    } else {
      // If no toast is showing, show the next one immediately
      _showNextToastFromQueue();
    }
  }

  static void _showNextToastFromQueue() {
    // Check again if queue is empty (could have been cleared while waiting)
    if (_toastQueue.isEmpty) {
      _isProcessing = false;
      return;
    }

    // Get the next toast from the queue
    final nextToast = _toastQueue.removeFirst();

    // Show the toast
    _showToast(
      nextToast.context,
      nextToast.heading,
      nextToast.message,
      nextToast.type,
      nextToast.duration,
    );
  }

  static void _cancelDismissTimer() {
    if (_dismissTimer != null && _dismissTimer!.isActive) {
      _dismissTimer!.cancel();
      _dismissTimer = null;
    }
  }

  static void _showToast(
    BuildContext context,
    String heading,
    String message,
    ToastType type,
    Duration duration,
  ) {
    _cancelDismissTimer();

    GlobalKey<_ToastAnimationState> toastKey =
        GlobalKey<_ToastAnimationState>();

    // Create overlay entry
    _currentToast = OverlayEntry(
      builder: (BuildContext context) => _ToastAnimation(
        key: toastKey,
        child: ToastWidget(
          heading: heading,
          message: message,
          type: type,
          onClose: () {
            _dismissCurrentToast().then((_) {
              _processNextToast();
            });
          },
        ),
      ),
    );

    // Show the toast
    Overlay.of(context).insert(_currentToast!);
    _isVisible = true;

    // Get reference to animation state after build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _currentToastState = toastKey.currentState;
    });

    // Auto dismiss after duration
    _dismissTimer = Timer(duration, () {
      if (_isVisible) {
        _dismissCurrentToast().then((_) {
          _processNextToast();
        });
      }
    });
  }

  static Future<void> _dismissCurrentToast() async {
    _cancelDismissTimer();

    if (_currentToastState != null) {
      try {
        await _currentToastState!.animateOut();
      } catch (e) {
        // Handle any animation errors
      }

      if (_currentToast != null) {
        _currentToast!.remove();
        _currentToast = null;
      }
    } else if (_currentToast != null) {
      // Fallback in case animation state is not available
      _currentToast!.remove();
      _currentToast = null;
    }

    _isVisible = false;
    _currentToastState = null;

    return Future.value();
  }

  // Method to clear all pending toasts
  static void clearAll() {
    _toastQueue.clear();
    if (_isVisible) {
      _dismissCurrentToast();
    }
    _isProcessing = false;
  }
}

class _ToastAnimation extends StatefulWidget {
  final Widget child;

  const _ToastAnimation({super.key, required this.child});

  @override
  _ToastAnimationState createState() => _ToastAnimationState();
}

class _ToastAnimationState extends State<_ToastAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();
  }

  Future<void> animateOut() async {
    if (!mounted) return Future.value();

    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.0, -1.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    setState(() {});
    _controller.reset();
    return _controller.forward().orCancel;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Material(
        color: Colors.transparent,
        child: SafeArea(
          child: SlideTransition(
            position: _offsetAnimation,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'toast_widget.dart';

// enum ToastType {
//   error,
//   warning,
//   success,
// }

// class ToastService {
//   static _ToastAnimationState? _currentToastState;
//   static bool _isVisible = false;
//   static OverlayEntry? _currentToast;

//   // static void showToast({
//   //   required BuildContext context,
//   //   required String heading,
//   //   required String message,
//   //   required ToastType type,
//   //   Duration duration = const Duration(seconds: 3),
//   // }) {
//   //   // If there's already a toast showing, dismiss it first with animation
//   //   if (_isVisible && _currentToastState != null) {
//   //     _dismissCurrentToast();

//   //     // Add a small delay before showing the new toast
//   //     Future.delayed(const Duration(milliseconds: 300), () {
//   //       _showNewToast(context, heading, message, type, duration);
//   //     });
//   //   } else {
//   //     _showNewToast(context, heading, message, type, duration);
//   //   }
//   // }

//   static void showToast({
//     required BuildContext context,
//     required String heading,
//     required String message,
//     required ToastType type,
//     Duration duration = const Duration(seconds: 3),
//   }) {
//     // Cancel any pending dismiss timers
//     _cancelDismissTimer();

//     // If there's already a toast showing, dismiss it first with animation
//     if (_isVisible && _currentToastState != null) {
//       _dismissCurrentToast();

//       // Add a small delay before showing the new toast
//       Future.delayed(const Duration(milliseconds: 300), () {
//         _showNewToast(context, heading, message, type, duration);
//       });
//     } else {
//       _showNewToast(context, heading, message, type, duration);
//     }
//   }

//   static Timer? _dismissTimer;

// // Add a method to cancel any pending dismiss timer
//   static void _cancelDismissTimer() {
//     if (_dismissTimer != null && _dismissTimer!.isActive) {
//       _dismissTimer!.cancel();
//       _dismissTimer = null;
//     }
//   }

//   static void _showNewToast(
//     BuildContext context,
//     String heading,
//     String message,
//     ToastType type,
//     Duration duration,
//   ) {
//     // Cancel any existing dismiss timer
//     _cancelDismissTimer();

//     GlobalKey<_ToastAnimationState> toastKey =
//         GlobalKey<_ToastAnimationState>();

//     // Create overlay entry
//     _currentToast = OverlayEntry(
//       builder: (BuildContext context) => _ToastAnimation(
//         key: toastKey,
//         child: ToastWidget(
//           heading: heading,
//           message: message,
//           type: type,
//           onClose: () {
//             _dismissCurrentToast();
//           },
//         ),
//       ),
//     );

//     // Show the toast
//     Overlay.of(context).insert(_currentToast!);
//     _isVisible = true;

//     // Get reference to animation state
//     _currentToastState = toastKey.currentState;

//     // Auto dismiss after duration
//     _dismissTimer = Timer(duration, () {
//       if (_isVisible) {
//         _dismissCurrentToast();
//       }
//     });
//   }
//   // static void _showNewToast(
//   //   BuildContext context,
//   //   String heading,
//   //   String message,
//   //   ToastType type,
//   //   Duration duration,
//   // ) {
//   //   GlobalKey<_ToastAnimationState> toastKey =
//   //       GlobalKey<_ToastAnimationState>();

//   //   // Create overlay entry
//   //   _currentToast = OverlayEntry(
//   //     builder: (BuildContext context) => _ToastAnimation(
//   //       key: toastKey,
//   //       child: ToastWidget(
//   //         heading: heading,
//   //         message: message,
//   //         type: type,
//   //         onClose: () {
//   //           _dismissCurrentToast();
//   //         },
//   //       ),
//   //     ),
//   //   );

//   //   // Show the toast
//   //   Overlay.of(context).insert(_currentToast!);
//   //   _isVisible = true;

//   //   // Get reference to animation state
//   //   _currentToastState = toastKey.currentState;

//   //   // Auto dismiss after duration
//   //   Future.delayed(duration, () {
//   //     if (_isVisible) {
//   //       _dismissCurrentToast();
//   //     }
//   //   });
//   // }

//   static void _dismissCurrentToast() {
//     if (_currentToastState != null) {
//       _currentToastState!.animateOut().then((_) {
//         if (_currentToast != null) {
//           _currentToast!.remove();
//           _currentToast = null;
//         }
//         _isVisible = false;
//         _currentToastState = null;
//       });
//     } else if (_currentToast != null) {
//       // Fallback in case animation state is not available
//       _currentToast!.remove();
//       _currentToast = null;
//       _isVisible = false;
//     }
//   }
// }

// class _ToastAnimation extends StatefulWidget {
//   final Widget child;

//   const _ToastAnimation({Key? key, required this.child}) : super(key: key);

//   @override
//   _ToastAnimationState createState() => _ToastAnimationState();
// }

// class _ToastAnimationState extends State<_ToastAnimation>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<Offset> _offsetAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );

//     _offsetAnimation = Tween<Offset>(
//       begin: const Offset(0.0, -1.0),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeOut,
//     ));

//     _controller.forward();
//   }

//   Future<void> animateOut() async {
//     _offsetAnimation = Tween<Offset>(
//       begin: Offset.zero,
//       end: const Offset(0.0, -1.0),
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeIn,
//     ));

//     setState(() {});
//     _controller.reset();
//     return _controller.forward().orCancel;
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       top: 0,
//       left: 0,
//       right: 0,
//       child: Material(
//         color: Colors.transparent,
//         child: SafeArea(
//           child: SlideTransition(
//             position: _offsetAnimation,
//             child: widget.child,
//           ),
//         ),
//       ),
//     );
//   }
// }
