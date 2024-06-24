import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  static const String routeName = 'video-play';

  const VideoPlayerScreen({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    _controller = VideoPlayerController.network(widget.videoUrl);

    await _controller.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _controller,
      aspectRatio: _controller.value.aspectRatio,
      autoPlay: true,
      looping: true,
    );
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video Player"),
      ),
      body: Center(
        child: _chewieController != null &&
                _chewieController!.videoPlayerController.value.isInitialized
            ? Chewie(
                controller: _chewieController!,
              )
            : CircularProgressIndicator(
                color: Colors.black,
              ),
      ),
    );
  }
}
