import 'package:flutter/material.dart';
import 'dart:async';

class SliderModel extends StatefulWidget {
  final List sliders;

  const SliderModel({Key? key, required this.sliders}) : super(key: key);

  @override
  State<SliderModel> createState() => _SliderModelState();
}

class _SliderModelState extends State<SliderModel> {
  late List _sliders;
  late PageController _pageController;
  late Timer _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _sliders = widget.sliders;
    _pageController = PageController();
    _timer = Timer.periodic(const Duration(seconds: 3), _autoScroll);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _autoScroll(Timer timer) {
    if (_pageController.hasClients) {
      if (_currentIndex >= _sliders.length - 1) {
        _currentIndex = 0;
      } else {
        _currentIndex++;
      }
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        controller: _pageController,
        itemCount: _sliders.length,
        itemBuilder: (context, index) {
          final slider = _sliders[index];
          return Image.network(
            slider['slider_image'],
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}
