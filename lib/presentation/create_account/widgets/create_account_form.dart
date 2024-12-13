import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_project/common/bloc/user_cubit.dart';
import 'package:fitness_project/data/models/db/update_user_req.dart';
import 'package:fitness_project/data/models/storage/upload_file_req.dart';
import 'package:fitness_project/domain/entities/db/user.dart';
import 'package:fitness_project/domain/usecases/db/get_users_by_display_name.dart';
import 'package:fitness_project/domain/usecases/db/update_user.dart';
import 'package:fitness_project/domain/usecases/storage/upload_file.dart';
import 'package:fitness_project/main.dart';
import 'package:fitness_project/common/bloc/file_selection_cubit.dart';
import 'package:fitness_project/presentation/navigation/pages/navigation.dart';
import 'package:fitness_project/presentation/start/pages/login.dart';
import 'package:fitness_project/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../common/widgets/media_picker.dart';

class CreateAccountForm extends StatefulWidget {
  const CreateAccountForm({super.key});

  @override
  _CreateAccountFormState createState() => _CreateAccountFormState();
}

class _CreateAccountFormState extends State<CreateAccountForm> {
  final TextEditingController displayNameCon = TextEditingController();
  final TextEditingController description = TextEditingController();
  final User? user = FirebaseAuth.instance.currentUser;
  bool? usernameTaken;
  bool loadingUsers = false;
  Timer? _debounce;
  final _formKey = GlobalKey<FormState>();
  bool submitting = false;

  @override
  void initState() {
    if (user == null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
    }
    super.initState();
  }

  void save(BuildContext context, XFile? imageFile, User? user) async {
    String? imageUrl;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("User not found"),
        ),
      );
      return;
    }

    setState(() {
      submitting = true;
    });

    if (imageFile != null) {
      var file = File(imageFile.path);
      var path = 'images/profile_pictures/${user.uid}';
      var upload = await sl<UploadFileUseCase>()
          .call(params: UploadFileReq(path: path, file: file));
      imageUrl = upload.fold((error) {
        return null;
      }, (data) {
        return data;
      });
    }

    var userUpdate = await sl<UpdateUserUseCase>().call(
        params: UpdateUserReq(
            userId: user.uid,
            email: user.email ?? "",
            displayName: displayNameCon.text,
            description: description.text,
            image: imageUrl));

    userUpdate.fold((error) {
      setState(() {
        submitting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
        ),
      );
    }, (data) async {
      await context.read<UserCubit>().loadUser(user.uid);
      navigatorKey.currentState
          ?.pushReplacement(MaterialPageRoute(builder: (context) {
        return const Navigation();
      }));
    });
  }

  Future<void> checkUsername(String name) async {
    var users = await sl<GetUsersByDisplayNameUseCase>().call(params: name);
    users.fold((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
        ),
      );
    }, (data) {
      final users = data as List<UserEntity>;
      setState(() {
        usernameTaken = users.any(
            (user) => user.displayName.toLowerCase() == name.toLowerCase());
        loadingUsers = false;
      });
    });
  }

  void onTypeUsername(String name) async {
    if (name.isEmpty) {
      setState(() {
        usernameTaken = null;
        loadingUsers = false;
      });
      return;
    }
    setState(() {
      loadingUsers = true;
    });
    if (name.length > 2) {
      _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 1500), () {
        checkUsername(name);
      });
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FileSelectionCubit, XFile?>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: MediaPicker(
                file: state,
                pickFrom: (source) {
                  context.read<FileSelectionCubit>().pickFrom(source);
                },
                removeFile: () {
                  context.read<FileSelectionCubit>().clear();
                },
                placeholder: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_a_photo,
                      size: 48,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text("Add profile picture")
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: displayNameCon,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Display name is required";
                        }
                        if (usernameTaken == true) {
                          return "Display name is already taken. Please try another one";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          helperText: "This will be the name used to find you",
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          labelText: "Display Name",
                          suffixIcon: loadingUsers
                              ? Transform.scale(
                                  scale: 0.5,
                                  child: const CircularProgressIndicator())
                              : usernameTaken == null
                                  ? null
                                  : usernameTaken!
                                      ? const Icon(Icons.error,
                                          color: Colors.red)
                                      : const Icon(Icons.check_circle,
                                          color: Colors.green)),
                      onChanged: (value) => onTypeUsername(value),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: description,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          labelText: "Description"),
                    ),
                  ],
                )),
            const SizedBox(
              height: 32,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  save(context, state, user);
                },
                child: submitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator())
                    : const Text("Save"),
              ),
            )
          ],
        );
      },
    );
  }
}
