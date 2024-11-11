import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class IntroPage3 extends StatefulWidget {
  @override
  _IntroPage3State createState() => _IntroPage3State();
}

class _IntroPage3State extends State<IntroPage3> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/intro_video3.mp4')
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
            'Consult doctor at home',
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
              'Consult our qualified  doctor from anywhere ,anytime.\n'
              'We Guarantee your privacy.',
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
