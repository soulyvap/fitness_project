import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePicSelectionCubit extends Cubit<XFile?> {
  ProfilePicSelectionCubit() : super(null);

  void pickFrom(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    emit(image);
  }
}
