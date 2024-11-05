import 'package:fitness_project/common/widgets/user_tile_small.dart';
import 'package:fitness_project/presentation/view_submissions/bloc/seen_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SeenButton extends StatelessWidget {
  final String submissionId;
  final List<String> currentSeen;
  final Function(List<String>)? onSeenLoaded;
  const SeenButton(
      {super.key,
      required this.submissionId,
      this.onSeenLoaded,
      required this.currentSeen});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return BlocProvider<SeenCubit>(
                  create: (context) =>
                      SeenCubit(submissionId: submissionId, loadOnInit: true),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    height: 300,
                    child: BlocConsumer<SeenCubit, SeenState>(
                        listener: (context, state) {
                      if (state is SeenError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.errorMessage)));
                      }
                      if (state is SeenLoaded) {
                        onSeenLoaded
                            ?.call(state.seenBy.map((e) => e.userId).toList());
                      }
                    }, builder: (context, state) {
                      if (state is SeenLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (state is SeenLoaded) {
                        final seenByUsers = state.seenBy;
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Seen by (${seenByUsers.length})",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            Expanded(
                                child: ListView.builder(
                                    itemCount: seenByUsers.length,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, index) {
                                      final user = seenByUsers[index];
                                      return UserTileSmall(user: user);
                                    }))
                          ],
                        );
                      }
                      return const Center(
                        child: Text("Error loading likes"),
                      );
                    }),
                  ));
            });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.visibility,
                size: 32,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.white,
                    offset: Offset(1, 1),
                    blurRadius: 2,
                  )
                ]),
            Text("${currentSeen.length}",
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )),
          ],
        ),
      ),
    );
  }
}
