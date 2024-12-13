import 'package:fitness_project/common/widgets/challenge_explanation.dart';
import 'package:fitness_project/domain/entities/db/user.dart';
import 'package:fitness_project/presentation/home/bloc/home_data_cubit.dart';
import 'package:fitness_project/presentation/home/widgets/challenge_list.dart';
import 'package:fitness_project/presentation/home/widgets/submission_list.dart';
import 'package:fitness_project/presentation/home/widgets/your_groups_list.dart';
import 'package:fitness_project/presentation/profile/pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  final UserEntity currentUser;
  const HomePage({super.key, required this.currentUser});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void navigateToPage(Widget page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final homeDataState = context.watch<HomeDataCubit>().state;
      if (homeDataState is HomeDataLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (homeDataState is HomeDataError) {
        return Center(
          child: Text(homeDataState.errorMessage),
        );
      } else if (homeDataState is HomeDataLoaded) {
        final groups = homeDataState.myGroups;
        final exercises = homeDataState.allExercises;
        final activeChallenges = homeDataState.activeChallenges;
        final previousChallenges = homeDataState.previousChallenges;
        final allChallenges = [...activeChallenges, ...previousChallenges];
        final submissions = homeDataState.activeSubmissions;
        return Scaffold(
          appBar: AppBar(
            title: Text("Welcome back ${widget.currentUser.displayName}"),
            actions: [
              IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return const ChallengeExplanation();
                        });
                  },
                  icon: const Icon(Icons.help)),
              IconButton(
                icon: CircleAvatar(
                  backgroundImage: widget.currentUser.image != null
                      ? NetworkImage(widget.currentUser.image!)
                      : null,
                  child: widget.currentUser.image == null
                      ? Center(
                          child: Text(
                          widget.currentUser.displayName[0].toUpperCase(),
                          style: const TextStyle(fontSize: 20),
                        ))
                      : null,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfilePage(),
                    ),
                  );
                },
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              context.read<HomeDataCubit>().loadData(widget.currentUser.userId);
              Future.delayed(const Duration(seconds: 1));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 0),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    YourGroupsList(groups: groups),
                    const SizedBox(
                      height: 16,
                    ),
                    if (activeChallenges.isNotEmpty || groups.isNotEmpty)
                      ChallengeList(
                        title: "Active challenges (${activeChallenges.length})",
                        groups: groups,
                        challenges: activeChallenges,
                        exercises: exercises,
                        leading: Icon(
                          Icons.local_fire_department,
                          size: 32,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    const SizedBox(
                      height: 16,
                    ),
                    if (submissions.isNotEmpty)
                      SubmissionList(
                          submissions: submissions,
                          groups: groups,
                          challenges: allChallenges,
                          exercises: exercises,
                          title: "Recent submissions"),
                    const SizedBox(
                      height: 16,
                    ),
                    if (previousChallenges.isNotEmpty)
                      ChallengeList(
                          title: "Previous challenges",
                          groups: groups,
                          challenges: previousChallenges,
                          exercises: exercises,
                          lastFirst: true,
                          withAddButton: false,
                          leading: Icon(
                            Icons.history,
                            size: 32,
                            color: Theme.of(context).colorScheme.secondary,
                          )),
                    const SizedBox(
                      height: 86,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      } else {
        return const SizedBox();
      }
    });
  }
}
