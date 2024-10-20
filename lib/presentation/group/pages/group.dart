import 'package:fitness_project/domain/entities/db/group.dart';
import 'package:fitness_project/presentation/group/pages/group_info.dart';
import 'package:fitness_project/presentation/group/widgets/group_header.dart';
import 'package:flutter/material.dart';

class GroupPage extends StatefulWidget {
  final GroupEntity group;
  const GroupPage({super.key, required this.group});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.group.name),
        leading: const BackButton(),
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
          GroupInfoTab(group: widget.group),
          Container(),
          Container(),
        ],
      ),
    );
  }
}
