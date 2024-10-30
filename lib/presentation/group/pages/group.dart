import 'dart:math';

import 'package:fitness_project/common/bloc/previous_page_cubit.dart';
import 'package:fitness_project/domain/entities/db/group.dart';
import 'package:fitness_project/presentation/group/bloc/group_cubit.dart';
import 'package:fitness_project/presentation/group/pages/group_info.dart';
import 'package:fitness_project/presentation/navigation/pages/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupPage extends StatefulWidget {
  final String groupId;
  const GroupPage({super.key, required this.groupId});

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  void onBack(BuildContext context) {
    final previousPage = context.read<PreviousPageCubit>().state;
    if (previousPage == null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Navigation()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => previousPage));
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        onBack(context);
      },
      child: BlocProvider<GroupCubit>(
        create: (context) => GroupCubit(groupId: widget.groupId),
        child: Builder(builder: (context) {
          final groupState = context.watch<GroupCubit>().state;
          if (groupState is GroupError) {
            return Center(
              child: Text(groupState.errorMessage),
            );
          } else if (groupState is GroupLoaded) {
            final group = groupState.group;
            return Scaffold(
              appBar: AppBar(
                title: Text(group.name),
                leading: BackButton(
                  onPressed: () {
                    onBack(context);
                  },
                ),
                bottom: TabBar(controller: _tabController, tabs: const [
                  Tab(
                    text: "Group info",
                    icon: Icon(Icons.info),
                  ),
                  Tab(
                    text: "Posts",
                    icon: Icon(Icons.post_add),
                  ),
                  Tab(
                    text: "Leaderboard",
                    icon: Icon(Icons.leaderboard),
                  ),
                ]),
              ),
              body: TabBarView(
                controller: _tabController,
                children: [
                  GroupInfoTab(group: group),
                  Container(),
                  Container(),
                ],
              ),
            );
          } else {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        }),
      ),
    );
  }
}
