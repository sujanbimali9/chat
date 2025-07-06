part of 'interacted_user_bloc_bloc.dart';

@freezed
class InteractedUserState with _$InteractedUserState {
  const factory InteractedUserState.initial() = _Initial;
  const factory InteractedUserState.loading() = _Loading;
  const factory InteractedUserState.error(String message) = _Error;
  const factory InteractedUserState.loaded(List<User> users) = _Loaded;
  const factory InteractedUserState.fetchingMore(List<User> users) =
      _FetchingMore;
}
