import 'dart:io';

import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:camerawesome/pigeon.dart';
import 'package:fitness_project/domain/entities/db/challenge.dart';
import 'package:fitness_project/domain/entities/db/exercise.dart';
import 'package:fitness_project/domain/entities/db/group.dart';
import 'package:fitness_project/domain/entities/db/user.dart';
import 'package:fitness_project/presentation/camera/widgets/video_mode_ui.dart';
import 'package:fitness_project/presentation/submissions/widgets/submission_video_preview.dart';
import 'package:flutter/material.dart';

class Camera extends StatefulWidget {
  final ChallengeEntity challenge;
  final ExerciseEntity exercise;
  final GroupEntity group;
  final UserEntity author;

  const Camera(
      {super.key,
      required this.challenge,
      required this.exercise,
      required this.group,
      required this.author});

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  @override
  Widget build(BuildContext context) {
    return CameraAwesomeBuilder.custom(
        onMediaCaptureEvent: (event) {
          if (event.status == MediaCaptureStatus.success) {
            if (event.captureRequest.path != null) {
              final File videoFile = File(event.captureRequest.path!);
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => SubmissionVideoPreview(
                          videoFile: videoFile,
                          challenge: widget.challenge,
                          exercise: widget.exercise,
                          group: widget.group,
                          author: widget.author,
                        )),
              );
            }
          }
        },
        saveConfig: SaveConfig.video(
          mirrorFrontCamera: true,
          videoOptions: VideoOptions(
              enableAudio: true,
              quality: VideoRecordingQuality.hd,
              android: AndroidVideoOptions(
                  fallbackStrategy: QualityFallbackStrategy.lower)),
        ),
        sensorConfig: SensorConfig.single(
          aspectRatio: CameraAspectRatios.ratio_16_9,
          sensor: Sensor.position(SensorPosition.front),
        ),
        enablePhysicalButton: true,
        builder: (cameraState, preview) {
          return cameraState.when(
              onPreparingCamera: (state) =>
                  const Center(child: CircularProgressIndicator()),
              onVideoMode: (state) {
                return VideoModeUi(
                  challenge: widget.challenge,
                  exercise: widget.exercise,
                  group: widget.group,
                  author: widget.author,
                  cameraState: state,
                  isRecording: false,
                );
              },
              onVideoRecordingMode: (state) {
                return VideoModeUi(
                  challenge: widget.challenge,
                  exercise: widget.exercise,
                  group: widget.group,
                  author: widget.author,
                  cameraState: state,
                  isRecording: true,
                );
              });
        });
  }
}
