import 'package:flutter/material.dart';
import 'package:onlinedawai/features/auth/screens/login_screen.dart';
import 'package:onlinedawai/features/auth/widgets/otp_input.dart';
import 'package:onlinedawai/features/auth/widgets/resend_buttons.dart';
import 'package:onlinedawai/api/login_api.dart';
import 'package:onlinedawai/api/verification_api.dart';
import 'package:onlinedawai/widgets/bottom_navbar.dart';

class VerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const VerificationScreen({super.key, required this.phoneNumber});

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final List<TextEditingController> _digitControllers =
      List.generate(6, (index) => TextEditingController());
  int resendTimer = 30;
  final LoginApi loginApi = LoginApi();
  final VerificationApi verificationApi = VerificationApi();

  @override
  void initState() {
    super.initState();
    startResendTimer();
  }

  void startResendTimer() {
    Future.delayed(Duration(seconds: 1), () {
      if (mounted && resendTimer > 0) {
        setState(() {
          resendTimer--;
        });
        startResendTimer();
      }
    });
  }

  Future<void> resendCode() async {
    setState(() {
      resendTimer = 30;
    });
    startResendTimer();

    bool success = await loginApi.login(widget.phoneNumber);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP resent successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to resend OTP. Please try again.')),
      );
    }
  }

  Future<void> verifyOtp() async {
    String verificationCode =
        _digitControllers.map((controller) => controller.text).join();
    print("OTP entered: $verificationCode"); // Debug log to verify the OTP
    if (verificationCode.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid 6-digit OTP.')),
      );
      return;
    }

    // Call the verification API
    String? token = await verificationApi.verification(
        widget.phoneNumber, verificationCode);
    if (token != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verification successful!')),
      );
      // Navigate to the next screen or home page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNavBar(token: token)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid OTP. Please try again.')),
      );
    }
  }

  bool isOtpComplete() {
    return _digitControllers.every((controller) => controller.text.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('assets/images/login_image.png'),
              width: 300,
            ),
            Text(
              'OTP Verfication',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'A 6 digit code has been sent to\n${widget.phoneNumber}',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text(
                'Change phone number',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            SizedBox(height: 10),

            // Use OTP Input Widget
            OtpInput(
              digitControllers: _digitControllers,
              verifyOtp: verifyOtp,
              isOtpComplete: isOtpComplete,
            ),

            SizedBox(height: 10),

            // Use Resend Buttons Widget
            ResendButtons(
              resendTimer: resendTimer,
              onResend: resendCode,
            ),
          ],
        ),
      ),
    );
  }
}
