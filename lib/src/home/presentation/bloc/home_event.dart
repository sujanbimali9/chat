part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class GetUsersEvent extends HomeEvent {}

class GetCurrentUserEvent extends HomeEvent {}

class DeleteUserEvent extends HomeEvent {
  final String id;

  const DeleteUserEvent({required this.id});

  @override
  List<Object> get props => [id];
}

class UpdateUserEvent extends HomeEvent {
  final User user;

  const UpdateUserEvent({required this.user});

  @override
  List<Object> get props => [user];
}

class GetUserByIdEvent extends HomeEvent {
  final String id;

  const GetUserByIdEvent({required this.id});

  @override
  List<Object> get props => [id];
}

class SearchUserEvent extends HomeEvent {
  final String query;

  const SearchUserEvent({required this.query});

  @override
  List<Object> get props => [query];
}

class UpdateProfileImageEvent extends HomeEvent {
  final String id;
  final String image;

  const UpdateProfileImageEvent({required this.id, required this.image});

  @override
  List<Object> get props => [id, image];
}

class UpdateOnlineStatusEvent extends HomeEvent {
  final bool showOnlineStatus;

  const UpdateOnlineStatusEvent(this.showOnlineStatus);

  @override
  List<Object> get props => [showOnlineStatus];
}

class CreateUser extends HomeEvent {
  const CreateUser();
}

class GetLastChatEvent extends HomeEvent {
  final String userId;

  const GetLastChatEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}

class _StateEmitterEvent extends HomeEvent {
  final HomeState state;

  const _StateEmitterEvent(this.state);
}
