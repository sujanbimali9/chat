part of 'all_user_bloc.dart';

@freezed
class UserState with _$UserState {
  const factory UserState.initial() = _Initial;
  const factory UserState.loading() = _Loading;
  const factory UserState.error(String message) = _Error;
  const factory UserState.searchedUser(
      List<User> searchUser, List<User> allUser) = _SearchedUser;
  const factory UserState.loaded(List<User> users) = _LocalUser;
  const factory UserState.fetchingMore(List<User> users) = _FetchingMore;
}
