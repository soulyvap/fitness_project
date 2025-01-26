import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_project/domain/entities/db/user.dart';
import 'package:fitness_project/presentation/create_group/bloc/create_group_form_cubit.dart';
import 'package:fitness_project/presentation/create_group/widgets/user_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<UserEntity> testUsers = [
  UserEntity(
      userId: '1',
      displayName: 'John Doe',
      email: "",
      image: null,
      description: 'A cool guy'),
  UserEntity(
      userId: '2',
      displayName: 'Jane Doe',
      email: "",
      image: null,
      description: ''),
  UserEntity(
      userId: '3',
      displayName: 'John Smith',
      email: "",
      image: null,
      description: 'A cool guy'),
  UserEntity(
      userId: '4',
      displayName: 'Jane Smith',
      email: "",
      image: null,
      description: '')
];

class MembersForm extends StatefulWidget {
  final Function onSubmit;
  final Function onPrev;
  final CreateGroupFormState state;
  final Function showAddMemberSheet;

  const MembersForm(
      {super.key,
      required this.onSubmit,
      required this.onPrev,
      required this.state,
      required this.showAddMemberSheet});

  @override
  State<MembersForm> createState() => _MembersFormState();
}

class _MembersFormState extends State<MembersForm> {
  @override
  void initState() {
    super.initState();
  }

  final TextEditingController autocompleteCon = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          const SizedBox(
            height: 16,
          ),
          const Text(
            'Invite members to your group.\nYou can also invite them later.',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 8,
          ),
          FilledButton.icon(
            onPressed: () {
              widget.showAddMemberSheet();
            },
            icon: const Icon(Icons.add),
            label: const Text('Invite members'),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                'Members invited (${widget.state.allowedUsers.length})',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: widget.state.allowedUsers.length,
              itemBuilder: (context, index) {
                final user = widget.state.allowedUsers[index];
                return UserListTile(
                  user: user,
                  trailing:
                      user.userId == FirebaseAuth.instance.currentUser?.uid
                          ? null
                          : IconButton(
                              onPressed: () {
                                context
                                    .read<CreateGroupFormCubit>()
                                    .removeMember(user);
                              },
                              icon: const Icon(Icons.remove_circle,
                                  color: Colors.red)),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider();
              },
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () {
                  widget.onSubmit();
                  setState(() {
                    loading = true;
                  });
                },
                child: loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator())
                    : const Text('Create group')),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
                onPressed: () {
                  widget.onPrev();
                },
                child: const Text('Previous')),
          ),
        ],
      ),
    );
  }
}
