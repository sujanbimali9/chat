import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chat/core/common/model/chat.dart';
import 'package:chat/core/common/model/pagination.dart';
import 'package:chat/core/common/model/user.dart';
import 'package:chat/src/auth/domain/usecases/logout.dart';
import 'package:chat/src/home/domain/usecases/get_interacted_user.dart';
import 'package:chat/src/home/domain/usecases/get_interactive_user_stream.dart';
import 'package:chat/src/home/domain/usecases/get_user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversation_history_event.dart';
part 'conversation_history_state.dart';
part 'conversation_history_bloc.freezed.dart';

class ConversationHistoryBloc
    extends Bloc<ConversationHistoryEvent, ConversationHistory> {
  final GetConverstationHistoryUserUseCase _getConversationHistoryUseCase;
  final GetConversationHistoryUseCaseStream
  _getConversationHistoryUseCaseStream;

  StreamSubscription<List<({User user, Chat chat})>>? _userStreamController;

  UserPagination _userPagination = const UserPagination(
    offset: 0,
    limit: 20,
    total: 0,
  );

  final interactedUsers = <String, ({User user, Chat chat})>{};

  ConversationHistoryBloc(
    this._getConversationHistoryUseCase,
    this._getConversationHistoryUseCaseStream,
  ) : super(const _Initial()) {
    on<ConversationHistoryEvent>((event, emit) async {
      await event.map<FutureOr<void>>(
        getConversationHistory: (e) => _getInteractedUser(emit),
        getConversationHistoryLocal: (e) => _getInteractedUserLocal(emit),
        sortUsers: (e) => (),
        refreshConversationHistory: (e) => _refreshUser(emit),
        fetchMoreConversationHistory: (e) => _fetchMoreUser(emit),
        stateEmitter: (e) => emit(e.state),
      );
    });
    add(const ConversationHistoryEvent.getConversationHistoryLocal());
    add(const ConversationHistoryEvent.getConversationHistory());

    listenForNewChats();
  }

  void listenForNewChats() {
    final res = _getConversationHistoryUseCaseStream(NoParams());

    res.fold((failure) {}, (stream) {
      _userStreamController = stream.listen((data) {
        for (final record in data) {
          interactedUsers[record.user.id] = record;
        }
        add(
          ConversationHistoryEvent.stateEmitter(
            ConversationHistory.loaded(interactedUsers.values.toList()),
          ),
        );
      });
    });
  }

  FutureOr<void> _getInteractedUser(Emitter<ConversationHistory> emit) async {
    emit(const ConversationHistory.loading());
    final result = await _getConversationHistoryUseCase(
      GetUserParms(
        limit: _userPagination.limit,
        offset: _userPagination.offset,
      ),
    );

    result.fold(
      (l) {
        log('GetInteractedUser error: ${l.message}');
      },
      (res) {
        final data = res.data;
        _userPagination = res.pagination;
        for (final record in data) {
          interactedUsers[record.user.id] = record;
        }
        emit(ConversationHistory.loaded(interactedUsers.values.toList()));
      },
    );
  }

  FutureOr<void> _refreshUser(Emitter<ConversationHistory> emit) {
    _userPagination = const UserPagination(offset: 0, limit: 20, total: 0);
    add(const ConversationHistoryEvent.getConversationHistory());
  }

  FutureOr<void> _fetchMoreUser(Emitter<ConversationHistory> emit) async {
    if (_userPagination.total < interactedUsers.length ||
        _userPagination.total == _userPagination.offset) {
      return;
    }

    final result = await _getConversationHistoryUseCase(
      GetUserParms(
        limit: _userPagination.limit,
        offset: interactedUsers.length,
      ),
    );

    result.fold((l) {}, (res) {
      final data = res.data;
      _userPagination = res.pagination;
      for (final record in data) {
        interactedUsers[record.user.id] = record;
      }
      emit(ConversationHistory.loaded(interactedUsers.values.toList()));
    });
  }

  FutureOr<void> _getInteractedUserLocal(
    Emitter<ConversationHistory> emit,
  ) async {
    emit(const ConversationHistory.loading());
    final result = await _getConversationHistoryUseCase(
      GetUserParms(
        limit: _userPagination.limit,
        offset: _userPagination.offset,
      ),
    );
    result.fold(
      (l) {
        log('Failed to get InteractedUsersLocal');
        emit(ConversationHistory.error(l.message));
      },
      (res) {
        final data = res.data;
        _userPagination = res.pagination;
        for (final record in data) {
          interactedUsers[record.user.id] = record;
        }
        emit(ConversationHistory.loaded(interactedUsers.values.toList()));
      },
    );
  }

  @override
  Future<void> close() {
    _userStreamController?.cancel();
    return super.close();
  }
}
