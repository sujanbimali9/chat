import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'on_boarding_state.dart';

class OnBoardingCubit extends Cubit<OnBoardingState> {
  OnBoardingCubit()
      : super(const OnBoardingState(currentPage: 0, isLastPage: false));
  void changePage(PageController controller) {
    if (state.isLastPage) {
      emit(const OnBoardingComplete());
    }
    controller.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeIn,
    );
  }

  void skipPage(PageController controller) {
    controller.jumpToPage(2);
    emit(state.copyWith(currentPage: 2, isLastPage: true));
  }

  void updatePage(int currentPage) {
    emit(
        state.copyWith(currentPage: currentPage, isLastPage: currentPage == 2));
  }
}
