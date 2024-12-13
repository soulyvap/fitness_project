import 'package:flutter/material.dart';

class CancelSubmissionSheet extends StatefulWidget {
  final Function(String) onCancel;
  const CancelSubmissionSheet({super.key, required this.onCancel});

  @override
  State<CancelSubmissionSheet> createState() => _CancelSubmissionSheetState();
}

class _CancelSubmissionSheetState extends State<CancelSubmissionSheet> {
  String? selectedReason;
  String? otherReason;

  final reasons = <String>[
    "Not enough reps",
    "Movement is incorrect",
    "Cannot see the movement",
    "Other",
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 400 + MediaQuery.of(context).viewInsets.bottom,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("Reason for cancellation?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: Wrap(
                spacing: 8,
                children: [
                  for (final reason in reasons)
                    ChoiceChip(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                              color: selectedReason == reason
                                  ? Colors.blue
                                  : Colors.grey)),
                      label: Text(reason),
                      selected: selectedReason == reason,
                      onSelected: (selected) {
                        setState(() {
                          selectedReason = selected ? reason : null;
                        });
                      },
                    )
                ],
              ),
            ),
            if (selectedReason == "Other")
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextField(
                  maxLines: null,
                  decoration: const InputDecoration(
                    labelText: "Please specify a reason",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      otherReason = value;
                    });
                  },
                ),
              ),
            const Spacer(),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.warning, color: Colors.red),
                SizedBox(width: 8),
                Text(
                  "Once a submission is cancelled, it cannot be undone.\nOnly cancel if you are sure.",
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if ((selectedReason == "Other" &&
                    otherReason?.isNotEmpty == true) ||
                (selectedReason != "Other" && selectedReason != null))
              ElevatedButton(
                onPressed: () {
                  final cancellationReason = selectedReason == "Other"
                      ? otherReason ?? "Other reason"
                      : selectedReason ?? "Selected reason";
                  widget.onCancel(cancellationReason);
                  Navigator.of(context).pop();
                },
                child: const Text("Confirm cancellation"),
              ),
          ],
        ),
      ),
    );
  }
}
