import 'package:fitness_project/common/bloc/need_refresh_cubit.dart';
import 'package:fitness_project/common/widgets/start_a_challenge_sheet.dart';
import 'package:fitness_project/domain/entities/db/group.dart';
import 'package:fitness_project/main.dart';
import 'package:fitness_project/presentation/group/bloc/group_cubit.dart';
import 'package:fitness_project/presentation/group/bloc/group_submissions_cubit.dart';
import 'package:fitness_project/presentation/group/bloc/leaderboard_cubit.dart';
import 'package:fitness_project/presentation/group/bloc/members_cubit.dart';
import 'package:fitness_project/presentation/group/pages/group_info.dart';
import 'package:fitness_project/presentation/group/pages/leaderboard.dart';
import 'package:fitness_project/presentation/group/pages/submissions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupPage extends StatefulWidget {
  final String groupId;
  final int initialTabIndex;
  const GroupPage({super.key, required this.groupId, this.initialTabIndex = 0});

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage>
    with TickerProviderStateMixin, RouteAware {
  late final TabController _tabController;
  String groupName = "";
  GroupEntity? group;
  bool preventReloadOnPop = false;
  Function()? reload;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.index = widget.initialTabIndex;
    context.read<NeedRefreshCubit>().setValue(true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    if (preventReloadOnPop) {
      setState(() {
        preventReloadOnPop = false;
      });
      return;
    }
    final needsRefresh = context.read<NeedRefreshCubit>().state;
    if (needsRefresh) {
      reload?.call();
    }
    super.didPopNext();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GroupCubit>(
          create: (context) => GroupCubit(groupId: widget.groupId),
        ),
        BlocProvider<LeaderboardCubit>(
            create: (context) => LeaderboardCubit(groupId: widget.groupId)),
        BlocProvider(
            create: (context) =>
                GroupSubmissionsCubit(groupId: widget.groupId)),
        BlocProvider(
            create: (context) => MembersCubit(groupId: widget.groupId)),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(groupName),
          leading: const BackButton(),
          bottom: TabBar(controller: _tabController, tabs: const [
            Tab(
              text: "Group info",
              icon: Icon(Icons.info),
            ),
            Tab(
              text: "Submissions",
              icon: Icon(Icons.post_add),
            ),
            Tab(
              text: "Leaderboard",
              icon: Icon(Icons.leaderboard),
            ),
          ]),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              preventReloadOnPop = true;
            });
            showModalBottomSheet(
                isScrollControlled: true,
                showDragHandle: true,
                backgroundColor: Colors.white,
                context: context,
                builder: (context) => StartAChallengeSheet(
                      group: group,
                      onStartChallenge: () {
                        reload?.call();
                      },
                    ));
          },
          child: const Icon(Icons.fitness_center),
        ),
        body: BlocConsumer<GroupCubit, GroupState>(
            listener: (context, groupState) {
          if (groupState is GroupLoaded) {
            if (groupName.isEmpty) {
              setState(() {
                groupName = groupState.group.name;
              });
            }
            if (group == null) {
              setState(() {
                group = groupState.group;
              });
            }
            reload ??= () {
              context.read<GroupCubit>().loadData();
            };
          }
        }, builder: (context, groupState) {
          if (groupState is GroupError) {
            return Center(
              child: Text(groupState.errorMessage),
            );
          } else if (groupState is GroupLoaded) {
            final group = groupState.group;
            final challenges =
                groupState.activeChallenges + groupState.previousChallenges;
            final exercises = groupState.allExercises;
            return TabBarView(
              controller: _tabController,
              children: [
                GroupInfoTab(
                    groupData: groupState,
                    setPreventReload: (needReload) {
                      preventReloadOnPop = needReload;
                    }),
                SubmissionsTab(
                  group: group,
                  challenges: challenges,
                  exercises: exercises,
                ),
                const LeaderboardTab(),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }),
      ),
    );
  }
}
