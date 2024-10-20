import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PicturePicker extends StatelessWidget {
  final XFile? image;
  final Function(ImageSource) pickFrom;
  final BoxShape? shape;
  final Widget? placeholder;
  final BorderRadius? borderRadius;

  const PicturePicker(
      {super.key,
      this.image,
      required this.pickFrom,
      this.shape,
      this.placeholder,
      this.borderRadius});

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
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 2,
                    ),
                    shape: shape ?? BoxShape.circle,
                    borderRadius: borderRadius,
                    color: Colors.grey[400],
                    image: image != null
                        ? DecorationImage(
                            image: FileImage(File(image!.path)),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: Center(child: placeholder)),
            ),
          ),
          const SizedBox(
            height: 16,
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
