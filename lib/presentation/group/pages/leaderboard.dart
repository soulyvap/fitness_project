import 'package:fitness_project/presentation/group/bloc/leaderboard_cubit.dart';
import 'package:fitness_project/presentation/group/widgets/leaderboard_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LeaderboardTab extends StatelessWidget {
  const LeaderboardTab({super.key});

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
              },
              child: ListView.builder(
                itemCount: leaderboard.length,
                itemBuilder: (context, index) {
                  final item = leaderboard[index];
                  return LeaderboardTile(item: item);
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
