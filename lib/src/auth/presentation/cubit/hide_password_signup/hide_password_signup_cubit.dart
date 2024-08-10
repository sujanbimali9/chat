import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'hide_password_signup_state.dart';

class HidePasswordSignUpCubit extends Cubit<HidePasswordSignupState> {
  HidePasswordSignUpCubit() : super(const HidePasswordSignupState(true));

  void togglePasswordVisibility() {
    emit(state.copyWith(isHidden: !state.isHidden));
  }
}
