import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat/src/home/domain/usecases/sync_chat.dart';
import 'package:equatable/equatable.dart';

part 'sync_chat_event.dart';
part 'sync_chat_state.dart';

class SyncChatBloc extends Bloc<SyncChatEvent, SyncChatState> {
  final SyncChatUseCase _syncChatUseCase;

  StreamSubscription? _syncSubscription;
  SyncChatBloc(this._syncChatUseCase) : super(const Initial()) {
    on<ListenForNewChats>(_syncChats);
    on<StopListeningForNewChats>(_stopListeningForNewChats);
    add(const ListenForNewChats());
  }

  void _syncChats(ListenForNewChats event, Emitter<SyncChatState> emit) {
    _syncSubscription?.cancel();
    _syncSubscription = _syncChatUseCase();
  }

  void _stopListeningForNewChats(
    StopListeningForNewChats event,
    Emitter<SyncChatState> emit,
  ) {
    _syncSubscription?.cancel();
    _syncSubscription = null;
    emit(const Initial());
  }
}
