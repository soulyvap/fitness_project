import 'package:flutter/material.dart';

class CustomDropDown extends StatelessWidget {
  final Widget placeholder;
  final Widget? selected;
  final bool? disabled;
  final Widget Function(BuildContext) modalBuilder;

  const CustomDropDown(
      {super.key,
      required this.placeholder,
      this.selected,
      required this.modalBuilder,
      this.disabled});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: InkWell(
          onTap: () {
            if (disabled == true) return;
            showModalBottomSheet(
                isDismissible: false,
                enableDrag: false,
                isScrollControlled: true,
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
