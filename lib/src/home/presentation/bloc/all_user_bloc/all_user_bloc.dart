import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:chat/core/common/model/pagination.dart';
import 'package:chat/core/common/model/user.dart';
import 'package:chat/src/home/domain/usecases/get_user.dart';
import 'package:chat/src/home/domain/usecases/get_user_local.dart';
import 'package:chat/src/home/domain/usecases/search_user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'all_user_event.dart';
part 'all_user_state.dart';
part 'all_user_bloc.freezed.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetAllUsersUseCase _getAllUserUseCase;
  final SearchUserUseCase _searchUserUseCase;
  final GetAllUserLocalUseCase _getAllUserLocalUseCase;
  Pagination _userPagination = const Pagination(offset: 0, limit: 20, total: 0);
  Pagination _searchPagination =
      const Pagination(offset: 0, limit: 20, total: 0);
  final allUsers = <String, User>{};
  UserBloc(
    this._getAllUserUseCase,
    this._searchUserUseCase,
    this._getAllUserLocalUseCase,
  ) : super(const _Initial()) {
    on<UserEvent>((event, emit) async {
      await event.map<FutureOr<void>>(
        getAllUser: (e) => _getAllUser(emit),
        searchUser: (e) => _searchUser(emit, e),
        getAllUserLocal: (e) => _getUsersLocal(emit),
        fetchMoreUser: (value) {},
        refreshUser: (e) => _getAllUser(emit),
      );
    });
    add(const UserEvent.getAllUserLocal());
    add(const UserEvent.getAllUser());
  }

  FutureOr<void> _getAllUser(Emitter<UserState> emit) async {
    final result = await _getAllUserUseCase(GetUserParms(
      limit: _userPagination.limit,
      offset: _userPagination.offset,
    ));
    result.fold(
      (l) {},
      (res) {
        final users = res.data;
        _userPagination = res.pagination;
        for (final user in users) {
          allUsers[user.id] = user;
        }

        emit(UserState.loaded(allUsers.values.toList()));
      },
    );
  }

  FutureOr<void> _searchUser(Emitter<UserState> emit, _SearchUser e) async {
    final result = await _searchUserUseCase(SearchUserParams(
      query: e.query,
      limit: _searchPagination.limit,
      offset: _searchPagination.offset,
    ));
    final allUser = state.maybeWhen<List<User>>(
      orElse: () => [],
      loaded: (chats) => chats,
    );
    result.fold(
      (l) {
        emit(UserState.error(l.message));
      },
      (res) {
        final users = res.data;
        _searchPagination = res.pagination;
        emit(UserState.searchedUser(users, allUser));
      },
    );
  }

  FutureOr<void> _getUsersLocal(Emitter<UserState> emit) async {
    final result =
        await _getAllUserLocalUseCase(GetUserParms(limit: 30, offset: 0));
    result.fold(
      (l) {
        emit(UserState.error(l.message));
      },
      (res) {
        final users = res.data;
        for (final user in users) {
          allUsers[user.id] = user;
        }

        emit(UserState.loaded(allUsers.values.toList()));
      },
    );
  }
}
