import 'package:fitness_project/domain/entities/db/submission.dart';
import 'package:fitness_project/presentation/view_submissions/widgets/vertical_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MyPost extends StatefulWidget {
  final SubmissionEntity submission;
  const MyPost({super.key, required this.submission});

  @override
  State<MyPost> createState() => _MyPostState();
}

class _MyPostState extends State<MyPost> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    _controller =
        VideoPlayerController.networkUrl(Uri.parse(widget.submission.videoUrl))
          ..initialize().then((_) {
            setState(() {});
            _controller.setLooping(true);
            _controller.play();
          });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VerticalVideoPlayer(
        controller: _controller, submission: widget.submission);
  }
}
