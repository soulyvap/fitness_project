import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_project/common/bloc/file_selection_cubit.dart';
import 'package:fitness_project/common/widgets/media_picker.dart';
import 'package:fitness_project/common/widgets/number_picker_field.dart';
import 'package:fitness_project/data/models/db/get_challenges_by_groups_req.dart';
import 'package:fitness_project/data/models/db/update_challenge_req.dart';
import 'package:fitness_project/data/models/storage/upload_file_req.dart';
import 'package:fitness_project/domain/entities/db/challenge.dart';
import 'package:fitness_project/domain/entities/db/exercise.dart';
import 'package:fitness_project/domain/entities/db/group.dart';
import 'package:fitness_project/domain/usecases/db/get_challenges_by_groups.dart';
import 'package:fitness_project/domain/usecases/db/update_challenge.dart';
import 'package:fitness_project/domain/usecases/storage/upload_file.dart';
import 'package:fitness_project/main.dart';
import 'package:fitness_project/presentation/challenge/pages/challenge_page.dart';
import 'package:fitness_project/common/bloc/new_challenge_form_cubit.dart';
import 'package:fitness_project/common/bloc/start_a_challenge_cubit.dart';
import 'package:fitness_project/presentation/navigation/widgets/custom_dropdown.dart';
import 'package:fitness_project/presentation/navigation/widgets/exercise_list_tile.dart';
import 'package:fitness_project/presentation/navigation/widgets/group_list_tile.dart';
import 'package:fitness_project/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';

class StartAChallengeSheet extends StatefulWidget {
  final GroupEntity? group;
  final Function()? onStartChallenge;
  const StartAChallengeSheet({super.key, this.group, this.onStartChallenge});

  @override
  State<StartAChallengeSheet> createState() => _StartAChallengeSheetState();
}

class _StartAChallengeSheetState extends State<StartAChallengeSheet> {
  bool isSubmitting = false;
  VideoPlayerController? _controller;

  String? errorMessage;
  void resetError() {
    setState(() {
      errorMessage = null;
    });
  }

  Widget? selectedGroupTile(List<GroupEntity> groups, String? selectedGroup) {
    if (selectedGroup == null) {
      return null;
    }
    try {
      final group =
          groups.firstWhere((element) => element.groupId == selectedGroup);
      return GroupListTile(
        group: group,
        trailing: const Icon(Icons.check_circle, color: Colors.green),
      );
    } catch (e) {
      return null;
    }
  }

  Widget? selectedExerciseTile(
      List<ExerciseEntity> exercises, String? selectedExercise) {
    if (selectedExercise == null) {
      return null;
    }
    try {
      final exercise = exercises
          .firstWhere((element) => element.exerciseId == selectedExercise);
      return ExerciseListTile(
        exercise: exercise,
        trailing: const Icon(Icons.check_circle, color: Colors.green),
      );
    } catch (e) {
      return null;
    }
  }

  Future<bool> hasRunningChallenge(String groupId) async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) {
      return false;
    }
    final challenge = await sl<GetChallengesByGroupsUseCase>()
        .call(params: GetChallengesByGroupsReq(groupIds: [groupId]));
    return challenge.fold((error) {
      return false;
    }, (data) {
      if (data == null) {
        return false;
      }
      final activeChallengesInGroup = data as List<ChallengeEntity>;
      return activeChallengesInGroup
          .any((element) => element.userId == currentUserId);
    });
  }

  Future<File?> compressVideo(File videoFile) async {
    final compressedVideo = await VideoCompress.compressVideo(
      videoFile.path,
      quality: VideoQuality.Res960x540Quality,
      deleteOrigin: true,
      frameRate: 24,
    );
    if (compressedVideo == null) {
      return null;
    }
    videoFile.delete();
    return compressedVideo.file;
  }

  Future<void> uploadVideo(String challengeId, File file) async {
    final compressed = await compressVideo(file);

    if (compressed == null) {
      return;
    }

    final upload = await sl<UploadFileUseCase>().call(
        params: UploadFileReq(
            path: "videos/challenges/$challengeId/demo/$challengeId.mp4",
            file: compressed));
    try {
      upload.fold((error) {
        return null;
      }, (data) async {
        await sl<UpdateChallengeUseCase>().call(
            params:
                UpdateChallengeReq(challengeId: challengeId, videoUrl: data));
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> onSubmit(NewChallengeFormState state,
      List<ExerciseEntity> exercises, XFile? demoVideo) async {
    if (state.groupId == null) {
      setState(() {
        errorMessage = "Please select a group";
      });
      return;
    }
    if (state.exerciseId == null) {
      setState(() {
        errorMessage = "Please select an exercise";
      });
      return;
    }
    final invalidCustomName = state.customExerciseName == null ||
        state.customExerciseName!.isEmpty ||
        state.customExerciseName!.length > 14;
    if (state.exerciseId == "custom" && invalidCustomName) {
      setState(() {
        errorMessage =
            "Please enter a custom exercise name shorter than 15 characters";
      });
      return;
    }
    if (state.reps == null) {
      setState(() {
        errorMessage = "Please enter reps";
      });
      return;
    }
    if (state.minutesToComplete == null) {
      setState(() {
        errorMessage = "Please enter minutes to complete";
      });
      return;
    }
    final hasRunning = await hasRunningChallenge(state.groupId!);
    if (hasRunning) {
      setState(() {
        errorMessage = "You already have an ongoing challenge in this group";
      });
      return;
    }
    setState(() {
      isSubmitting = true;
    });
    final exerciseName = state.exerciseId == "custom"
        ? state.customExerciseName
        : exercises
            .firstWhere((element) => element.exerciseId == state.exerciseId)
            .name;
    final req = UpdateChallengeReq(
      userId: FirebaseAuth.instance.currentUser?.uid,
      groupId: state.groupId,
      exerciseId: state.exerciseId,
      title: "${state.reps} $exerciseName",
      reps: state.reps,
      minutesToComplete: state.minutesToComplete,
      extraInstructions: state.instructions,
      completedBy: [],
    );
    try {
      final challengeUpload =
          await sl<UpdateChallengeUseCase>().call(params: req);
      challengeUpload.fold((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
          ),
        );
      }, (data) async {
        if (demoVideo == null) {
          Future.delayed(const Duration(seconds: 1));
        }
        widget.onStartChallenge?.call();
        if (demoVideo != null) {
          await uploadVideo(data, File(demoVideo.path));
        }
        navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(builder: (context) {
            return ChallengePage(
              challengeId: data,
              showPoints: true,
            );
          }),
        );
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) {
      return const Center(
        child: Text("User not found"),
      );
    }

    return MultiBlocProvider(
        providers: [
          BlocProvider<StartAChallengeCubit>(
            create: (context) => StartAChallengeCubit(currentUserId),
          ),
          BlocProvider<NewChallengeFormCubit>(
              create: (context) =>
                  NewChallengeFormCubit(groupId: widget.group?.groupId)),
          BlocProvider(
              create: (context) => FileSelectionCubit(
                  type: FileType.video,
                  maxDuration: const Duration(minutes: 1))),
        ],
        child: PopScope(
          canPop: !isSubmitting,
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Builder(
              builder: (cubitContext) {
                final startAChallengeState =
                    cubitContext.watch<StartAChallengeCubit>().state;
                final newChallengeFormState =
                    cubitContext.watch<NewChallengeFormCubit>().state;
                final fileState =
                    cubitContext.watch<FileSelectionCubit>().state;
                if (fileState != null && _controller == null) {
                  _controller = VideoPlayerController.file(File(fileState.path))
                    ..initialize().then((_) {
                      setState(() {});
                    });
                }
                if (startAChallengeState is StartAChallengeLoading) {
                  return const SizedBox(
                    height: 200,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (startAChallengeState is StartAChallengeError) {
                  return SizedBox(
                    height: 200,
                    child: Center(
                      child: Text(startAChallengeState.errorMessage),
                    ),
                  );
                } else if (startAChallengeState is StartAChallengeLoaded) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.close,
                                      color: Colors.transparent)),
                              const Text("Start a challenge",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(Icons.close)),
                            ],
                          ),
                          const ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.only(left: 4, right: 16),
                            leading: Icon(
                              Icons.info,
                              color: Colors.red,
                            ),
                            title: Text("Keep it short and fun!"),
                            subtitle: Text(
                                "The challenge should take less than 2 minutes to complete"),
                            minVerticalPadding: 0,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          CustomDropDown(
                            placeholder: const ListTile(
                              dense: true,
                              contentPadding:
                                  EdgeInsets.only(left: 4, right: 16),
                              leading:
                                  SizedBox(width: 40, child: Icon(Icons.group)),
                              trailing: Icon(Icons.arrow_drop_down),
                              title: Text("Select a group"),
                            ),
                            selected: selectedGroupTile(
                                startAChallengeState.groups,
                                newChallengeFormState.groupId),
                            modalBuilder: (modalContext) {
                              return Container(
                                color: Colors.white,
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    const Text(
                                      "Select a group",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 360,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount:
                                            startAChallengeState.groups.length,
                                        itemBuilder: (context, index) {
                                          final group = startAChallengeState
                                              .groups[index];
                                          return GroupListTile(
                                              group: group,
                                              onTap: () {
                                                cubitContext
                                                    .read<
                                                        NewChallengeFormCubit>()
                                                    .onValuesChanged(
                                                        groupId: group.groupId);
                                                Navigator.pop(modalContext);
                                                resetError();
                                              },
                                              trailing: group.groupId ==
                                                      newChallengeFormState
                                                          .groupId
                                                  ? const Icon(
                                                      Icons.check_circle,
                                                      color: Colors.green)
                                                  : null);
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(modalContext);
                                        },
                                        child: const Text("Close"),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          CustomDropDown(
                            placeholder: const ListTile(
                              dense: true,
                              contentPadding:
                                  EdgeInsets.only(left: 4, right: 16),
                              leading: SizedBox(
                                  width: 40, child: Icon(Icons.fitness_center)),
                              trailing: Icon(Icons.arrow_drop_down),
                              title: Text("Select an exercise"),
                            ),
                            selected: selectedExerciseTile(
                                startAChallengeState.exercises,
                                newChallengeFormState.exerciseId),
                            modalBuilder: (modalContext) {
                              return Container(
                                color: Colors.white,
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    const Text(
                                      "Select an exercise",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 360,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: startAChallengeState
                                            .exercises.length,
                                        itemBuilder: (context, index) {
                                          final exercise = startAChallengeState
                                              .exercises[index];
                                          return ExerciseListTile(
                                              exercise: exercise,
                                              onTap: () {
                                                cubitContext
                                                    .read<
                                                        NewChallengeFormCubit>()
                                                    .onValuesChanged(
                                                        exerciseId: exercise
                                                            .exerciseId);
                                                Navigator.pop(modalContext);
                                                resetError();
                                              },
                                              trailing: exercise.exerciseId ==
                                                      newChallengeFormState
                                                          .exerciseId
                                                  ? const Icon(
                                                      Icons.check_circle,
                                                      color: Colors.green)
                                                  : null);
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(modalContext);
                                        },
                                        child: const Text("Close"),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          if (newChallengeFormState.exerciseId == "custom")
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: TextField(
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                                decoration: const InputDecoration(
                                    prefixIconConstraints: BoxConstraints(
                                      minWidth: 60,
                                    ),
                                    hintText: "e.g. sit-ups, pull-ups, etc.",
                                    prefixIcon: Icon(Icons.fitness_center),
                                    labelText: "Custom exercise name",
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                    )),
                                onChanged: (value) {
                                  cubitContext
                                      .read<NewChallengeFormCubit>()
                                      .onValuesChanged(
                                        customExerciseName: value,
                                      );
                                  resetError();
                                },
                                textInputAction: TextInputAction.next,
                              ),
                            ),
                          AspectRatio(
                            aspectRatio: fileState == null ? 3 : 1.3,
                            child: MediaPicker(
                                placeholder: const ListTile(
                                  dense: true,
                                  leading: Icon(Icons.video_call),
                                  title: Text(
                                      "Upload a video that shows the move"),
                                  subtitle: Text(
                                      "- e.g. One rep of the move\n- Max 1 minute long"),
                                  trailing: Icon(Icons.arrow_right),
                                ),
                                file: fileState,
                                borderRadius: const Radius.circular(8),
                                pickFrom: (source) => cubitContext
                                    .read<FileSelectionCubit>()
                                    .pickFrom(source),
                                removeFile: cubitContext
                                    .read<FileSelectionCubit>()
                                    .clear),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  decoration: const InputDecoration(
                                      prefixIcon: Icon(Icons.numbers),
                                      labelText: "Reps",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                      )),
                                  onChanged: (value) {
                                    cubitContext
                                        .read<NewChallengeFormCubit>()
                                        .onValuesChanged(
                                          reps: int.tryParse(value),
                                        );
                                    resetError();
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter
                                        .digitsOnly, // Allows only digits
                                    FilteringTextInputFormatter.allow(RegExp(
                                        r'^[1-9][0-9]*')), // No leading zero, only positive integers
                                  ],
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                  flex: 2,
                                  child: NumberPickerField(
                                    leading: const Icon(Icons.timer),
                                    label: "Challenge expires in",
                                    unit: "minutes",
                                    value:
                                        newChallengeFormState.minutesToComplete,
                                    onChanged: (value) {
                                      cubitContext
                                          .read<NewChallengeFormCubit>()
                                          .onValuesChanged(
                                            minutesToComplete: value,
                                          );
                                      resetError();
                                    },
                                    min: 30,
                                    max: 120,
                                    step: 5,
                                  )),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          TextField(
                            maxLines: 2,
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(8),
                                prefixIcon: Icon(Icons.description),
                                labelText: 'Extra instructions (optional)',
                                hintText: 'e.g. No rest between reps',
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                )),
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                            onChanged: (value) {
                              cubitContext
                                  .read<NewChallengeFormCubit>()
                                  .onValuesChanged(
                                    instructions: value,
                                  );
                            },
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                await onSubmit(newChallengeFormState,
                                    startAChallengeState.exercises, fileState);
                              },
                              style: ButtonStyle(
                                backgroundColor: errorMessage == null
                                    ? null
                                    : const WidgetStatePropertyAll(Colors.red),
                                foregroundColor: errorMessage == null
                                    ? null
                                    : const WidgetStatePropertyAll(
                                        Colors.white),
                              ),
                              child: isSubmitting
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(),
                                    )
                                  : Text(errorMessage ?? "Start challenge"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return const Center(
                    child: Text("Unknown state"),
                  );
                }
              },
            ),
          ),
        ));
  }
}
