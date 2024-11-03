import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_project/common/widgets/number_picker_field.dart';
import 'package:fitness_project/data/models/db/update_challenge_req.dart';
import 'package:fitness_project/domain/entities/db/exercise.dart';
import 'package:fitness_project/domain/entities/db/group.dart';
import 'package:fitness_project/domain/usecases/db/update_challenge.dart';
import 'package:fitness_project/presentation/challenge/pages/challenge_page.dart';
import 'package:fitness_project/presentation/navigation/bloc/new_challenge_form_cubit.dart';
import 'package:fitness_project/presentation/navigation/bloc/start_a_challenge_cubit.dart';
import 'package:fitness_project/presentation/navigation/widgets/custom_dropdown.dart';
import 'package:fitness_project/presentation/navigation/widgets/exercise_list_tile.dart';
import 'package:fitness_project/presentation/navigation/widgets/group_list_tile.dart';
import 'package:fitness_project/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StartAChallengeSheet extends StatefulWidget {
  const StartAChallengeSheet({super.key});

  @override
  State<StartAChallengeSheet> createState() => _StartAChallengeSheetState();
}

class _StartAChallengeSheetState extends State<StartAChallengeSheet> {
  bool isSubmitting = false;

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

  Future<void> onSubmit(UpdateChallengeReq req) async {
    if (req.groupId == null) {
      setState(() {
        errorMessage = "Please select a group";
      });
      return;
    }
    if (req.exerciseId == null) {
      setState(() {
        errorMessage = "Please select an exercise";
      });
      return;
    }
    if (req.reps == null) {
      setState(() {
        errorMessage = "Please enter reps";
      });
      return;
    }
    if (req.minutesToComplete == null) {
      setState(() {
        errorMessage = "Please enter minutes to complete";
      });
      return;
    }
    setState(() {
      isSubmitting = true;
    });
    try {
      final challengeUpload =
          await sl<UpdateChallengeUseCase>().call(params: req);
      challengeUpload.fold((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
          ),
        );
      }, (data) {
        Future.delayed(const Duration(seconds: 1));
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) {
              return ChallengePage(
                challengeId: data,
                showPoints: true,
              );
            }),
          );
        }
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
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
              create: (context) => NewChallengeFormCubit())
        ],
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 440 + MediaQuery.of(context).viewInsets.bottom,
          child: Builder(
            builder: (cubitContext) {
              final startAChallengeState =
                  cubitContext.watch<StartAChallengeCubit>().state;
              final newChallengeFormState =
                  cubitContext.watch<NewChallengeFormCubit>().state;
              if (startAChallengeState is StartAChallengeLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (startAChallengeState is StartAChallengeError) {
                return Center(
                  child: Text(startAChallengeState.errorMessage),
                );
              } else if (startAChallengeState is StartAChallengeLoaded) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      const Text("Start a challenge",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const Row(
                        children: [
                          Icon(Icons.warning, color: Colors.red),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            "Do not make the challenge too long to record\n(max 2-minute videos)",
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      CustomDropDown(
                        placeholder: const ListTile(
                          leading:
                              SizedBox(width: 40, child: Icon(Icons.group)),
                          trailing: Icon(Icons.arrow_drop_down),
                          title: Text("Select a group"),
                        ),
                        selected: selectedGroupTile(startAChallengeState.groups,
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
                                      final group =
                                          startAChallengeState.groups[index];
                                      return GroupListTile(
                                          group: group,
                                          onTap: () {
                                            cubitContext
                                                .read<NewChallengeFormCubit>()
                                                .onValuesChanged(
                                                    groupId: group.groupId);
                                            Navigator.pop(modalContext);
                                            resetError();
                                          },
                                          trailing: group.groupId ==
                                                  newChallengeFormState.groupId
                                              ? const Icon(Icons.check_circle,
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
                                    itemCount:
                                        startAChallengeState.exercises.length,
                                    itemBuilder: (context, index) {
                                      final exercise =
                                          startAChallengeState.exercises[index];
                                      return ExerciseListTile(
                                          exercise: exercise,
                                          onTap: () {
                                            cubitContext
                                                .read<NewChallengeFormCubit>()
                                                .onValuesChanged(
                                                    exerciseId:
                                                        exercise.exerciseId);
                                            Navigator.pop(modalContext);
                                            resetError();
                                          },
                                          trailing: exercise.exerciseId ==
                                                  newChallengeFormState
                                                      .exerciseId
                                              ? const Icon(Icons.check_circle,
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
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.numbers),
                                  labelText: "Reps",
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
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
                                value: newChallengeFormState.minutesToComplete,
                                onChanged: (value) {
                                  cubitContext
                                      .read<NewChallengeFormCubit>()
                                      .onValuesChanged(
                                        minutesToComplete: value,
                                      );
                                  resetError();
                                },
                                min: 30,
                                max: 60,
                                step: 5,
                              )),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextField(
                        maxLines: 2,
                        maxLength: 100,
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.description),
                            labelText: 'Extra instructions',
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
                            final exerciseName =
                                newChallengeFormState.exerciseId == null
                                    ? null
                                    : startAChallengeState.exercises
                                        .firstWhere((element) =>
                                            element.exerciseId ==
                                            newChallengeFormState.exerciseId)
                                        .name;
                            final req = UpdateChallengeReq(
                              userId: currentUserId,
                              groupId: newChallengeFormState.groupId,
                              exerciseId: newChallengeFormState.exerciseId,
                              title: newChallengeFormState.reps == null ||
                                      exerciseName == null
                                  ? null
                                  : "${newChallengeFormState.reps} $exerciseName",
                              reps: newChallengeFormState.reps,
                              minutesToComplete:
                                  newChallengeFormState.minutesToComplete,
                              extraInstructions:
                                  newChallengeFormState.instructions,
                              completedBy: [],
                            );
                            await onSubmit(req);
                          },
                          style: ButtonStyle(
                            backgroundColor: errorMessage == null
                                ? null
                                : const WidgetStatePropertyAll(Colors.red),
                            foregroundColor: errorMessage == null
                                ? null
                                : const WidgetStatePropertyAll(Colors.white),
                          ),
                          child: isSubmitting
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(),
                                )
                              : Text(errorMessage ?? "Start challenge"),
                        ),
                      )
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: Text("Unknown state"),
                );
              }
            },
          ),
        ));
  }
}
