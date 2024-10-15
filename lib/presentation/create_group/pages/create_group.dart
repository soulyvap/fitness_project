import 'dart:developer';

import 'package:fitness_project/common/bloc/pic_selection_cubit.dart';
import 'package:fitness_project/common/widgets/back_arrow_button.dart';
import 'package:fitness_project/presentation/create_group/bloc/create_group_form_cubit.dart';
import 'package:fitness_project/presentation/create_group/pages/details_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  _CreateGroupPageState createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void navigateToTab(int index) {
    _tabController.animateTo(index);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<PicSelectionCubit>(
              create: (context) => PicSelectionCubit()),
          BlocProvider<CreateGroupFormCubit>(
              create: (context) => CreateGroupFormCubit()),
        ],
        child: Scaffold(
            appBar: AppBar(
              leading: const BackArrowButton(),
              title: const Text('Create a group'),
              bottom: TabBar(
                controller: _tabController,
                splashFactory: NoSplash.splashFactory,
                onTap: (index) {
                  if (index > _tabController.previousIndex) {
                    navigateToTab(_tabController.previousIndex);
                  }
                },
                tabs: const [
                  Tab(
                    text: 'Details',
                    icon: Icon(Icons.info),
                  ),
                  Tab(
                    text: 'Settings',
                    icon: Icon(Icons.settings),
                  ),
                  Tab(
                    text: 'Participants',
                    icon: Icon(Icons.people),
                  ),
                ],
              ),
            ),
            body: BlocBuilder<CreateGroupFormCubit, CreateGroupFormState>(
                builder: (context, state) {
              return TabBarView(
                controller: _tabController,
                children: [
                  DetailsForm(
                    onNext: () {
                      navigateToTab(1);
                    },
                    saveData: (name, description) {
                      context.read<CreateGroupFormCubit>().onValuesChanged(
                          name: name, description: description);
                    },
                  ),
                  const Center(
                    child: Text('Settings Page'),
                  ),
                  const Center(
                    child: Text('Participants Page'),
                  ),
                ],
              );
            })));
  }
}
