import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat/core/common/model/chat.dart';
import 'package:chat/core/common/model/pagination.dart';
import 'package:chat/core/common/model/user.dart';
import 'package:chat/src/home/domain/usecases/get_interacted_user.dart';
import 'package:chat/src/home/domain/usecases/get_user.dart';
import 'package:chat/src/home/presentation/bloc/current_user_bloc/current_user_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'interacted_user_bloc_event.dart';
part 'interacted_user_bloc_state.dart';
part 'interacted_user_bloc_bloc.freezed.dart';

class InteractedUserBloc
    extends Bloc<InteractedUserEvent, InteractedUserState> {
  final GetInteractedUserUseCase _getInteractedUserUseCase;
  final CurrentUserBloc _currentUserBloc;

  Pagination _userPagination = const Pagination(offset: 0, limit: 20, total: 0);

  final interactedUsers = <String, User>{};

  InteractedUserBloc(this._getInteractedUserUseCase, this._currentUserBloc)
      : super(const _Initial()) {
    on<InteractedUserEvent>((event, emit) {
      event.map<FutureOr<void>>(
        getInteractedUser: (e) => _getInteractedUser(emit),
        getInteractedUserLocal: (e) => _getInteractedUserLocal(emit),
        sortUsers: (e) => _sortUsers(emit, e),
        refreshUser: (e) => _refreshUser(emit),
        fetchMoreUser: (e) => _fetchMoreUser(emit),
      );
    });
  }
  FutureOr<void> _getInteractedUser(Emitter<InteractedUserState> emit) async {
    emit(const InteractedUserState.loading());
    final result = await _getInteractedUserUseCase(GetUserParms(
      limit: _userPagination.limit,
      offset: _userPagination.offset,
    ));
    result.fold(
      (l) {},
      (res) {
        final users = res.data;
        _userPagination = res.pagination;
        for (final user in users) {
          interactedUsers[user.id] = user;
        }
        emit(InteractedUserState.loaded(interactedUsers.values.toList()));
      },
    );
  }

  FutureOr<void> _refreshUser(Emitter<InteractedUserState> emit) {
    _userPagination = const Pagination(offset: 0, limit: 20, total: 0);
    add(const InteractedUserEvent.getInteractedUser());
  }

  FutureOr<void> _fetchMoreUser(Emitter<InteractedUserState> emit) async {
    if (_userPagination.total < interactedUsers.length ||
        _userPagination.total == _userPagination.offset) {
      return;
    }

    final result = await _getInteractedUserUseCase(GetUserParms(
      limit: _userPagination.limit,
      offset: interactedUsers.length,
    ));

    result.fold(
      (l) {
        emit(InteractedUserState.error(l.message));
      },
      (res) {
        final users = res.data;
        _userPagination = res.pagination;
        for (final user in users) {
          interactedUsers[user.id] = user;
        }
        emit(InteractedUserState.loaded(interactedUsers.values.toList()));
      },
    );
  }

  FutureOr<void> _getInteractedUserLocal(
      Emitter<InteractedUserState> emit) async {
    emit(const InteractedUserState.loading());
    final result = await _getInteractedUserUseCase(GetUserParms(
      limit: _userPagination.limit,
      offset: _userPagination.offset,
    ));
    result.fold(
      (l) {
        emit(InteractedUserState.error(l.message));
      },
      (res) {
        final users = res.data;
        _userPagination = res.pagination;
        for (final user in users) {
          interactedUsers[user.id] = user;
        }
        emit(InteractedUserState.loaded(interactedUsers.values.toList()));
      },
    );
  }

  List<User> _sortUsersWithLastChat(List<User> users, List<Chat> chats) {
    final currentUserId = _currentUserBloc.state.maybeWhen(
      orElse: () => null,
      loaded: (user) => user.id,
      imageUploading: (user) => user.id,
    );
    if (currentUserId == null) return users;

    final userIds = <String>{};
    final sortedUsers = <User>[];

    for (final chat in chats) {
      final userId = chat.fromId == currentUserId ? chat.toId : chat.fromId;
      if (userIds.add(userId)) {
        final user = interactedUsers[userId];
        if (user != null) sortedUsers.add(user);
      }
    }

    final userWithoutChat = <User>[];
    for (final user in users) {
      if (!userIds.contains(user.id)) {
        userWithoutChat.add(user);
      }
    }

    userWithoutChat.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    sortedUsers.addAll(userWithoutChat);

    return sortedUsers;
  }

  FutureOr<void> _sortUsers(
      Emitter<InteractedUserState> emit, _SortUsers event) {
    final chats = event.listChats;
    emit(InteractedUserState.loaded(
        _sortUsersWithLastChat(interactedUsers.values.toList(), chats)));
  }
}
