import 'dart:async';

import 'package:chat/src/home/domain/repository/sync_chat_repository.dart';

class SyncChatUseCase {
  final SyncChatRepository _syncChatRepository;
  SyncChatUseCase(this._syncChatRepository);

  StreamSubscription call() {
    return _syncChatRepository.syncChat();
  }
}
