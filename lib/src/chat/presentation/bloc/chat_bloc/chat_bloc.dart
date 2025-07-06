import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chat/core/common/model/chat.dart';
import 'package:chat/core/common/model/media.dart';
import 'package:chat/core/common/model/media_metadata.dart';
import 'package:chat/core/common/model/pagination.dart';
import 'package:chat/core/enum/chat_type.dart';
import 'package:chat/src/chat/data/model/media_model.dart';
import 'package:chat/src/chat/domain/usecase/get_chat.dart';
import 'package:chat/src/chat/domain/usecase/get_chat_stream.dart';
import 'package:chat/src/chat/domain/usecase/remove_chat.dart';
import 'package:chat/src/chat/domain/usecase/send_message.dart';
import 'package:chat/src/chat/domain/usecase/update_read_status.dart';
import 'package:chat/src/chat/presentation/reply_cubit/reply_cubit.dart';
import 'package:chat/utils/generator/id_generator.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetChatStreamUseCase _getChatStreamUseCase;
  final RemoveChatUseCase _removeChatUseCase;
  final UpdateReadStatusUserCase _updateReadStatusUseCase;
  final SendChatUseCase _sendChatUseCase;
  final GetChatUseCase _getChatsUseCase;
  final ReplyCubit _replyCubit;
  final String _chatId;
  final String _userId;
  final String _currentUserId;
  bool allChatsLoaded = false;
  StreamSubscription<Chat>? chatSubscription;
  StreamSubscription? connectivitySubscription;

  Pagination _pagination = const Pagination(limit: 20, offset: 0, total: 0);

  ChatBloc(
    this._getChatStreamUseCase,
    this._removeChatUseCase,
    this._sendChatUseCase,
    this._updateReadStatusUseCase,
    this._getChatsUseCase, {
    required String userId,
    required String currentUserId,
    required ReplyCubit replyCubit,
  })  : _replyCubit = replyCubit,
        _currentUserId = currentUserId,
        _userId = userId,
        _chatId = IdGenerator.getConversionId(userId, currentUserId),
        super(const ChatInitial([])) {
    on<ChatEvent>((event, emit) async {
      if (event is FetchMore) {
        await _fetchMore(emit);
      } else if (event is SendChat) {
        await _sendChat(
            event.text, event.type, event.medias, event.mediaType, emit);
      } else if (event is ListenForNewChats) {
        _listenForNewChats();
      } else if (event is UpdateReadStatus) {
        await _updateReadStatus(event.chatId, event.userId);
      } else if (event is StateEmitter) {
        emit(event.state);
      }
    });
    _initListeners();
  }

  void _initListeners() {
    add(const ListenForNewChats());
    add(const FetchMore());
  }

  @override
  Future<void> close() {
    connectivitySubscription?.cancel();
    return super.close();
  }

  FutureOr<void> _fetchMore(Emitter<ChatState> emit) async {
    if (allChatsLoaded) return;
    emit(ChatFetchingMore(state.chats));

    final res = await _getChatsUseCase(GetChatParms(
      chatId: _chatId,
      limit: _pagination.limit,
      offset: _pagination.offset,
    ));
    res.fold(
      (l) => log('Error fetching chats: ${l.message}'),
      (res) {
        final chats = res.data;
        _pagination = res.pagination;
        if (chats.isEmpty) {
          allChatsLoaded = true;
          return;
        }

        emit(ChatLoaded(mergeChatList(state.chats, chats)));
      },
    );
  }

  FutureOr<void> _sendChat(
    String msg,
    ChatType type,
    List<String>? medias,
    MediaType? mediaType,
    Emitter<ChatState> emit,
  ) async {
    if (msg.trim().isEmpty && (medias?.isEmpty ?? true)) return;
    final replyTo = _replyCubit.state is Replying
        ? (_replyCubit.state as Replying).chat
        : null;

    if (replyTo?.status == MessageStatus.failed) return;
    Chat? replyToChat;
    if (replyTo != null) {
      replyToChat = Chat(
        id: replyTo.id,
        msg: replyTo.msg.trim(),
        toId: replyTo.toId,
        read: replyTo.read,
        type: replyTo.type,
        fromId: replyTo.fromId,
        readTime: replyTo.readTime,
        sentTime: replyTo.sentTime,
        status: replyTo.status,
        replyTo: null,
        medias: replyTo.medias,
      );
    }

    final chat = Chat(
      id: const Uuid().v4(),
      msg: msg,
      toId: _userId,
      read: false,
      type: type,
      fromId: _currentUserId,
      readTime: null,
      sentTime: DateTime.now(),
      status: MessageStatus.sending,
      replyTo: replyToChat,
      medias: medias
              ?.map(
                (e) => Media(
                  url: e,
                  type: mediaType!,
                  metaData: const MediaMetaData(),
                ),
              )
              .toList() ??
          [],
    );

    _replyCubit.cancelReply();
    emit(ChatLoaded(mergeChatList(state.chats, [chat])));

    final res = await _sendChatUseCase(chat);

    res.fold(
      (failure) => log('Error sending chats: ${failure.message}'),
      (message) => emit(ChatLoaded(mergeChatList(state.chats, [message]))),
    );
  }

  FutureOr<void> _updateReadStatus(String chatId, String userId) async {
    await _updateReadStatusUseCase(
      UpdateReadStatusParams(
        chatId: chatId,
        userId: userId,
      ),
    );
  }

  void _listenForNewChats() {
    final res = _getChatStreamUseCase(_chatId);
    res.fold(
      (failure) {
        log('Error in chat stream: ${failure.message}');
        _scheduleRetry(const ListenForNewChats());
      },
      (stream) {
        chatSubscription = stream.listen(
          (newChats) => _handleNewChats(newChats),
          onError: (value) {
            log('Chat stream error: $value');
            chatSubscription?.cancel();
            _scheduleRetry(const ListenForNewChats());
          },
        );
      },
    );
  }

  void _handleNewChats(Chat chat) {
    if (isClosed) return;
    add(StateEmitter(state: ChatLoaded(mergeChatList(state.chats, [chat]))));
  }

  void _scheduleRetry(ChatEvent event) {
    Timer(const Duration(seconds: 40), () {
      if (!isClosed) add(event);
    });
  }

  List<Chat> mergeChatList(List<Chat> oldChats, List<Chat> newChats) {
    int i = 0;
    int j = 0;
    List<Chat> mergedList = [];
    while (i < oldChats.length && j < newChats.length) {
      final sentTime1 = oldChats[i].sentTime.millisecondsSinceEpoch;
      final sentTime2 = newChats[j].sentTime.millisecondsSinceEpoch;
      if (sentTime1 > sentTime2) {
        mergedList.add(oldChats[i]);
        i++;
      } else if (sentTime1 < sentTime2) {
        mergedList.add(newChats[j]);
        j++;
      } else {
        mergedList.add(newChats[j]);
        j++;
        i++;
      }
    }
    while (i < oldChats.length) {
      mergedList.add(oldChats[i]);
      i++;
    }
    while (j < newChats.length) {
      mergedList.add(newChats[j]);
      j++;
    }
    return mergedList;
  }
}
