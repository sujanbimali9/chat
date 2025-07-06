part of 'current_user_bloc.dart';

@freezed
class CurrentUserState with _$CurrentUserState {
  const factory CurrentUserState.initial() = _Initial;
  const factory CurrentUserState.loading() = _Loading;
  const factory CurrentUserState.error(User? user, String message) = _Error;
  const factory CurrentUserState.loaded(User user) = _Loaded;
  const factory CurrentUserState.imageUploading(User user) = _ImageUploading;
}
