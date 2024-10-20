import 'package:fitness_project/common/extensions/datetime_extension.dart';
import 'package:fitness_project/presentation/create_group/bloc/create_group_form_cubit.dart';
import 'package:fitness_project/presentation/create_group/widgets/date_range_selection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsForm extends StatefulWidget {
  final Function onNext;
  final Function onPrev;
  final CreateGroupFormState state;
  const SettingsForm(
      {super.key,
      required this.onNext,
      required this.onPrev,
      required this.state});

  @override
  State<SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();
  final TextEditingController startTimeCon = TextEditingController();
  final TextEditingController endTimeCon = TextEditingController();
  final TextEditingController simultaneousChallengesCon =
      TextEditingController();
  // final TextEditingController minutesPerChallengeCon = TextEditingController();
  bool isPrivate = false;

  @override
  void dispose() {
    startTimeCon.dispose();
    endTimeCon.dispose();
    simultaneousChallengesCon.dispose();
    // minutesPerChallengeCon.dispose();
    super.dispose();
  }

  @override
  void initState() {
    startTime = widget.state.startTime ?? DateTime.now();
    endTime = widget.state.endTime ?? DateTime.now();
    startTimeCon.text = startTime.toDateString();
    endTimeCon.text = endTime.toDateString();
    simultaneousChallengesCon.text =
        widget.state.maxSimultaneousChallenges?.toString() ?? '';
    // minutesPerChallengeCon.text =
    //     widget.state.minutesPerChallenge?.toString() ?? '';
    isPrivate = widget.state.isPrivate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
          key: _formKey,
          child: Column(children: [
            DateRangeSelection(
                startTime: startTime,
                endTime: endTime,
                startTimeCon: startTimeCon,
                endTimeCon: endTimeCon,
                onStartTimeChanged: (date) {
                  setState(() {
                    startTime = date;
                    startTimeCon.text = date.toDateString();
                    if (endTime.isBefore(startTime)) {
                      endTime = startTime;
                      endTimeCon.text = startTime.toDateString();
                    }
                  });
                },
                onEndTimeChanged: (date) {
                  setState(() {
                    endTime = date;
                    endTimeCon.text = date.toDateString();
                    if (endTime.isBefore(startTime)) {
                      startTime = endTime;
                      startTimeCon.text = endTime.toDateString();
                    }
                  });
                }),
            const SizedBox(height: 16),
            TextFormField(
              controller: simultaneousChallengesCon,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.numbers),
                  labelText: 'Maximum challenges at the same time',
                  border: OutlineInputBorder(),
                  helperMaxLines: 2,
                  helperText:
                      'How many challenges can be active at the same time. Enter 0 for unlimited.'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a number';
                }
                return null;
              },
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly, // Allows only digits
                FilteringTextInputFormatter.allow(RegExp(
                    r'^[1-9][0-9]*')), // No leading zero, only positive integers
              ],
              textInputAction: TextInputAction.next,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  _formKey.currentState?.validate();
                }
              },
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            // TextFormField(
            //   controller: minutesPerChallengeCon,
            //   decoration: const InputDecoration(
            //       prefixIcon: Icon(Icons.timer_outlined),
            //       labelText: 'Minutes to complete a challenge',
            //       border: OutlineInputBorder(),
            //       helperMaxLines: 2,
            //       helperText:
            //           'How many minutes a user has to submit an attempt before a challenge ends.'),
            //   validator: (value) {
            //     if (value == null || value.isEmpty) {
            //       return 'Please enter an amount of minutes';
            //     }
            //     return null;
            //   },
            //   inputFormatters: [
            //     FilteringTextInputFormatter.digitsOnly, // Allows only digits
            //     FilteringTextInputFormatter.allow(RegExp(
            //         r'^[1-9][0-9]*')), // No leading zero, only positive integers
            //   ],
            //   textInputAction: TextInputAction.done,
            //   onChanged: (value) {
            //     if (value.isNotEmpty) {
            //       _formKey.currentState?.validate();
            //     }
            //   },
            //   keyboardType: TextInputType.number,
            // ),
            const SizedBox(height: 16),
            CheckboxListTile(
                title: const Text('Private group'),
                controlAffinity: ListTileControlAffinity.leading,
                value: isPrivate,
                onChanged: (value) {
                  setState(() {
                    isPrivate = value!;
                  });
                }),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<CreateGroupFormCubit>().onValuesChanged(
                          startTime: startTime,
                          endTime: endTime,
                          maxSimultaneousChallenges:
                              int.tryParse(simultaneousChallengesCon.text),
                          // minutesPerChallenge:
                          //     int.tryParse(minutesPerChallengeCon.text),
                          isPrivate: isPrivate);
                      widget.onNext();
                    }
                  },
                  child: const Text('Next')),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                  onPressed: () {
                    context.read<CreateGroupFormCubit>().onValuesChanged(
                        startTime: startTime,
                        endTime: endTime,
                        maxSimultaneousChallenges:
                            int.tryParse(simultaneousChallengesCon.text),
                        // minutesPerChallenge:
                        //     int.tryParse(minutesPerChallengeCon.text),
                        isPrivate: isPrivate);
                    widget.onPrev();
                  },
                  child: const Text('Previous')),
            )
          ])),
    );
  }
}
