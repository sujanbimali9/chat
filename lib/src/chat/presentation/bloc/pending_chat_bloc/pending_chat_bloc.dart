import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chat/src/auth/domain/usecases/logout.dart';
import 'package:chat/src/chat/domain/usecase/get_pending_chat.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

import 'package:chat/core/common/model/chat.dart';
import 'package:chat/src/chat/domain/usecase/send_message.dart';

part 'pending_chat_event.dart';
part 'pending_chat_state.dart';

class PendingChatBloc extends Bloc<PendingChatEvent, PendingChatState> {
  final Connectivity _connectivity;

  final SendChatUseCase _sendMessageUseCase;
  final GetPendingChatUseCase _pendingChatUseCase;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  PendingChatBloc(
    this._sendMessageUseCase,
    this._pendingChatUseCase,
    this._connectivity,
  ) : super(PendingChatInitial()) {
    on<RetryPendingChats>(_retryPendingChats);
    listenToConnectivity();
  }

  FutureOr<void> _retryPendingChats(
      RetryPendingChats event, Emitter<PendingChatState> emit) async {
    final res = await _pendingChatUseCase(NoParams());
    log('RetryPendingChats: $res');
    res.fold(
      (l) => {},
      (r) => {
        log('RetryPendingChats: $r'),
        if (r.isNotEmpty) {_retry(r)}
      },
    );
  }

  Future<void> _retry(List<Chat> pendingChats) async {
    final chatsFuture = <Future>[];

    for (final chat in pendingChats) {
      chatsFuture.add(_sendMessageUseCase(chat));
    }

    await Future.wait(chatsFuture);
  }

  void listenToConnectivity() {
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((event) {
      if (!event.contains(ConnectivityResult.none)) {
        log('Retry pending chats');
        add(RetryPendingChats());
      }
    });
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
