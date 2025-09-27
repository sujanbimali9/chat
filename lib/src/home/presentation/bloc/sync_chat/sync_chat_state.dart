part of 'sync_chat_bloc.dart';

sealed class SyncChatState extends Equatable {
  const SyncChatState();

  @override
  List<Object?> get props => [];
}

class Initial extends SyncChatState {
  const Initial();
}
