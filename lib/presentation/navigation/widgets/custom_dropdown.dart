import 'package:flutter/material.dart';

class CustomDropDown extends StatelessWidget {
  final Widget placeholder;
  final Widget? selected;
  final Widget Function(BuildContext) modalBuilder;

  const CustomDropDown(
      {super.key,
      required this.placeholder,
      this.selected,
      required this.modalBuilder});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: InkWell(
          onTap: () {
            showModalBottomSheet(
                isDismissible: false,
                enableDrag: false,
                context: context,
                builder: modalBuilder);
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: selected ?? placeholder,
          ),
        ));
  }
}
