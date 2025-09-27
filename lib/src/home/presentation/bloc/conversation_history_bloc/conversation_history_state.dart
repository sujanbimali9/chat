part of 'conversation_history_bloc.dart';

@freezed
class ConversationHistory with _$ConversationHistory {
  const factory ConversationHistory.initial() = _Initial;
  const factory ConversationHistory.loading() = _Loading;
  const factory ConversationHistory.error(String message) = _Error;
  const factory ConversationHistory.loaded(
    List<({User user, Chat chat})> data,
  ) = _Loaded;
  const factory ConversationHistory.fetchingMore(
    List<({User user, Chat chat})> data,
  ) = _FetchingMore;
}
