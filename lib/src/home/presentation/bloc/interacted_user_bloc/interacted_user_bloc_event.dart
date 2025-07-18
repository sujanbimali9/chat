part of 'interacted_user_bloc_bloc.dart';

@freezed
class InteractedUserEvent with _$InteractedUserEvent {
  const factory InteractedUserEvent.getInteractedUser() = _GetInteractedUser;
  const factory InteractedUserEvent.getInteractedUserLocal() =
      _GetInteractedUserLocal;
  const factory InteractedUserEvent.sortUsers(List<Chat> listChats) =
      _SortUsers;
  const factory InteractedUserEvent.refreshUser() = _RefreshUser;
  const factory InteractedUserEvent.fetchMoreUser() = _FetchMoreUser;
  const factory InteractedUserEvent.stateEmitter(InteractedUserState state) =
      _StateEmitter;
}
