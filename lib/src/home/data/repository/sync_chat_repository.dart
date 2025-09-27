import 'dart:async';
import 'dart:developer';

import 'package:chat/core/failure/failure.dart';
import 'package:chat/src/chat/data/model/chat_model.dart';
import 'package:chat/src/home/domain/repository/sync_chat_repository.dart';
import 'package:chat/utils/database/local_database.dart';
import 'package:chat/utils/services/socket_io.dart';

class SyncChatRepositoryImp implements SyncChatRepository {
  final LocalDatabase _localDatabase;
  final SocketIOService _socketIOService;
  SyncChatRepositoryImp(this._localDatabase, this._socketIOService);

  Future<void> saveChatToLocal(ChatModel chat) async {
    try {
      await _localDatabase.chatTableQuery.insertChat(chat);
    } catch (e) {
      log('Failed to save chat to local database: ${e.toString()}');
      throw Failure('Failed to save chat: ${e.toString()}');
    }
  }

  @override
  StreamSubscription syncChat() {
    return _socketIOService.chatStream.listen((chatData) async {
      final chat = ChatModel.fromJson(chatData);
      await saveChatToLocal(chat);
    });
  }
}
