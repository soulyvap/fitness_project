import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ChallengePreviewPlayerNetwork extends StatefulWidget {
  final String url;
  const ChallengePreviewPlayerNetwork({super.key, required this.url});

  @override
  State<ChallengePreviewPlayerNetwork> createState() =>
      _ChallengePreviewPlayerNetworkState();
}

class _ChallengePreviewPlayerNetworkState
    extends State<ChallengePreviewPlayerNetwork> {
  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..initialize().then((_) {
        setState(() {});
        controller.addListener(() {
          if (!controller.value.isPlaying && controller.value.isCompleted) {
            controller.seekTo(Duration.zero);
            setState(() {
              controller.pause();
            });
          }
        });
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          alignment: Alignment.center,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.black,
          ),
          child: AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: VideoPlayer(controller),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(right: 32),
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      if (controller.value.isPlaying) {
                        controller.pause();
                      } else {
                        controller.play();
                      }
                    });
                  },
                  icon: Icon(
                    controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  )),
              Expanded(
                child: VideoProgressIndicator(
                  controller,
                  allowScrubbing: true,
                  padding: const EdgeInsets.all(0),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
