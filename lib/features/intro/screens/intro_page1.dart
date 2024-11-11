import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class IntroPage1 extends StatefulWidget {
  @override
  _IntroPage1State createState() => _IntroPage1State();
}

class _IntroPage1State extends State<IntroPage1> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/intro_video1.mp4')
      ..setLooping(true) // Set the video to loop
      ..initialize().then((_) {
        setState(() {
          _controller.play(); // Start playing the video automatically
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose(); // Clean up the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Video Player
          _controller.value.isInitialized
              ? Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 5),
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.black,
                  ),
                  child: VideoPlayer(_controller),
                )
              : Container(
                  height: 200, // Placeholder height
                  child: Center(child: CircularProgressIndicator()),
                ),
          SizedBox(height: 16), // Spacing
          // Title
          Text(
            'Yoru Health, Your Way',
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 24,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8), // Spacing
          // Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Your complete health companion,\n'
              'in your pocket.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
