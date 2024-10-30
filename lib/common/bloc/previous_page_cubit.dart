import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PreviousPageCubit extends Cubit<Widget?> {
  PreviousPageCubit() : super(null);

  void setPreviousPage(Widget? page) {
    emit(page);
  }
}
