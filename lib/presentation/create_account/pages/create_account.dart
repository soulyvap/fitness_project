import 'package:fitness_project/presentation/create_account/bloc/profile_pic_selection_cubit.dart';
import 'package:fitness_project/presentation/create_account/widgets/picture_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class CreateAccountPage extends StatelessWidget {
  final String userId;

  CreateAccountPage({super.key, required this.userId});

  final TextEditingController displayNameCon = TextEditingController();
  final TextEditingController description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfilePicSelectionCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Create an account"),
        ),
        body: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                BlocBuilder<ProfilePicSelectionCubit, XFile?>(
                  builder: (context, state) {
                    return PicturePicker(
                      image: state,
                      pickFrom: (source) {
                        context
                            .read<ProfilePicSelectionCubit>()
                            .pickFrom(source);
                      },
                    );
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: displayNameCon,
                  obscureText: true,
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
                  obscureText: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Description"),
                ),
                const Spacer(flex: 1),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Save"),
                )
              ],
            )),
      ),
    );
  }
}
