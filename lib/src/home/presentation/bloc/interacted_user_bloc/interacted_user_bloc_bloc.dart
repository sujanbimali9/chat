import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat/core/common/model/chat.dart';
import 'package:chat/core/common/model/pagination.dart';
import 'package:chat/core/common/model/user.dart';
import 'package:chat/src/auth/domain/usecases/logout.dart';
import 'package:chat/src/home/domain/usecases/get_interacted_user.dart';
import 'package:chat/src/home/domain/usecases/get_interactive_user_stream.dart';
import 'package:chat/src/home/domain/usecases/get_user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'interacted_user_bloc_event.dart';
part 'interacted_user_bloc_state.dart';
part 'interacted_user_bloc_bloc.freezed.dart';

class InteractedUserBloc
    extends Bloc<InteractedUserEvent, InteractedUserState> {
  final GetInteractedUserUseCase _getInteractedUserUseCase;
  final GetInteractedUserUseCaseStream _getInteractedUserUseCaseStream;

  StreamSubscription<List<({User user, Chat chat})>>? _userStreamController;

  UserPagination _userPagination = const UserPagination(
    offset: 0,
    limit: 20,
    total: 0,
  );

  final interactedUsers = <String, ({User user, Chat chat})>{};

  InteractedUserBloc(
    this._getInteractedUserUseCase,
    this._getInteractedUserUseCaseStream,
  ) : super(const _Initial()) {
    on<InteractedUserEvent>((event, emit) async {
      await event.map<FutureOr<void>>(
        getInteractedUser: (e) => _getInteractedUser(emit),
        getInteractedUserLocal: (e) => _getInteractedUserLocal(emit),
        sortUsers: (e) => (),
        refreshUser: (e) => _refreshUser(emit),
        fetchMoreUser: (e) => _fetchMoreUser(emit),
        stateEmitter: (e) => emit(e.state),
      );
    });
    add(const InteractedUserEvent.getInteractedUserLocal());
    add(const InteractedUserEvent.getInteractedUser());

    listenForNewChats();
  }

  void listenForNewChats() {
    final res = _getInteractedUserUseCaseStream(NoParams());

    res.fold((failure) {}, (stream) {
      _userStreamController = stream.listen((data) {
        for (final record in data) {
          interactedUsers[record.user.id] = record;
        }
        add(
          InteractedUserEvent.stateEmitter(
            InteractedUserState.loaded(interactedUsers.values.toList()),
          ),
        );
      });
    });
  }

  FutureOr<void> _getInteractedUser(Emitter<InteractedUserState> emit) async {
    emit(const InteractedUserState.loading());
    final result = await _getInteractedUserUseCase(
      GetUserParms(
        limit: _userPagination.limit,
        offset: _userPagination.offset,
      ),
    );

    result.fold(
      (l) {
        print('GetInteractedUser error: ${l.message}');
      },
      (res) {
        final data = res.data;
        _userPagination = res.pagination;
        for (final record in data) {
          interactedUsers[record.user.id] = record;
        }
        emit(InteractedUserState.loaded(interactedUsers.values.toList()));
      },
    );
  }

  FutureOr<void> _refreshUser(Emitter<InteractedUserState> emit) {
    _userPagination = const UserPagination(offset: 0, limit: 20, total: 0);
    add(const InteractedUserEvent.getInteractedUser());
  }

  FutureOr<void> _fetchMoreUser(Emitter<InteractedUserState> emit) async {
    if (_userPagination.total < interactedUsers.length ||
        _userPagination.total == _userPagination.offset) {
      return;
    }

    final result = await _getInteractedUserUseCase(
      GetUserParms(
        limit: _userPagination.limit,
        offset: interactedUsers.length,
      ),
    );

    result.fold(
      (l) {
        emit(InteractedUserState.error(l.message));
      },
      (res) {
        final data = res.data;
        _userPagination = res.pagination;
        for (final record in data) {
          interactedUsers[record.user.id] = record;
        }
        emit(InteractedUserState.loaded(interactedUsers.values.toList()));
      },
    );
  }

  FutureOr<void> _getInteractedUserLocal(
    Emitter<InteractedUserState> emit,
  ) async {
    emit(const InteractedUserState.loading());
    final result = await _getInteractedUserUseCase(
      GetUserParms(
        limit: _userPagination.limit,
        offset: _userPagination.offset,
      ),
    );
    result.fold(
      (l) {
        emit(InteractedUserState.error(l.message));
      },
      (res) {
        final data = res.data;
        _userPagination = res.pagination;
        for (final record in data) {
          interactedUsers[record.user.id] = record;
        }
        emit(InteractedUserState.loaded(interactedUsers.values.toList()));
      },
    );
  }

  @override
  Future<void> close() {
    _userStreamController?.cancel();
    return super.close();
  }
}
