import 'dart:async';
import 'package:flutter/material.dart';

class BannerModel extends StatefulWidget {
  final List banners;
  const BannerModel({super.key, required this.banners});
  @override
  State<BannerModel> createState() => _BannerModelState();
}

class _BannerModelState extends State<BannerModel> {
  late List _banners;
  late ScrollController _scrollController;
  late Timer _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _banners = widget.banners;
    _scrollController = ScrollController();
    _timer = Timer.periodic(Duration(seconds: 3), _autoScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _autoScroll(Timer timer) {
    if (_scrollController.hasClients) {
      if (_currentIndex >= _banners.length - 1) {
        _currentIndex = 0;
      } else {
        _currentIndex++;
      }

      _scrollController.animateTo(
        _currentIndex * 150.0,
        duration: Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: _banners.length,
        itemBuilder: (context, index) {
          final banner = _banners[index];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.black,
                  width: 0.3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 3,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  banner['brand_image'],
                  width: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
