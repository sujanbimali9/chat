part of 'hide_password_signup_cubit.dart';

@immutable
class HidePasswordSignupState {
  final bool isHidden;

  const HidePasswordSignupState(this.isHidden);

  HidePasswordSignupState copyWith({
    bool? isHidden,
  }) {
    return HidePasswordSignupState(
      isHidden ?? this.isHidden,
    );
  }
}
