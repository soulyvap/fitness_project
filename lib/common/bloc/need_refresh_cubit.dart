import 'package:flutter_bloc/flutter_bloc.dart';

class NeedRefreshCubit extends Cubit<bool> {
  NeedRefreshCubit() : super(false);

  void setValue(bool value) {
    emit(value);
  }
}
