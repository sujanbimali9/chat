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
import 'package:chat/src/chat/domain/usecase/send_message.dart';
import 'package:chat/src/chat/presentation/bloc/reply_cubit/reply_cubit.dart';
import 'package:chat/utils/generator/id_generator.dart';

import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:uuid/uuid.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetChatStreamUseCase _getChatStreamUseCase;
  final SendChatUseCase _sendChatUseCase;
  final GetChatUseCase _getChatsUseCase;
  final ReplyCubit _replyCubit;
  String? _activeChatId;
  String? _userId;
  String? _currentUserId;
  bool allChatsLoaded = false;
  StreamSubscription<List<Chat>>? chatSubscription;
  StreamSubscription? connectivitySubscription;

  ChatPagination? _chatPagination;

  ChatBloc(
    this._getChatStreamUseCase,
    this._sendChatUseCase,
    this._getChatsUseCase, {
    required ReplyCubit replyCubit,
  }) : _replyCubit = replyCubit,
       super(const ChatInitial([])) {
    on<FetchMore>(_fetchMore);
    on<SendChat>(_sendChat);
    on<ListenForNewChats>((event, emit) {
      _listenForNewChats();
    });
    on<StateEmitter>((event, emit) {
      emit(event.state);
    });
    on<SwitchChat>(_switchChat);
  }

  void _switchChat(SwitchChat event, Emitter<ChatState> emit) {
    final chatId = IdGenerator.getConversionId(
      event.userId,
      event.currentUserId,
    );
    if (_activeChatId == chatId) {
      return;
    }
    _activeChatId = chatId;
    _userId = event.userId;
    _currentUserId = event.currentUserId;
    _chatPagination = null;
    allChatsLoaded = false;
    chatSubscription?.cancel();
    emit(const ChatInitial([]));
    _initListeners();
  }

  void _initListeners() {
    add(const ListenForNewChats());
    add(const FetchMore());
  }

  @override
  Future<void> close() async {
    await chatSubscription?.cancel();
    await connectivitySubscription?.cancel();
    return super.close();
  }

  FutureOr<void> _fetchMore(FetchMore event, Emitter<ChatState> emit) async {
    if (allChatsLoaded || _activeChatId == null) return;
    ChatPagination? _localPagination;
    emit(ChatFetchingMore(state.chats));

    final localRes = await _getChatsUseCase(
      GetChatParms(
        chatId: _activeChatId!,
        limit: 20,
        lastChatSentTime: _chatPagination?.lastMessageSentTime,
        localOnly: true,
      ),
    );
    localRes.fold((l) => log('Error fetching chats: ${l.message}'), (res) {
      final chats = res.data;
      _localPagination = res.pagination;

      emit(ChatLoaded(mergeChatList(state.chats, chats)));
    });

    final remoteRes = await _getChatsUseCase(
      GetChatParms(
        chatId: _activeChatId!,
        limit: 10,
        lastChatSentTime: _chatPagination?.lastMessageSentTime,
        localOnly: false,
      ),
    );
    remoteRes.fold(
      (l) {
        log('Error fetching remote chats: ${l.message}');
        _chatPagination = _localPagination;
      },
      (res) {
        final chats = res.data;
        _chatPagination = res.pagination;

        if (chats.isEmpty) {
          allChatsLoaded = true;
          return;
        }
        emit(ChatLoaded(mergeChatList(state.chats, chats)));
      },
    );
  }

  FutureOr<void> _sendChat(SendChat event, Emitter<ChatState> emit) async {
    if (_activeChatId == null || _userId == null) return;

    if (event.text.trim().isEmpty && (event.medias?.isEmpty ?? true)) return;
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

    Chat chat = Chat(
      id: const Uuid().v4(),
      msg: event.text.trim(),
      toId: _userId!,
      read: false,
      type: event.type,
      fromId: _currentUserId!,
      readTime: null,
      sentTime: DateTime.now(),
      status: MessageStatus.sending,
      replyTo: replyToChat,
      medias:
          event.medias
              ?.map(
                (e) => Media(
                  url: e,
                  type: event.mediaType!,
                  metadata: const MediaMetaData(),
                ),
              )
              .toList() ??
          [],
    );

    _replyCubit.cancelReply();

    final res = await _sendChatUseCase(chat);

    res.fold(
      (failure) => log('Error sending chats: ${failure.message}'),
      (message) => log('Chat sent: ${message.id}'),
    );
  }

  void _listenForNewChats() {
    if (_activeChatId == null) return;
    chatSubscription?.cancel();
    final res = _getChatStreamUseCase(_activeChatId!);
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

  void _handleNewChats(List<Chat> chats) {
    if (isClosed) return;
    add(StateEmitter(state: ChatLoaded(mergeChatList(state.chats, chats))));
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
    // Set<String> addedChatIds = {};

    while (i < oldChats.length && j < newChats.length) {
      final sentTime1 = oldChats[i].sentTime.millisecondsSinceEpoch;
      final sentTime2 = newChats[j].sentTime.millisecondsSinceEpoch;
      if (sentTime1 > sentTime2) {
        // if (!addedChatIds.contains(oldChats[i].id)) {
        mergedList.add(oldChats[i]);
        // addedChatIds.add(oldChats[i].id);
        // }
        i++;
      } else if (sentTime1 < sentTime2) {
        // if (!addedChatIds.contains(newChats[j].id)) {
        mergedList.add(newChats[j]);
        // addedChatIds.add(newChats[j].id);
        // }
        j++;
      } else {
        // if (!addedChatIds.contains(newChats[j].id)) {
        mergedList.add(newChats[j]);
        // addedChatIds.add(newChats[j].id);
        // }
        j++;
        i++;
      }
    }
    while (i < oldChats.length) {
      // if (!addedChatIds.contains(oldChats[i].id)) {
      mergedList.add(oldChats[i]);
      // addedChatIds.add(oldChats[i].id);
      // }
      i++;
    }
    while (j < newChats.length) {
      // if (!addedChatIds.contains(newChats[j].id)) {
      mergedList.add(newChats[j]);
      // addedChatIds.add(newChats[j].id);
      // }
      j++;
    }

    return mergedList;
  }
}
