import 'package:fitness_project/common/bloc/pic_selection_cubit.dart';
import 'package:fitness_project/common/widgets/picture_picker.dart';
import 'package:fitness_project/presentation/create_group/bloc/create_group_form_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class DetailsForm extends StatefulWidget {
  final Function onNext;
  final CreateGroupFormState state;
  final XFile? image;
  const DetailsForm(
      {super.key, required this.onNext, this.image, required this.state});

  @override
  State<DetailsForm> createState() => _DetailsFormState();
}

class _DetailsFormState extends State<DetailsForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameCon = TextEditingController();
  final TextEditingController descriptionCon = TextEditingController();

  @override
  void dispose() {
    nameCon.dispose();
    descriptionCon.dispose();
    super.dispose();
  }

  @override
  void initState() {
    nameCon.text = widget.state.name ?? '';
    descriptionCon.text = widget.state.description ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
          key: _formKey,
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: PicturePicker(
                image: widget.image,
                pickFrom: (source) {
                  context.read<PicSelectionCubit>().pickFrom(source);
                },
                shape: BoxShape.rectangle,
                borderRadius: const Radius.circular(28),
                placeholder: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.add_a_photo),
                    const SizedBox(height: 8),
                    Text(
                      "Add group picture",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey[800]),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: nameCon,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.group),
                  labelText: 'Group Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  )),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a group name';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: descriptionCon,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              maxLines: null,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.description),
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  )),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
              textInputAction: TextInputAction.newline,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<CreateGroupFormCubit>().onValuesChanged(
                          name: nameCon.text, description: descriptionCon.text);
                      widget.onNext();
                    }
                  },
                  child: const Text('Next')),
            )
          ])),
    );
  }
}
