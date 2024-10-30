import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_project/common/bloc/pic_selection_cubit.dart';
import 'package:fitness_project/common/bloc/user_cubit.dart';
import 'package:fitness_project/data/db/models/add_group_member_req.dart';
import 'package:fitness_project/data/db/models/update_group_req.dart';
import 'package:fitness_project/data/storage/models/upload_file_req.dart';
import 'package:fitness_project/domain/usecases/db/add_group_member.dart';
import 'package:fitness_project/domain/usecases/db/update_group.dart';
import 'package:fitness_project/domain/usecases/storage/upload_file.dart';
import 'package:fitness_project/presentation/create_group/bloc/create_group_form_cubit.dart';
import 'package:fitness_project/presentation/create_group/pages/details_form.dart';
import 'package:fitness_project/presentation/create_group/pages/members_form.dart';
import 'package:fitness_project/presentation/create_group/pages/settings_form.dart';
import 'package:fitness_project/presentation/create_group/widgets/user_autocomplete.dart';
import 'package:fitness_project/presentation/group/pages/group.dart';
import 'package:fitness_project/presentation/navigation/pages/navigation.dart';
import 'package:fitness_project/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  _CreateGroupPageState createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  bool loading = false;

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

  Future<String?> onSubmit(
      CreateGroupFormState state, XFile? image, String currentUserId) async {
    String? returnGroupId;
    final editedEndTime =
        state.endTime?.add(const Duration(hours: 23, minutes: 59, seconds: 59));
    final updateGroupReq = UpdateGroupReq(
        name: state.name,
        description: state.description,
        startTime: state.startTime != null
            ? Timestamp.fromDate(state.startTime!)
            : null,
        endTime:
            editedEndTime != null ? Timestamp.fromDate(editedEndTime) : null,
        maxSimultaneousChallenges: state.maxSimultaneousChallenges,
        // minutesPerChallenge: state.minutesPerChallenge,
        isPrivate: state.isPrivate,
        allowedUsers: state.allowedUsers.map((u) => u.userId).toList(),
        members: [currentUserId]);
    final groupUpload =
        await sl<UpdateGroupUseCase>().call(params: updateGroupReq);
    await groupUpload.fold(
      (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error creating group: ${error.toString()}')));
      },
      (groupId) async {
        returnGroupId = groupId;
        await addUserToMembers(currentUserId, groupId);
        if (image != null) {
          await uploadGroupPicture(groupId, image);
        }
      },
    );
    return returnGroupId;
  }

  Future<void> addUserToMembers(String userId, String groupId) async {
    await sl<UpdateGroupMemberUseCase>().call(
        params: UpdateGroupMemberReq(
            groupId: groupId, userId: userId, isAdmin: true));
  }

  Future<void> uploadGroupPicture(String groupId, XFile? image) async {
    if (image != null) {
      final imageUpload = await sl<UploadFileUseCase>().call(
          params: UploadFileReq(
              path: 'images/group_pictures/$groupId', file: File(image.path)));
      await imageUpload.fold(
        (error) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
                  Text('Error uploading group picture: ${error.toString()}')));
        },
        (url) async {
          await sl<UpdateGroupUseCase>()
              .call(params: UpdateGroupReq(groupId: groupId, imageUrl: url));
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = context.read<UserCubit>().state;
    return MultiBlocProvider(
        providers: [
          BlocProvider<PicSelectionCubit>(
              create: (context) => PicSelectionCubit()),
          BlocProvider<CreateGroupFormCubit>(
              create: (context) => CreateGroupFormCubit(
                    allowedUsers:
                        userState is UserLoaded ? [userState.user] : [],
                  )),
        ],
        child: Scaffold(
            appBar: AppBar(
              leading: const BackButton(),
              title: const Text('Create a group'),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(72),
                child: IgnorePointer(
                  ignoring: true,
                  child: TabBar(
                    controller: _tabController,
                    onTap: (index) {
                      if (index != _tabController.index) {
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
                        text: 'Members',
                        icon: Icon(Icons.people),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body: Builder(builder: (blocContext) {
              final statePicSelection =
                  blocContext.watch<PicSelectionCubit>().state;
              final stateCreateGroupForm =
                  blocContext.watch<CreateGroupFormCubit>().state;
              return TabBarView(
                controller: _tabController,
                children: [
                  DetailsForm(
                    state: stateCreateGroupForm,
                    onNext: () {
                      navigateToTab(1);
                    },
                    image: statePicSelection,
                  ),
                  SettingsForm(
                    onNext: () {
                      navigateToTab(2);
                    },
                    onPrev: () {
                      navigateToTab(0);
                    },
                    state: stateCreateGroupForm,
                  ),
                  MembersForm(
                    onSubmit: () async {
                      final authUser =
                          userState is UserLoaded ? userState.user : null;
                      if (authUser != null) {
                        final groupId = await onSubmit(stateCreateGroupForm,
                            statePicSelection, authUser.userId);
                        await Future.delayed(const Duration(seconds: 1));
                        if (context.mounted && groupId != null) {
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(
                            builder: (context) {
                              return GroupPage(groupId: groupId);
                            },
                          ), (route) {
                            return route is Navigation;
                          });
                        }
                      }
                    },
                    onPrev: () {
                      navigateToTab(1);
                    },
                    state: stateCreateGroupForm,
                    showAddMemberSheet: () {
                      showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return UserAutocomplete(
                              onSelectUser: (user) => blocContext
                                  .read<CreateGroupFormCubit>()
                                  .addMember(user),
                              usersAdded: stateCreateGroupForm.allowedUsers,
                            );
                          });
                    },
                  ),
                ],
              );
            })));
  }
}
