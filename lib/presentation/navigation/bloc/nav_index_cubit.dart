import 'package:flutter_bloc/flutter_bloc.dart';

class NavIndexCubit extends Cubit<int> {
  final int? initialIndex;
  NavIndexCubit(this.initialIndex) : super(initialIndex ?? 0);

  void setIndex(int index) {
    var newIndex = index > 1 ? index - 1 : index;
    emit(newIndex);
  }
}
