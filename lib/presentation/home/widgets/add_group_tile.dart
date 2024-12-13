import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class AddGroupTile extends StatelessWidget {
  final Function onTap;
  final bool hasGroups;
  const AddGroupTile({super.key, required this.onTap, this.hasGroups = true});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () => onTap(),
          child: SizedBox(
            width: 64,
            height: 100,
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: DottedBorder(
                borderType: BorderType.RRect,
                color: Colors.black.withOpacity(0.5),
                dashPattern: const [6, 6],
                radius: const Radius.circular(20),
                child: const Center(
                  child: Icon(Icons.add, size: 32, color: Colors.grey),
                ),
              ),
            ),
          ),
        ),
        if (!hasGroups)
          const SizedBox(
            width: 300,
            child: ListTile(
              dense: true,
              leading: Icon(Icons.arrow_back),
              title: Text("You have no groups yet"),
              subtitle: Text("Press the + button to create one!"),
            ),
          ),
      ],
    );
  }
}
