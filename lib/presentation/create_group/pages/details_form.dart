import 'package:fitness_project/common/bloc/pic_selection_cubit.dart';
import 'package:fitness_project/common/widgets/picture_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class DetailsForm extends StatefulWidget {
  final Function onNext;
  final Function(String name, String description) saveData;
  const DetailsForm({super.key, required this.onNext, required this.saveData});

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
  Widget build(BuildContext context) {
    return BlocBuilder<PicSelectionCubit, XFile?>(builder: (context, state) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
            key: _formKey,
            child: Column(children: [
              PicturePicker(
                image: state,
                pickFrom: (source) {
                  context.read<PicSelectionCubit>().pickFrom(source);
                },
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(28),
                placeholder: const Icon(
                  Icons.people_outlined,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: nameCon,
                decoration: const InputDecoration(
                    labelText: 'Group Name', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a group name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descriptionCon,
                decoration: const InputDecoration(
                    labelText: 'Description', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      widget.saveData(nameCon.text, descriptionCon.text);
                      widget.onNext();
                    }
                  },
                  child: const Text('Next'))
            ])),
      );
    });
  }
}
