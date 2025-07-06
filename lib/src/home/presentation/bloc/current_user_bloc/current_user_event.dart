part of 'current_user_bloc.dart';

@freezed
class CurrentUserEvent with _$CurrentUserEvent {
  const factory CurrentUserEvent.getCurrentUser() = _GetCurrentUser;
  const factory CurrentUserEvent.updateCurrentUser(User user) =
      _UpdateCurrentUser;
  const factory CurrentUserEvent.updateImage(String image) = _UpdateImage;
}
