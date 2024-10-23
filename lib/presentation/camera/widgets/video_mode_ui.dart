// Credits to camerawesome plugin for the AwesomeCaptureButton widget

import 'dart:async';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:fitness_project/common/extensions/int_extension.dart';
import 'package:fitness_project/common/widgets/countdown.dart';
import 'package:fitness_project/domain/entities/db/challenge.dart';
import 'package:fitness_project/domain/entities/db/exercise.dart';
import 'package:fitness_project/domain/entities/db/group.dart';
import 'package:fitness_project/domain/entities/db/user.dart';
import 'package:fitness_project/presentation/camera/widgets/capture_button.dart';
import 'package:fitness_project/presentation/camera/widgets/challenge_short_info.dart';
import 'package:flutter/material.dart';

class VideoModeUi extends StatefulWidget {
  final ChallengeEntity challenge;
  final ExerciseEntity exercise;
  final GroupEntity group;
  final UserEntity author;
  final CameraState cameraState;
  final bool isRecording;
  final int maxSeconds;
  final int recordingDelay;

  const VideoModeUi(
      {super.key,
      required this.challenge,
      required this.exercise,
      required this.group,
      required this.author,
      required this.cameraState,
      required this.isRecording,
      this.maxSeconds = 120,
      this.recordingDelay = 10});

  @override
  State<VideoModeUi> createState() => _VideoModeUiState();
}

class _VideoModeUiState extends State<VideoModeUi> {
  late int _secondsLeft;
  late int _recordingCountdown;
  late Timer _recordingTimer;
  late Timer _recordingDelayTimer;
  bool recordingCountdownStarted = false;

  void startRecordingTimer() {
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 0) {
        if (widget.cameraState is VideoRecordingCameraState) {
          (widget.cameraState as VideoRecordingCameraState).stopRecording();
        }
        timer.cancel();
        return;
      }
      setState(() {
        _secondsLeft = _secondsLeft - 1;
      });
    });
  }

  void startRecordingDelayTimer() {
    setState(() {
      recordingCountdownStarted = true;
    });
    _recordingDelayTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_recordingCountdown == 1) {
        if (widget.cameraState is VideoCameraState) {
          (widget.cameraState as VideoCameraState).startRecording();
        }
        resetDelay();
        return;
      }
      setState(() {
        _recordingCountdown = _recordingCountdown - 1;
      });
    });
  }

  void resetDelay() {
    _recordingDelayTimer.cancel();
    setState(() {
      recordingCountdownStarted = false;
      _recordingCountdown = widget.recordingDelay;
    });
  }

  @override
  void initState() {
    _secondsLeft = widget.maxSeconds;
    _recordingCountdown = widget.recordingDelay;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant VideoModeUi oldWidget) {
    if (!oldWidget.isRecording && widget.isRecording) {
      _secondsLeft = widget.maxSeconds;
      startRecordingTimer();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.cameraState.dispose();
    if (_recordingDelayTimer.isActive) {
      _recordingDelayTimer.cancel();
    }
    if (_recordingTimer.isActive) {
      _recordingTimer.cancel();
    }
    resetDelay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top, bottom: 8),
          color: Colors.black.withOpacity(0.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BackButton(
                color: Colors.white,
              ),
              Countdown(
                  secondsLeft: widget.challenge.endsAt
                      .difference(DateTime.now())
                      .inSeconds),
              const SizedBox(
                width: 46,
              )
            ],
          ),
        ),
        const Spacer(),
        Opacity(
          opacity: recordingCountdownStarted ? 1 : 0,
          child: Card(
            color: Colors.black.withOpacity(0.3),
            child: SizedBox(
              width: 300,
              height: 300,
              child: Center(
                child: Text(
                  _recordingCountdown.toString(),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 200,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
        const Spacer(),
        Container(
          color: Colors.black.withOpacity(0.5),
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          child: Column(
            children: [
              widget.isRecording
                  ? Material(
                      color: Colors.transparent,
                      child: Text(
                        _secondsLeft.secondsToTimeString(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  : ChallengeShortInfo(
                      challenge: widget.challenge,
                      exercise: widget.exercise,
                      group: widget.group,
                      author: widget.author,
                    ),
              CaptureButton(
                state: widget.cameraState,
                onTap: () {
                  widget.cameraState.when(
                    onVideoMode: (videoState) {
                      if (recordingCountdownStarted) {
                        resetDelay();
                        return;
                      }
                      startRecordingDelayTimer();
                    },
                    onVideoRecordingMode: (videoState) {
                      videoState.stopRecording();
                    },
                  );
                },
              )
            ],
          ),
        )
      ],
    );
  }
}
