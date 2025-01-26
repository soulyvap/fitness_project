import 'dart:async';

import 'package:fitness_project/domain/entities/db/user.dart';
import 'package:fitness_project/common/bloc/user_autocomplete_cubit.dart';
import 'package:fitness_project/presentation/create_group/widgets/user_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserAutocomplete extends StatefulWidget {
  final Function(UserEntity) onSelectUser;
  final List<UserEntity> usersAdded;

  const UserAutocomplete({
    super.key,
    required this.onSelectUser,
    required this.usersAdded,
  });

  @override
  State<UserAutocomplete> createState() => _UserAutocompleteState();
}

class _UserAutocompleteState extends State<UserAutocomplete> {
  final TextEditingController controller = TextEditingController();
  late List<String> usersAddedTemp;

  @override
  void initState() {
    super.initState();
    usersAddedTemp = widget.usersAdded.map((u) => u.userId).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserAutocompleteCubit>(
      create: (context) => UserAutocompleteCubit(),
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 400 + MediaQuery.of(context).viewInsets.bottom,
        child: Builder(builder: (context) {
          final state = context.watch<UserAutocompleteCubit>().state;
          return Column(
            children: [
              Expanded(
                child: state is! UserAutocompleteLoaded
                    ? Center(
                        child: controller.text.isNotEmpty
                            ? const Text("Loading users...")
                            : const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.search,
                                      size: 64, color: Colors.grey),
                                  SizedBox(height: 16),
                                  Text("Find users to invite"),
                                ],
                              ),
                      )
                    : state.users.isEmpty
                        ? const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.search,
                                      size: 64, color: Colors.grey),
                                  SizedBox(height: 16),
                                  Text(
                                      "No users found. Please try another search."),
                                ],
                              )
                            ],
                          )
                        : ListView.separated(
                            itemCount: state.users.length,
                            itemBuilder: (context, index) {
                              final user = state.users[index];
                              return UserListTile(
                                user: user,
                                onTap: () {
                                  if (!usersAddedTemp.contains(user.userId)) {
                                    widget.onSelectUser(user);
                                    setState(() {
                                      usersAddedTemp.add(user.userId);
                                    });
                                  }
                                },
                                trailing: usersAddedTemp.contains(user.userId)
                                    ? const Icon(Icons.check_circle,
                                        color: Colors.green)
                                    : null,
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return Divider(
                                height: 0.2,
                                color: Colors.black.withOpacity(0.1),
                              );
                            },
                          ),
              ),
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  label: const Text('Search by username'),
                  fillColor: Colors.grey[200],
                  filled: true,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: state is UserAutocompleteLoading
                      ? Transform.scale(
                          scale: 0.5, child: const CircularProgressIndicator())
                      : controller.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                controller.clear();
                                context.read<UserAutocompleteCubit>().clear();
                              },
                            )
                          : null,
                ),
                onChanged: (text) async {
                  if (text.length > 2) {
                    context.read<UserAutocompleteCubit>().getUsers(text);
                  }
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).viewInsets.bottom,
              ),
            ],
          );
        }),
      ),
    );
  }
}
