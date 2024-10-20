import 'package:fitness_project/domain/entities/db/user.dart';
import 'package:fitness_project/domain/repository/db.dart';
import 'package:fitness_project/presentation/create_group/widgets/user_list_tile.dart';
import 'package:fitness_project/service_locator.dart';
import 'package:flutter/material.dart';

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
  List<UserEntity> suggestions = [];
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 600,
      child: Column(
        children: [
          TextField(
            controller: controller,
            decoration: InputDecoration(
              label: const Text('Search for users to invite'),
              fillColor: Colors.grey[200],
              filled: true,
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.search),
              suffixIcon: loading
                  ? Transform.scale(
                      scale: 0.5, child: const CircularProgressIndicator())
                  : controller.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            controller.clear();
                            setState(() {
                              suggestions = [];
                            });
                          },
                        )
                      : null,
            ),
            onChanged: (text) async {
              if (text.length > 2) {
                setState(() {
                  loading = true;
                });
                final newSuggestions =
                    await sl<DBRepository>().getUsersByDisplayName(text);
                newSuggestions.fold(
                  (l) {
                    setState(() {
                      suggestions = [];
                      loading = false;
                    });
                  },
                  (r) {
                    setState(() {
                      suggestions = r;
                      loading = false;
                    });
                  },
                );
              }
            },
          ),
          const SizedBox(
            height: 16,
          ),
          SizedBox(
            height: 380,
            child: suggestions.isEmpty
                ? null
                : ListView.separated(
                    itemCount: suggestions.length,
                    itemBuilder: (context, index) {
                      final user = suggestions[index];
                      return UserListTile(
                        user: user,
                        onTap: () {
                          if (!widget.usersAdded
                              .map((u) => u.userId)
                              .contains(user.userId)) {
                            widget.onSelectUser(user);
                          }
                        },
                        trailing: widget.usersAdded
                                .map((u) => u.userId)
                                .contains(user.userId)
                            ? const Icon(Icons.check_circle,
                                color: Colors.green)
                            : null,
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider();
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
