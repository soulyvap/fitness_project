import 'package:flutter_bloc/flutter_bloc.dart';

class NavIndexCubit extends Cubit<int> {
  final int? initialIndex;
  NavIndexCubit(this.initialIndex) : super(initialIndex ?? 0);

  void setIndex(int index) {
    if (index == 2) return;
    emit(index);
  }
}
