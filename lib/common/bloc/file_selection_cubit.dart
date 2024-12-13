import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class FileSelectionCubit extends Cubit<XFile?> {
  final FileType type;
  final Duration? maxDuration;
  FileSelectionCubit({required this.type, this.maxDuration}) : super(null);

  void pickFrom(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? file;
    switch (type) {
      case FileType.image:
        file = await picker.pickImage(source: source);
        break;
      case FileType.video:
        file = await picker.pickVideo(source: source, maxDuration: maxDuration);
        break;
    }
    emit(file);
  }

  void clear() {
    emit(null);
  }
}

enum FileType { image, video }
