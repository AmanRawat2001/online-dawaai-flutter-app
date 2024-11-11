import 'package:flutter/material.dart';

class ResendButtons extends StatelessWidget {
  final int resendTimer;
  final VoidCallback onResend;

  const ResendButtons({
    Key? key,
    required this.resendTimer,
    required this.onResend,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: resendTimer > 0
          ? Text(
              "Resend in 00:${resendTimer.toString().padLeft(2, '0')}",
              style: TextStyle(color: Colors.grey[700]),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: onResend,
                  child: Text(
                    'Resend via SMS',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Resending OTP via call...'),
                      ),
                    );
                  },
                  child: Text(
                    'Resend via Call',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
    );
  }
}
