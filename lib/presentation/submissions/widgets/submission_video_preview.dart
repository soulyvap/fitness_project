import 'dart:io';

import 'package:fitness_project/domain/entities/db/challenge.dart';
import 'package:fitness_project/domain/entities/db/exercise.dart';
import 'package:fitness_project/domain/entities/db/group.dart';
import 'package:fitness_project/domain/entities/db/user.dart';
import 'package:fitness_project/presentation/camera/widgets/challenge_short_info.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SubmissionVideoPreview extends StatefulWidget {
  final File videoFile;
  final ChallengeEntity challenge;
  final ExerciseEntity exercise;
  final GroupEntity group;
  final UserEntity author;

  const SubmissionVideoPreview({
    super.key,
    required this.videoFile,
    required this.challenge,
    required this.exercise,
    required this.group,
    required this.author,
  });

  @override
  State<SubmissionVideoPreview> createState() => _SubmissionVideoPreviewState();
}

class _SubmissionVideoPreviewState extends State<SubmissionVideoPreview> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((_) {
        _controller.setLooping(true);
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
        _controller.play();
      });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          width: double.infinity,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              _controller.value.isInitialized
                  ? Column(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              if (_controller.value.isPlaying) {
                                _controller.pause();
                              } else {
                                _controller.play();
                              }
                            });
                          },
                          child: AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller),
                          ),
                        ),
                        VideoProgressIndicator(
                          _controller,
                          allowScrubbing: true,
                          padding: const EdgeInsets.all(0),
                        )
                      ],
                    )
                  : const Center(child: CircularProgressIndicator()),
              AspectRatio(
                aspectRatio: 9 / 16,
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Container(
                        color: Colors.black.withOpacity(0.3),
                        padding:
                            const EdgeInsets.only(right: 8, bottom: 8, top: 8),
                        child: Row(
                          children: [
                            const BackButton(
                              color: Colors.white,
                            ),
                            const Text("Submit this attempt?",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                            const Spacer(),
                            ElevatedButton.icon(
                                icon: const Icon(Icons.upload),
                                onPressed: () {},
                                label: const Text("Submit"))
                          ],
                        ),
                      ),
                      const Spacer(),
                      Container(
                        color: Colors.black.withOpacity(0.3),
                        padding: const EdgeInsets.all(16),
                        child: ChallengeShortInfo(
                          challenge: widget.challenge,
                          exercise: widget.exercise,
                          group: widget.group,
                          author: widget.author,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
