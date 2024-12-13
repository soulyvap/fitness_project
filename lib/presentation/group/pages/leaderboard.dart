import 'package:fitness_project/common/widgets/score_summary_row.dart';
import 'package:fitness_project/domain/entities/db/score.dart';
import 'package:fitness_project/presentation/group/bloc/leaderboard_cubit.dart';
import 'package:fitness_project/presentation/group/widgets/leaderboard_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LeaderboardTab extends StatelessWidget {
  final Function(bool) setPreventReload;
  const LeaderboardTab({super.key, required this.setPreventReload});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Builder(builder: (context) {
        final leaderboardState = context.watch<LeaderboardCubit>().state;
        if (leaderboardState is LeaderboardInitial) {
          context.read<LeaderboardCubit>().loadData();
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (leaderboardState is LeaderboardError) {
          return Center(
            child: Text(leaderboardState.errorMessage),
          );
        } else if (leaderboardState is LeaderboardLoaded) {
          final leaderboard = leaderboardState.leaderboard;
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<LeaderboardCubit>().loadData();
                Future.delayed(const Duration(seconds: 1));
              },
              child: ListView.separated(
                separatorBuilder: (context, index) => const Divider(),
                itemCount: leaderboard.length,
                itemBuilder: (context, index) {
                  final item = leaderboard[index];
                  return LeaderboardTile(
                      item: item,
                      onTap: () {
                        setPreventReload(true);
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              final scores = leaderboardState.scores
                                  .where((element) =>
                                      element.userId == item.user.userId)
                                  .toList();
                              return Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                        "Score Summary for ${item.user.displayName}",
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: ScoreType.values.map((type) {
                                          final scoresOfType = scores
                                              .where((element) =>
                                                  element.type == type)
                                              .toList();
                                          final totalPoints =
                                              scoresOfType.fold<int>(
                                                  0,
                                                  (previousValue, element) =>
                                                      previousValue +
                                                      element.points);
                                          final length = scoresOfType.length;
                                          if (length == 0) {
                                            return const SizedBox();
                                          }
                                          return ScoreSummaryRow(
                                              leading: type.icon,
                                              title: "$length x ${type.title}",
                                              points: totalPoints);
                                        }).toList()),
                                  ],
                                ),
                              );
                            });
                      });
                },
              ),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      }),
    );
  }
}
