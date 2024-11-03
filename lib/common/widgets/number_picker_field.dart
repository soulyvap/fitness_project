import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class NumberPickerField extends StatefulWidget {
  final int? value;
  final Function(int?) onChanged;
  final Widget? leading;
  final String? unit;
  final int? min;
  final int? max;
  final String? label;
  final String? errorText;
  final int? step;

  const NumberPickerField({
    super.key,
    this.leading,
    this.unit,
    this.value,
    required this.onChanged,
    this.min,
    this.max,
    this.label,
    this.errorText,
    this.step,
  });

  @override
  State<NumberPickerField> createState() => _NumberPickerFieldState();
}

class _NumberPickerFieldState extends State<NumberPickerField> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => NumberPickerModalContent(
              onSave: (value) {
                widget.onChanged(value);
                controller.text = value.toString();
              },
              value: widget.value,
              unit: widget.unit,
              min: widget.min,
              max: widget.max,
              label: widget.label,
              step: widget.step),
        );
      },
      decoration: InputDecoration(
        prefixIcon: widget.leading,
        labelText: widget.label,
        suffix: widget.unit != null ? Text(widget.unit!) : null,
        errorText: widget.errorText,
      ),
      controller: controller,
    );
  }
}

class NumberPickerModalContent extends StatefulWidget {
  final int? value;
  final Function(int) onSave;
  final String? unit;
  final int? min;
  final int? max;
  final String? label;
  final int? step;

  const NumberPickerModalContent(
      {super.key,
      this.value,
      this.unit,
      this.min,
      this.max,
      required this.onSave,
      this.label,
      this.step});

  @override
  State<NumberPickerModalContent> createState() =>
      _NumberPickerModalContentState();
}

class _NumberPickerModalContentState extends State<NumberPickerModalContent> {
  late int tempValue;

  @override
  void initState() {
    tempValue = widget.value ?? widget.min ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 300,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                widget.label ?? "Select a value",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.unit ?? "",
                        style: const TextStyle(color: Colors.transparent)),
                    NumberPicker(
                      value: tempValue,
                      step: widget.step ?? 1,
                      minValue: widget.min ?? 0,
                      maxValue: widget.max ?? 100,
                      onChanged: (value) {
                        if (value != tempValue) {
                          setState(() {
                            tempValue = value;
                          });
                        }
                      },
                    ),
                    Text(widget.unit ?? ""),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel')),
                  const SizedBox(width: 16),
                  ElevatedButton(
                      onPressed: () {
                        widget.onSave(tempValue);
                        Navigator.pop(context);
                      },
                      child: const Text('Save')),
                ],
              )
            ],
          ),
        ));
  }
}
