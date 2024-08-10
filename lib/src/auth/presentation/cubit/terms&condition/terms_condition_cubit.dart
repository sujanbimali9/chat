import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'terms_condition_state.dart';

class TermsAndConditionCubit extends Cubit<TermsConditionState> {
  TermsAndConditionCubit()
      : super(const TermsConditionState(isAccepted: false));

  void toggleAcceptance() {
    emit(state.copyWith(isAccepted: !state.isAccepted));
  }
}
