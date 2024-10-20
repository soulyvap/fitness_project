import 'package:flutter/material.dart';

class DateRangeSelection extends StatelessWidget {
  final DateTime? startTime;
  final DateTime? endTime;
  final TextEditingController startTimeCon;
  final TextEditingController endTimeCon;
  final Function(DateTime) onStartTimeChanged;
  final Function(DateTime) onEndTimeChanged;

  const DateRangeSelection({
    super.key,
    this.startTime,
    this.endTime,
    required this.startTimeCon,
    required this.endTimeCon,
    required this.onStartTimeChanged,
    required this.onEndTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: GestureDetector(
          onTap: () async {
            final date = await showDatePicker(
                helpText: 'Select a start date',
                context: context,
                initialDate: startTime,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)));
            if (date != null) {
              onStartTimeChanged(date);
            }
          },
          child: AbsorbPointer(
            child: TextFormField(
              controller: startTimeCon,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.date_range),
                  labelText: 'Start Time',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  helperMaxLines: 2,
                  helperText: 'When the group will be active.'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a start time';
                }
                return null;
              },
            ),
          ),
        )),
        const SizedBox(width: 16),
        Expanded(
            child: GestureDetector(
          onTap: () async {
            final date = await showDatePicker(
                context: context,
                initialDate: endTime,
                firstDate: startTime ?? DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 3650)));
            if (date != null) {
              onEndTimeChanged(date);
            }
          },
          child: AbsorbPointer(
            child: TextFormField(
              controller: endTimeCon,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.date_range),
                  labelText: 'End Time',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  helperMaxLines: 2,
                  helperText: 'When the group will be closed.'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an end time';
                }
                return null;
              },
            ),
          ),
        )),
      ],
    );
  }
}
