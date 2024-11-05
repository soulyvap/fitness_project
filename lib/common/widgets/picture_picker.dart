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
  final Function() removeFile;

  const PicturePicker(
      {super.key,
      this.image,
      required this.pickFrom,
      this.shape,
      this.placeholder,
      this.borderRadius,
      required this.removeFile});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SizedBox(
        width: double.infinity,
        child: AspectRatio(
          aspectRatio: 1 / 1,
          child: DottedBorder(
            dashPattern: const [6, 6],
            color: image == null ? Colors.black : Colors.transparent,
            borderType: BorderType.RRect,
            radius: borderRadius ?? const Radius.circular(1000),
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 100,
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: Card(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                      pickFrom(ImageSource.gallery);
                                    },
                                    child: const Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.image,
                                              size: 48, color: Colors.white),
                                          Text("Open gallery",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            SizedBox(
                              width: 100,
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: Card(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                      pickFrom(ImageSource.camera);
                                    },
                                    child: const Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.camera_alt,
                                              size: 48, color: Colors.white),
                                          Text("Open camera",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if (image != null)
                              const SizedBox(
                                width: 8,
                              ),
                            if (image != null)
                              SizedBox(
                                width: 100,
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Card(
                                    color: Colors.red,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                        removeFile();
                                      },
                                      child: const Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.delete,
                                                size: 48, color: Colors.white),
                                            Text("Remove",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    });
              },
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
      ),
    );
  }
}
