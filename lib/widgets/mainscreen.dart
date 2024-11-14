import 'package:flutter/material.dart';
import 'package:onlinedawai/features/auth/screens/auth_wrapper.dart';
import 'package:onlinedawai/utils/token_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:onlinedawai/features/onboarding/screens/onboarding_screen.dart';
import 'package:onlinedawai/features/auth/screens/login_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _isOnboardingComplete = false;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkOnboardingAndLoginStatus();
  }

  Future<void> _checkOnboardingAndLoginStatus() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool isLoggedIn = await TokenStorage.hasToken();
    setState(() {
      _isOnboardingComplete = pref.getBool('onboardingComplete') ?? false;
      _isLoggedIn = isLoggedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoggedIn) {
      return AuthWrapper(); // show the navbar screen if logged in
    } else if (_isOnboardingComplete) {
      return LoginScreen(); // Show the login screen if onboarding is complete but not logged in
    } else {
      return OnboardingScreen(); // Show the onboarding screen if not completed
    }
  }
}
