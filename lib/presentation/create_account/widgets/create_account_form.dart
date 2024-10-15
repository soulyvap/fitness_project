import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_project/data/db/models/update_user_req.dart';
import 'package:fitness_project/data/storage/models/upload_file_req.dart';
import 'package:fitness_project/domain/repository/db.dart';
import 'package:fitness_project/domain/repository/storage.dart';
import 'package:fitness_project/presentation/auth/pages/login.dart';
import 'package:fitness_project/common/bloc/pic_selection_cubit.dart';
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
      var upload = await sl<StorageRepository>()
          .uploadFile(UploadFileReq(path: path, file: file));
      imageUrl = upload.fold((error) {
        return null;
      }, (data) {
        return data;
      });
    }

    var userUpdate = await sl<DBRepository>().updateUser(UpdateUserReq(
        userId: user.uid,
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
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PicSelectionCubit, XFile?>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            PicturePicker(
              image: state,
              pickFrom: (source) {
                context.read<PicSelectionCubit>().pickFrom(source);
              },
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: displayNameCon,
              decoration: const InputDecoration(
                  helperText: "This will be the name used to find you",
                  border: OutlineInputBorder(),
                  labelText: "Display Name"),
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: description,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: "Description"),
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
