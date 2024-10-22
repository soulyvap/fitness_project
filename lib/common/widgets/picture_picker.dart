import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PicturePicker extends StatelessWidget {
  final XFile? image;
  final Function(ImageSource) pickFrom;
  final BoxShape? shape;
  final Widget? placeholder;
  final Radius? borderRadius;

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
              child: DottedBorder(
                dashPattern: const [6, 6],
                color: image == null ? Colors.black : Colors.transparent,
                borderType: BorderType.RRect,
                radius: borderRadius ?? const Radius.circular(1000),
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                          borderRadius ?? const Radius.circular(1000)),
                      shape: shape ?? BoxShape.circle,
                      image: image != null
                          ? DecorationImage(
                              image: FileImage(File(image!.path)),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: image == null ? Center(child: placeholder) : null),
              ),
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
