import 'dart:async';
import 'package:flutter/material.dart';
import 'package:onlinedawai/features/auth/screens/login_screen.dart';
import 'package:onlinedawai/features/intro/screens/intro_page1.dart';
import 'package:onlinedawai/features/intro/screens/intro_page2.dart';
import 'package:onlinedawai/features/intro/screens/intro_page3.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _controller;
  late Timer _timer;
  int _currentPage = 0;
  final int _totalPages = 3;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_currentPage < _totalPages - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _controller.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingComplete', true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [IntroPage1(), IntroPage2(), IntroPage3()],
          ),
          Container(
            alignment: Alignment(0, 0.9),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SmoothPageIndicator(
                  controller: _controller,
                  count: _totalPages,
                  effect: WormEffect(
                    dotWidth: 5,
                    dotHeight: 5,
                    activeDotColor: Colors.black,
                    dotColor: Colors.grey,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _completeOnboarding,
                  style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                    textStyle: TextStyle(fontSize: 18),
                    backgroundColor: Colors.red[400],
                  ),
                  child: Text(
                    'Get Started',
                    style: TextStyle(
                        color: Colors.white), // Ensure text is visible
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
