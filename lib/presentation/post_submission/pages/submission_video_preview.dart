import 'dart:io';

import 'package:fitness_project/domain/entities/db/challenge.dart';
import 'package:fitness_project/domain/entities/db/exercise.dart';
import 'package:fitness_project/domain/entities/db/group.dart';
import 'package:fitness_project/domain/entities/db/user.dart';
import 'package:fitness_project/presentation/post_submission/pages/camera.dart';
import 'package:fitness_project/presentation/post_submission/widgets/challenge_short_info.dart';
import 'package:fitness_project/presentation/post_submission/widgets/upload_modal_content.dart';
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
  // RangeValues _rangeValues = const RangeValues(0, 1000);
  // late Duration customStart;
  // late Duration customEnd;
  bool uploadingVideo = false;

  // void cropListener() {
  //   final Duration actualEnd = customEnd - const Duration(milliseconds: 500);
  //   if (_controller.value.position >= actualEnd) {
  //     _controller.seekTo(customStart);
  //     _controller.play();
  //   }
  // }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((_) {
        // customStart = Duration.zero;
        // customEnd = _controller.value.duration;
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
        _controller.setLooping(true);
        _controller.play();
      });
    // _controller.addListener(cropListener);
  }

  Duration sliderValueToDuration(double value) {
    final double duration =
        _controller.value.duration.inMilliseconds.toDouble();
    final double time = value * duration / 1000;
    return Duration(milliseconds: time.toInt());
  }

  @override
  void dispose() {
    // _controller.removeListener(cropListener);
    _controller.dispose();
    widget.videoFile.delete();
    super.dispose();
  }

  void _handlePop() {
    _controller.dispose();
    widget.videoFile.delete();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => Camera(
                  challenge: widget.challenge,
                  exercise: widget.exercise,
                  group: widget.group,
                  author: widget.author,
                )),
        (route) => route is Camera);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        _handlePop();
      },
      child: Material(
        color: Colors.black,
        child: Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            width: double.infinity,
            child: Column(
              children: [
                Stack(
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
                                  aspectRatio: 9 / 16,
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
                        : const AspectRatio(
                            aspectRatio: 9 / 16,
                            child: Center(child: CircularProgressIndicator())),
                    AspectRatio(
                      aspectRatio: 9 / 16,
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          children: [
                            Container(
                              color: Colors.black.withOpacity(0.3),
                              padding: const EdgeInsets.only(
                                  right: 8, bottom: 8, top: 8),
                              child: Row(
                                children: [
                                  BackButton(
                                    color: Colors.white,
                                    onPressed: () {
                                      _handlePop();
                                    },
                                  ),
                                  const Text("Submit this attempt?",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  const Spacer(),
                                  ElevatedButton.icon(
                                      icon: const Icon(Icons.upload),
                                      onPressed: () {
                                        showModalBottomSheet(
                                            enableDrag: false,
                                            isDismissible: false,
                                            context: context,
                                            builder: (context) {
                                              return PopScope(
                                                canPop: false,
                                                child: UploadModalContent(
                                                  challengeId: widget
                                                      .challenge.challengeId,
                                                  videoFile: widget.videoFile,
                                                  groupId: widget.group.groupId,
                                                ),
                                              );
                                            });
                                      },
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
                    ),
                  ],
                ),
                // RangeSlider(
                //   values: _rangeValues,
                //   onChanged: (values) {
                //     setState(() {
                //       _rangeValues = values;
                //     });
                //     _controller.seekTo(sliderValueToDuration(values.start));
                //   },
                //   onChangeStart: (values) {
                //     _controller.pause();
                //   },
                //   onChangeEnd: (values) {
                //     final startDuration = sliderValueToDuration(values.start);
                //     final endDuration = sliderValueToDuration(values.end);
                //     setState(() {
                //       customStart = startDuration;
                //       customEnd = endDuration;
                //     });
                //     _controller.play();
                //   },
                //   min: 0,
                //   max: 1000,
                // ),
              ],
            )),
      ),
    );
  }
}
