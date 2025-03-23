import 'package:flutter/material.dart';
import 'toast_service.dart';

class ToastWidget extends StatelessWidget {
  final String heading;
  final String message;
  final ToastType type;
  final VoidCallback onClose;

  const ToastWidget({
    super.key,
    required this.heading,
    required this.message,
    required this.type,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: _getIcon(),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    heading,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            // GestureDetector(
            //   onTap: onClose,
            //   child: const Padding(
            //     padding: EdgeInsets.only(top: 2),
            //     child: Icon(
            //       Icons.close,
            //       color: Colors.white70,
            //       size: 18,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _getIcon() {
    IconData iconData;

    switch (type) {
      case ToastType.error:
        iconData = Icons.error_outline;
        break;
      case ToastType.warning:
        iconData = Icons.warning_amber_outlined;
        break;
      case ToastType.success:
        iconData = Icons.check_circle_outline;
        break;
    }

    return Icon(
      iconData,
      color: Colors.white,
      size: 20,
    );
  }

  Color _getBackgroundColor() {
    switch (type) {
      case ToastType.error:
        return Colors.red;
      case ToastType.warning:
        return Colors.orange;
      case ToastType.success:
        return Colors.green;
    }
  }
}
