import 'package:chat/core/common/model/api_response.dart';
import 'package:chat/core/exception/exception.dart';
import 'package:chat/src/chat/data/model/chat_model.dart';
import 'package:chat/utils/database/daos/last_chat_table_query.dart';
import 'package:chat/utils/database/local_database.dart';

abstract interface class LastChatLocalDataSource {
  Future<ApiResponse<ChatModel>> getLastChats(
      {required int limit, required int offset});
  Future<void> saveLastChats(List<ChatModel> chat);
  Future<void> saveLastChat(ChatModel chat);
}

class LastChatLocalDataSourceImp implements LastChatLocalDataSource {
  final LastChatTableQuery _lastChatQuery;

  LastChatLocalDataSourceImp(LocalDatabase localDatabase)
      : _lastChatQuery = localDatabase.lastChatTableQuery;

  @override
  Future<void> saveLastChats(List<ChatModel> chat) async {
    try {
      await _lastChatQuery.insertLastChats(chat);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ApiResponse<ChatModel>> getLastChats(
      {required int limit, required int offset}) {
    try {
      return _lastChatQuery.getLastChats(limit: limit, offset: offset);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> saveLastChat(ChatModel chat) {
    try {
      return _lastChatQuery.insertLastChat(chat);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
