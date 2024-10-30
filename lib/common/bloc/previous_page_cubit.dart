import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PreviousPageState {
  final Widget? previousPage;
  final Widget? fallbackPage;

  PreviousPageState({this.previousPage, this.fallbackPage});

  PreviousPageState copyWith({
    Widget? previousPage,
    Widget? fallbackPage,
  }) {
    return PreviousPageState(
      previousPage: previousPage ?? this.previousPage,
      fallbackPage: fallbackPage ?? this.fallbackPage,
    );
  }
}

class PreviousPageCubit extends Cubit<PreviousPageState> {
  PreviousPageCubit()
      : super(PreviousPageState(previousPage: null, fallbackPage: null));

  void setPreviousPage(Widget? page) {
    emit(state.copyWith(previousPage: page));
  }

  void setFallbackPage(Widget? page) {
    emit(state.copyWith(fallbackPage: page));
  }
}
