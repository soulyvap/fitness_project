import 'package:fitness_project/presentation/challenge/bloc/submission_loader_cubit.dart';
import 'package:fitness_project/presentation/view_submissions/pages/video_scroller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubmissionLoader extends StatelessWidget {
  final String challengeId;
  final bool reviewing;
  const SubmissionLoader(
      {super.key, required this.challengeId, this.reviewing = false});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SubmissionLoaderCubit>(
      create: (context) => SubmissionLoaderCubit(challengeId: challengeId),
      child: BlocBuilder<SubmissionLoaderCubit, SubmissionLoaderState>(
        builder: (context, state) {
          if (state is SubmissionLoaderLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SubmissionLoaderLoaded) {
            return VideoScroller(
              submissions: state.submissions,
              reviewing: reviewing,
            );
          } else if (state is SubmissionLoaderError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('Unknown state'));
          }
        },
      ),
    );
  }
}
