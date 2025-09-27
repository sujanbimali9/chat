part of 'sync_chat_bloc.dart';

sealed class SyncChatEvent extends Equatable {
  const SyncChatEvent();

  @override
  List<Object?> get props => [];
}

class ListenForNewChats extends SyncChatEvent {
  const ListenForNewChats();
}

class StopListeningForNewChats extends SyncChatEvent {
  final String chatId;

  const StopListeningForNewChats(this.chatId);

  @override
  List<Object?> get props => [chatId];
}
