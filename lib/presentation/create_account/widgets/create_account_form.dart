import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_project/common/bloc/user_cubit.dart';
import 'package:fitness_project/data/models/db/update_user_req.dart';
import 'package:fitness_project/data/models/storage/upload_file_req.dart';
import 'package:fitness_project/domain/usecases/db/update_user.dart';
import 'package:fitness_project/domain/usecases/storage/upload_file.dart';
import 'package:fitness_project/presentation/auth/pages/login.dart';
import 'package:fitness_project/common/bloc/pic_selection_cubit.dart';
import 'package:fitness_project/presentation/navigation/pages/navigation.dart';
import 'package:fitness_project/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../common/widgets/picture_picker.dart';

class CreateAccountForm extends StatefulWidget {
  const CreateAccountForm({super.key});

  @override
  _CreateAccountFormState createState() => _CreateAccountFormState();
}

class _CreateAccountFormState extends State<CreateAccountForm> {
  final TextEditingController displayNameCon = TextEditingController();
  final TextEditingController description = TextEditingController();
  final User? user = FirebaseAuth.instance.currentUser;

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

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("User not found"),
        ),
      );
      return;
    }

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
        ),
      );
    }, (data) {
      context.read<UserCubit>().loadUser();
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return const Navigation();
      }), (route) {
        return route.isFirst;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PicSelectionCubit, XFile?>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: PicturePicker(
                image: state,
                pickFrom: (source) {
                  context.read<PicSelectionCubit>().pickFrom(source);
                },
                removeFile: () {
                  context.read<PicSelectionCubit>().clear();
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
            TextField(
              controller: displayNameCon,
              decoration: const InputDecoration(
                  helperText: "This will be the name used to find you",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  labelText: "Display Name"),
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: description,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  labelText: "Description"),
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () {
                save(context, state, user);
              },
              child: const Text("Save"),
            )
          ],
        );
      },
    );
  }
}
