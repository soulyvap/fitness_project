import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class AddChallengeTile extends StatelessWidget {
  final Function onTap;
  final bool hasChallenges;
  const AddChallengeTile(
      {super.key, required this.onTap, this.hasChallenges = true});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: hasChallenges
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 64,
            height: 128,
            child: InkWell(
              onTap: () => onTap(),
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
          if (!hasChallenges)
            const SizedBox(
              width: 300,
              child: ListTile(
                dense: true,
                leading: Icon(Icons.arrow_back),
                title: Text("You have no challenges yet"),
                subtitle: Text("Press the + button to start one!"),
              ),
            ),
        ],
      ),
    );
  }
}
