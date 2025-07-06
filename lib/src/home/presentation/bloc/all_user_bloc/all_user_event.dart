part of 'all_user_bloc.dart';

@freezed
class UserEvent with _$UserEvent {
  const factory UserEvent.getAllUser() = _GetAllUser;
  const factory UserEvent.searchUser(String query) = _SearchUser;
  const factory UserEvent.getAllUserLocal() = _GetAllUserLocal;
  const factory UserEvent.fetchMoreUser() = _FetchMoreUser;
  const factory UserEvent.refreshUser() = _RefreshUser;
}
