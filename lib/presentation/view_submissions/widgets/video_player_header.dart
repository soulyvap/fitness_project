import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_project/common/widgets/user_tile_small.dart';
import 'package:fitness_project/domain/usecases/db/delete_submission.dart';
import 'package:fitness_project/main.dart';
import 'package:fitness_project/presentation/challenge/pages/challenge_page.dart';
import 'package:fitness_project/presentation/view_submissions/bloc/video_info_cubit.dart';
import 'package:fitness_project/service_locator.dart';
import 'package:flutter/material.dart';

class VideoPlayerHeader extends StatelessWidget {
  final VideoInfoState videoInfoState;
  const VideoPlayerHeader({super.key, required this.videoInfoState});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.2),
      padding: const EdgeInsets.only(right: 8, bottom: 8, top: 8),
      child: Row(
        children: [
          const BackButton(
            color: Colors.white,
          ),
          Expanded(
            child: Builder(builder: (playerContext) {
              if (videoInfoState is VideoInfoLoaded) {
                final state = videoInfoState as VideoInfoLoaded;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(playerContext).push(MaterialPageRoute(
                                builder: (context) => ChallengePage(
                                    challengeId:
                                        state.data.challenge.challengeId)));
                          },
                          child: Text(
                              "${state.data.challenge.reps} ${state.data.exercise.name}",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              )),
                        ),
                        UserTileSmall(
                            user: state.data.doer,
                            textColor: Colors.white,
                            leadingText: "Posted by"),
                      ],
                    ),
                    IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                              context: playerContext,
                              builder: (context) {
                                return Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Card(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // if (state.data.challenge.endsAt
                                        //     .isAfter(DateTime.now()))
                                        ListTile(
                                          leading: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          title: const Text(
                                              "Delete your submission"),
                                          onTap: () {
                                            showModalBottomSheet(
                                                context: context,
                                                builder: (context) {
                                                  return Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                          "Delete your submission?",
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        const Text(
                                                            "Your points for this submission will be lost."),
                                                        const SizedBox(
                                                          height: 16,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            Expanded(
                                                              child:
                                                                  OutlinedButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      child: const Text(
                                                                          "Cancel")),
                                                            ),
                                                            const SizedBox(
                                                              width: 16,
                                                            ),
                                                            Expanded(
                                                              child:
                                                                  ElevatedButton(
                                                                      onPressed:
                                                                          () async {
                                                                        await sl<DeleteSubmissionUseCase>().call(
                                                                            params:
                                                                                state.data.submission.submissionId);
                                                                        navigatorKey
                                                                            .currentState
                                                                            ?.pop();
                                                                        navigatorKey
                                                                            .currentState
                                                                            ?.pop();
                                                                        navigatorKey
                                                                            .currentState
                                                                            ?.pop();
                                                                      },
                                                                      child: const Text(
                                                                          "Delete")),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                        icon: const Icon(Icons.more_vert, color: Colors.white)),
                  ],
                );
              } else {
                return const SizedBox();
              }
            }),
          ),
        ],
      ),
    );
  }
}
