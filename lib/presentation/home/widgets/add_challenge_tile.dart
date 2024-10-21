import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class AddChallengeTile extends StatelessWidget {
  final Function onTap;
  const AddChallengeTile({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Column(
        children: [
          SizedBox(
            width: 128,
            height: 128,
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
        ],
      ),
    );
  }
}
