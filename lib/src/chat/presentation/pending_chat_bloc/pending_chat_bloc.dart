import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chat/core/common/model/chat.dart';
import 'package:chat/core/enum/chat_type.dart';
import 'package:chat/src/chat/domain/usecase/send_audio.dart';
import 'package:chat/src/chat/domain/usecase/send_file.dart';
import 'package:chat/src/chat/domain/usecase/send_image.dart';
import 'package:chat/src/chat/domain/usecase/send_text.dart';
import 'package:chat/src/chat/domain/usecase/send_video.dart';
import 'package:chat/utils/database/local_database.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

part 'pending_chat_event.dart';
part 'pending_chat_state.dart';

class PendingChatBloc extends Bloc<PendingChatEvent, PendingChatState> {
  final Connectivity _connectivity;
  final SendImageUseCase _sendImageUseCase;
  final SendAudioUseCase _sendAudioUseCase;
  final SendVideoUseCase _sendVideoUseCase;
  final SendFileUseCase _sendFileUseCase;
  final SendTextUseCase _sendTextUseCase;
  final LocalDatabase _localDatabase;

  PendingChatBloc(
    Connectivity connectivity,
    SendImageUseCase sendImageUseCase,
    SendAudioUseCase sendAudioUseCase,
    SendVideoUseCase sendVideoUseCase,
    SendFileUseCase sendFileUseCase,
    SendTextUseCase sendTextUseCase,
    LocalDatabase localDatabase,
  )   : _sendImageUseCase = sendImageUseCase,
        _sendAudioUseCase = sendAudioUseCase,
        _sendVideoUseCase = sendVideoUseCase,
        _sendFileUseCase = sendFileUseCase,
        _sendTextUseCase = sendTextUseCase,
        _connectivity = connectivity,
        _localDatabase = localDatabase,
        super(PendingChatInitial()) {
    on<RetryPendingChats>(_retryPendingChats);
    listenToConnectivity();
  }

  FutureOr<void> _retryPendingChats(
      RetryPendingChats event, Emitter<PendingChatState> emit) async {
    final pendingChats = await _localDatabase.getPendingChats();
    if (pendingChats.isNotEmpty) {
      await _retry(pendingChats);
    }
  }

  Future<void> _retry(List<Chat> pendingChats) async {
    final chatsFuture = <Future<void>>[];

    for (final item in pendingChats) {
      final chat = item.copyWith(status: MessageStatus.sent);

      switch (chat.type) {
        case ChatType.audio:
          chatsFuture.add(_sendAudioUseCase(chat));
        case ChatType.file:
          chatsFuture.add(_sendFileUseCase(chat));
        case ChatType.video:
          chatsFuture.add(_sendVideoUseCase(chat));
        case ChatType.image:
          chatsFuture.add(_sendImageUseCase(chat));
        case ChatType.text:
          chatsFuture.add(_sendTextUseCase(chat));
      }
    }
    await Future.wait(chatsFuture);
  }

  void listenToConnectivity() {
    _connectivity.onConnectivityChanged.listen((event) {
      if (!event.contains(ConnectivityResult.none)) {
        log('Retry pending chats');
        add(RetryPendingChats());
      }
    });
  }
}
