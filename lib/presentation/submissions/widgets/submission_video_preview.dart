import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_project/data/db/models/update_submission_req.dart';
import 'package:fitness_project/data/storage/models/upload_file_req.dart';
import 'package:fitness_project/domain/entities/db/challenge.dart';
import 'package:fitness_project/domain/entities/db/exercise.dart';
import 'package:fitness_project/domain/entities/db/group.dart';
import 'package:fitness_project/domain/entities/db/user.dart';
import 'package:fitness_project/domain/usecases/db/update_submission.dart';
import 'package:fitness_project/domain/usecases/storage/upload_file.dart';
import 'package:fitness_project/presentation/camera/widgets/challenge_short_info.dart';
import 'package:fitness_project/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:video_compress/video_compress.dart';
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
  RangeValues _rangeValues = RangeValues(0, 100);
  late Duration customStart;
  late Duration customEnd;

  Future<void> _onSubmit() async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    MediaInfo? mediaInfo = await VideoCompress.compressVideo(
      widget.videoFile.path,
      quality: VideoQuality.Res1280x720Quality,
      deleteOrigin: true,
      startTime: customStart.inSeconds,
      duration: customEnd.inSeconds - customStart.inSeconds,
    );
    if (mediaInfo != null && mediaInfo.file != null) {
      final videoThumbnail = await VideoCompress.getFileThumbnail(
        mediaInfo.path!,
        quality: 100,
        position: 0,
      );
      final addSubmission = await sl<UpdateSubmissionUseCase>().call(
        params: UpdateSubmissionReq(
          challengeId: widget.challenge.challengeId,
          userId: currentUserId,
        ),
      );
      addSubmission.fold((l) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to submit attempt: ${l.toString()}"),
          ),
        );
      }, (r) async {
        final submissionId = r;
        final videoUpload = await _uploadVideo(mediaInfo.file!, submissionId);
        final thumbnailUpload =
            await _uploadThumbnail(videoThumbnail, submissionId);
        if (videoUpload != null && thumbnailUpload != null) {
          final updateSubmission = await sl<UpdateSubmissionUseCase>().call(
            params: UpdateSubmissionReq(
              submissionId: submissionId,
              videoUrl: videoUpload,
              thumbnailUrl: thumbnailUpload,
            ),
          );
          updateSubmission.fold((l) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Failed to submit attempt: ${l.toString()}"),
              ),
            );
          }, (r) {
            // TODO: Navigate to something
          });
        }
      });
    }
  }

  Future<String?> _uploadVideo(File file, String submissionId) async {
    final videoUpload = await sl<UploadFileUseCase>().call(
      params: UploadFileReq(
          path:
              "videos/challenges/${widget.challenge.challengeId}/submissions/$submissionId/$submissionId.mp4",
          file: file),
    );
    String? returnValue = "";
    videoUpload.fold((l) {
      returnValue = null;
    }, (r) {
      returnValue = r;
    });
    return returnValue;
  }

  Future<String?> _uploadThumbnail(File file, String submissionId) async {
    final thumbnailUpload = await sl<UploadFileUseCase>().call(
        params: UploadFileReq(
      path:
          "videos/challenges/${widget.challenge.challengeId}/submissions/$submissionId/$submissionId.jpg",
      file: file,
    ));
    String? returnValue = "";
    thumbnailUpload.fold((l) {
      returnValue = null;
    }, (r) {
      returnValue = r;
    });
    return returnValue;
  }

  void playerListener(Duration start, Duration end) {
    final Duration actualEnd = end - const Duration(milliseconds: 300);
    if (_controller.value.position >= actualEnd) {
      _controller.seekTo(start);
      _controller.play();
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((_) {
        customStart = Duration.zero;
        customEnd = _controller.value.duration;
        _controller.setLooping(true);
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
        _controller.play();
      });
  }

  Duration sliderValueToDuration(double value) {
    final double duration =
        _controller.value.duration.inMilliseconds.toDouble();
    final double time = value * duration / 100;
    return Duration(milliseconds: time.toInt());
  }

  void cropVideo(RangeValues values) {
    final double start = values.start;
    final double end = values.end;
    final double duration =
        _controller.value.duration.inMilliseconds.toDouble();
    final double startTime = start * duration / 100;
    final double endTime = end * duration / 100;
    _controller.removeListener(() => playerListener(customStart, customEnd));
    final startDuration = Duration(milliseconds: startTime.toInt());
    final endDuration = Duration(milliseconds: endTime.toInt());
    setState(() {
      customStart = startDuration;
      customEnd = endDuration;
    });
    _controller.addListener(() => playerListener(startDuration, endDuration));
    _controller.seekTo(startDuration);
    _controller.play();
  }

  @override
  void dispose() {
    _controller.removeListener(() => playerListener(customStart, customEnd));
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
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
                      : const Center(child: CircularProgressIndicator()),
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
                                    onPressed: () {
                                      _onSubmit();
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
              RangeSlider(
                values: _rangeValues,
                onChanged: (values) {
                  setState(() {
                    _rangeValues = values;
                  });
                  _controller.seekTo(sliderValueToDuration(values.start));
                },
                onChangeStart: (values) {
                  _controller.pause();
                  _controller.removeListener(
                      () => playerListener(customStart, customEnd));
                },
                onChangeEnd: (values) {
                  final startDuration = sliderValueToDuration(values.start);
                  final endDuration = sliderValueToDuration(values.end);
                  _controller.addListener(
                      () => playerListener(startDuration, endDuration));
                  setState(() {
                    customStart = startDuration;
                    customEnd = endDuration;
                  });
                  _controller.play();
                },
                min: 0,
                max: 100,
              )
            ],
          )),
    );
  }
}
