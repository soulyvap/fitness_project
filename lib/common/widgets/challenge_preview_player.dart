import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ChallengePreviewPlayer extends StatefulWidget {
  final File file;
  final Function()? removeFile;
  const ChallengePreviewPlayer(
      {super.key, required this.file, this.removeFile});

  @override
  State<ChallengePreviewPlayer> createState() => _ChallengePreviewPlayerState();
}

class _ChallengePreviewPlayerState extends State<ChallengePreviewPlayer> {
  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.file(widget.file)
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
        if (widget.removeFile != null)
          Positioned(
            top: 4,
            right: 4,
            child: IconButton(
              icon: const Card(
                  child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.delete, color: Colors.red),
              )),
              onPressed: widget.removeFile,
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
