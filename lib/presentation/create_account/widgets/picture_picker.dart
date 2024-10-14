import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PicturePicker extends StatelessWidget {
  final XFile? image;
  final Function(ImageSource) pickFrom;

  const PicturePicker({super.key, this.image, required this.pickFrom});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: AspectRatio(
              aspectRatio: 1 / 1,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.orange,
                    width: 1,
                  ),
                  shape: BoxShape.circle,
                  image: image != null
                      ? DecorationImage(
                          image: FileImage(File(image!.path)),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: SizedBox.expand(
                  child: image == null
                      ? const FittedBox(
                          fit: BoxFit.contain,
                          child: Icon(
                            Icons.person,
                            color: Colors.grey,
                          ),
                        )
                      : null,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.image),
                onPressed: () {
                  pickFrom(ImageSource.gallery);
                },
                label: const Text("Open gallery"),
              ),
              const SizedBox(
                width: 16,
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.camera_alt),
                onPressed: () {
                  pickFrom(ImageSource.camera);
                },
                label: const Text("Open camera"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
