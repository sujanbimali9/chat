part of 'hide_password_cubit.dart';

@immutable
class HidePasswordLoginState {
  final bool isHidden;

  const HidePasswordLoginState(this.isHidden);

  HidePasswordLoginState copyWith({bool? isHidden}) =>
      HidePasswordLoginState(isHidden ?? this.isHidden);
}
