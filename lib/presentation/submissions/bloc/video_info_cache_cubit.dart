import 'package:fitness_project/presentation/submissions/bloc/video_info_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VideoInfoCacheCubit extends Cubit<Map<int, VideoInfoData>> {
  VideoInfoCacheCubit() : super({});

  void add(int index, VideoInfoData data) {
    if (state.containsKey(index)) {
      return;
    }
    final newState = Map<int, VideoInfoData>.from(state);
    newState[index] = data;
    emit(newState);
  }
}
