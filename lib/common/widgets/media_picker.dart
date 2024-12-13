import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:fitness_project/common/widgets/challenge_preview_player.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MediaPicker extends StatefulWidget {
  final XFile? file;
  final Function(ImageSource) pickFrom;
  final BoxShape? shape;
  final Widget? placeholder;
  final Radius? borderRadius;
  final Function() removeFile;

  const MediaPicker(
      {super.key,
      this.file,
      required this.pickFrom,
      this.shape,
      this.placeholder,
      this.borderRadius,
      required this.removeFile});

  @override
  State<MediaPicker> createState() => _MediaPickerState();
}

class _MediaPickerState extends State<MediaPicker> {
  @override
  Widget build(BuildContext context) {
    final file = widget.file;
    final pickFrom = widget.pickFrom;
    final placeholder = widget.placeholder;
    final borderRadius = widget.borderRadius;
    final removeFile = widget.removeFile;
    bool isImage = file?.path.split(".").last == "jpg" ||
        file?.path.split(".").last == "jpeg" ||
        file?.path.split(".").last == "png";

    return SizedBox(
      width: double.infinity,
      child: AspectRatio(
        aspectRatio: 1 / 1,
        child: DottedBorder(
          dashPattern: const [6, 6],
          color: file == null ? Colors.black : Colors.transparent,
          borderType: BorderType.RRect,
          radius: borderRadius ?? const Radius.circular(1000),
          child: InkWell(
            borderRadius:
                BorderRadius.all(borderRadius ?? const Radius.circular(1000)),
            onTap: () {
              if (file != null && !isImage) {
                return;
              }
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Card(
                            child: ListTile(
                              leading: const Icon(Icons.image),
                              onTap: () {
                                Navigator.pop(context);
                                pickFrom(ImageSource.gallery);
                              },
                              title: const Text("Open gallery"),
                            ),
                          ),
                          Card(
                            child: ListTile(
                              leading: const Icon(Icons.camera_alt),
                              onTap: () {
                                Navigator.pop(context);
                                pickFrom(ImageSource.camera);
                              },
                              title: const Text("Open camera"),
                            ),
                          ),
                          if (file != null)
                            Card(
                              child: ListTile(
                                leading: const Icon(Icons.delete),
                                onTap: () {
                                  Navigator.pop(context);
                                  removeFile();
                                },
                                title: const Text("Remove"),
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
                  image: file != null && isImage
                      ? DecorationImage(
                          image: FileImage(File(file.path)),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: file == null
                    ? Center(child: placeholder)
                    : !isImage
                        ? ChallengePreviewPlayer(
                            file: File(file.path), removeFile: removeFile)
                        : null),
          ),
        ),
      ),
    );
  }
}
