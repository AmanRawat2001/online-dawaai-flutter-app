import 'package:flutter/material.dart';
import 'package:onlinedawai/features/auth/screens/login_screen.dart';
import 'package:onlinedawai/utils/token_storage.dart';
import 'package:onlinedawai/widgets/bottom_navbar.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoggedIn = false;
  String token = '';

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoggedIn
        ? BottomNavBar(token: token)
        : const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
  }

  Future<void> _checkToken() async {
    String? storedToken = await TokenStorage.getToken();
    if (storedToken != null) {
      setState(() {
        _isLoggedIn = true;
        token = storedToken;
      });
    } else {
      _navigateToLogin();
    }
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}
