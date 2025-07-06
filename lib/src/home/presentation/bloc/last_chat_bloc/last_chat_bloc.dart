import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat/core/common/model/chat.dart';
import 'package:chat/core/common/model/pagination.dart';
import 'package:chat/src/auth/domain/usecases/logout.dart';
import 'package:chat/src/home/domain/usecases/get_last_chats.dart';
import 'package:chat/src/home/domain/usecases/get_last_chats_stream.dart';
import 'package:chat/src/home/presentation/bloc/interacted_user_bloc/interacted_user_bloc_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'last_chat_event.dart';
part 'last_chat_state.dart';
part 'last_chat_bloc.freezed.dart';

class LastChatBloc extends Bloc<LastChatEvent, LastChatState> {
  final GetLastChatsUseCase _getLastChatsUseCase;
  final GetLastChatsStreamUseCase _getLastChatsStreamUseCase;
  final InteractedUserBloc _userBloc;
  Pagination _lastChatPagination =
      const Pagination(offset: 0, limit: 20, total: 0);
  LastChatBloc(
    this._getLastChatsUseCase,
    this._getLastChatsStreamUseCase,
    this._userBloc,
  ) : super(const _Initial()) {
    on<LastChatEvent>((event, emit) async {
      await event.map<FutureOr<void>>(
          getLastChats: (e) => _getLastChats(emit),
          streamLastChat: (e) => _listenToLastChat(emit),
          refreshLastChat: (e) => _refreshLastChat(emit));
    });
    add(const LastChatEvent.getLastChats());
    add(const LastChatEvent.streamLastChat());
  }

  FutureOr<void> _getLastChats(Emitter<LastChatState> emit) async {
    final result = await _getLastChatsUseCase(GetLastChatsParams(
      limit: _lastChatPagination.limit,
      offset: _lastChatPagination.offset,
    ));

    final lastChats = state.maybeMap(orElse: () => null, loaded: (s) => s.chat);
    result.fold(
      (l) {},
      (res) {
        final chats = res.data;
        _lastChatPagination = res.pagination;
        final newLastChats = {
          ...?lastChats,
          for (final chat in chats) chat.chatId: chat,
        };
        emit(LastChatState.loaded(newLastChats));
        _userBloc
            .add(InteractedUserEvent.sortUsers(newLastChats.values.toList()));
      },
    );
  }

  FutureOr<void> _listenToLastChat(Emitter<LastChatState> emit) async {
    final result = _getLastChatsStreamUseCase(NoParams());

    await result.fold((l) {
      emit(LastChatState.error(l.message));
    }, (r) async {
      await for (final chat in r) {
        final lastChats =
            state.maybeMap(orElse: () => null, loaded: (s) => s.chat);
        final newLastChats = {
          ...?lastChats,
          chat.chatId: chat,
        };
        emit(LastChatState.loaded(newLastChats));
        _userBloc
            .add(InteractedUserEvent.sortUsers(newLastChats.values.toList()));
      }
    });
  }

  FutureOr<void> _refreshLastChat(Emitter<LastChatState> emit) async {
    _lastChatPagination = const Pagination(offset: 0, limit: 20, total: 0);
    final result = await _getLastChatsUseCase(GetLastChatsParams(
      limit: _lastChatPagination.limit,
      offset: _lastChatPagination.offset,
    ));

    final lastChats = state.maybeMap(orElse: () => null, loaded: (s) => s.chat);
    result.fold(
      (l) {},
      (res) {
        final r = res.data;
        _lastChatPagination = res.pagination;
        final newLastChats = {
          ...?lastChats,
          for (final chat in r) chat.chatId: chat,
        };
        emit(LastChatState.loaded(newLastChats));
        _userBloc
            .add(InteractedUserEvent.sortUsers(newLastChats.values.toList()));
      },
    );
  }
}
