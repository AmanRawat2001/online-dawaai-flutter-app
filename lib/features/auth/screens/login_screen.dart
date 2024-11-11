import 'package:flutter/material.dart';
import 'package:onlinedawai/api/login_api.dart';
import 'package:onlinedawai/features/auth/screens/verification_screen.dart';
import 'package:onlinedawai/features/auth/widgets/error_dialog.dart';
import 'package:onlinedawai/features/auth/widgets/loading_dialog.dart';
import 'package:onlinedawai/features/auth/widgets/login_form.dart';
import 'package:onlinedawai/features/auth/widgets/terms_and_conditions.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _phoneController = TextEditingController();
  final LoginApi _loginApi = LoginApi(); // Create an instance of LoginApi

  LoginScreen({super.key});

  // Function to handle login
  Future<void> _login(BuildContext context) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent tapping outside the dialog
      builder: (BuildContext context) {
        return LoadingDialog(); // Use the LoadingDialog widget
      },
    );

    String phoneNumber = _phoneController.text;
    bool isSuccess = await _loginApi.login(phoneNumber); // Call the login API

    // Dismiss the loading dialog once login is complete
    Navigator.pop(context);

    if (isSuccess) {
      // Handle successful login (e.g., navigate to verification screen)
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => VerificationScreen(phoneNumber: phoneNumber)),
      );
    } else {
      _showErrorDialog(
          context, 'Login failed. Please check your phone number.');
    }
  }

  // Function to show error dialog
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return ErrorDialog(
          message: message,
          onPressed: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get the keyboard visibility
    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (!keyboardVisible) SizedBox(height: 80),
            if (!keyboardVisible)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image(
                  image: AssetImage('assets/images/login_image.png'),
                  width: 300,
                ),
              ),
            if (keyboardVisible) SizedBox(height: 200),
            // LoginForm widget
            LoginForm(
              phoneController: _phoneController,
              loginApi: _loginApi,
              onLoginPressed: _login,
            ),
          ],
        ),
      ),
      bottomNavigationBar: TermsAndConditions(),
    );
  }
}
