import 'package:flutter/material.dart';

class OtpInput extends StatelessWidget {
  final List<TextEditingController> digitControllers;
  final Function verifyOtp;
  final bool Function() isOtpComplete;

  const OtpInput({
    super.key,
    required this.digitControllers,
    required this.verifyOtp,
    required this.isOtpComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(6, (index) {
        return SizedBox(
          width: 48,
          height: 48,
          child: TextField(
            controller: digitControllers[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              counterText: '',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: EdgeInsets.all(8),
            ),
            onChanged: (value) {
              // Automatically move to the next field if a digit is entered
              if (value.isNotEmpty && index < 5) {
                FocusScope.of(context).nextFocus();
              } else if (value.isEmpty && index > 0) {
                FocusScope.of(context).previousFocus();
              }
              // Automatically submit OTP if all fields are filled
              if (isOtpComplete()) {
                verifyOtp();
              }
            },
            onEditingComplete: () {
              // Move to next field when the user finishes typing
              if (index < 5) {
                FocusScope.of(context).nextFocus();
              }
            },
          ),
        );
      }),
    );
  }
}
