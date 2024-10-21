import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class AddGroupTile extends StatelessWidget {
  final Function onTap;
  const AddGroupTile({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: SizedBox(
        width: 100,
        height: 100,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: DottedBorder(
            borderType: BorderType.RRect,
            dashPattern: const [6, 6],
            radius: const Radius.circular(20),
            child: const Center(
              child: Icon(Icons.add, size: 40, color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }
}
