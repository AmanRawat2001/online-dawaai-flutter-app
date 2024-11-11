import 'package:flutter/material.dart';
import 'package:onlinedawai/api/login_api.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController phoneController;
  final LoginApi loginApi;
  final Function(BuildContext) onLoginPressed;

  const LoginForm({
    Key? key,
    required this.phoneController,
    required this.loginApi,
    required this.onLoginPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          width: double.infinity,
          child: Text(
            'Sign in to continue',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
        ),
        SizedBox(height: 16),
        TextField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'Enter your phone number',
            border: OutlineInputBorder(),
            prefixIcon: Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                '+91',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            onLoginPressed(context);
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 110, vertical: 15),
            textStyle: TextStyle(fontSize: 16),
            backgroundColor: Theme.of(context).colorScheme.onSurface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: Text(
            'Get Verification Code',
            style: TextStyle(
                color: Theme.of(context).colorScheme.surface, fontSize: 12),
          ),
        ),
        SizedBox(height: 12),
      ],
    );
  }
}
