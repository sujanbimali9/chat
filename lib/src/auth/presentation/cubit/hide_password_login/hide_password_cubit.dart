import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'hide_password_state.dart';

class HidePasswordLoginCubit extends Cubit<HidePasswordLoginState> {
  HidePasswordLoginCubit() : super(const HidePasswordLoginState(true));
  void togglePasswordVisibility() {
    emit(state.copyWith(isHidden: !state.isHidden));
  }
}
