import 'dart:async';
import 'dart:developer';
import 'dart:isolate';
import 'package:bloc/bloc.dart';
import 'package:chat/core/common/model/chat.dart';
import 'package:chat/core/common/model/chat_metadata.dart';
import 'package:chat/core/enum/chat_type.dart';
import 'package:chat/src/chat/domain/usecase/get_chat.dart';
import 'package:chat/src/chat/domain/usecase/get_chat_stream.dart';
import 'package:chat/src/chat/domain/usecase/remove_chat.dart';
import 'package:chat/src/chat/domain/usecase/send_audio.dart';
import 'package:chat/src/chat/domain/usecase/send_file.dart';
import 'package:chat/src/chat/domain/usecase/send_image.dart';
import 'package:chat/src/chat/domain/usecase/send_text.dart';
import 'package:chat/src/chat/domain/usecase/send_video.dart';
import 'package:chat/utils/generator/id_generator.dart';
import 'package:chat/utils/generator/list/extensions.dart';
import 'package:chat/utils/generator/media/image_metadata.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetChatStreamUseCase _getChatStreamUseCase;
  final RemoveChatUseCase _removeChatUseCase;
  final SendAudioUseCase _sendAudioUseCase;
  final SendVideoUseCase _sendVideoUseCase;
  final SendTextUseCase _sendTextUseCase;
  final SendImageUseCase _sendImageUseCase;
  final SendFileUseCase _sendFileUseCase;
  final GetChatUseCase _getChatsUseCase;
  final String _chatId;
  final String _userId;
  final String _currentUserId;
  bool allChatsLoaded = false;
  bool fetchingMore = false;
  int? _lastDocId;
  StreamSubscription<Map<int, Chat>>? chatSubscription;
  StreamSubscription? connectivitySubscription;

  ChatBloc(
    GetChatStreamUseCase getChatStreamUseCase,
    RemoveChatUseCase removeChatUseCase,
    SendAudioUseCase sendAudioUseCase,
    SendVideoUseCase sendVideoUseCase,
    SendTextUseCase sendTextUseCase,
    SendImageUseCase sendImageUseCase,
    SendFileUseCase sendFileUseCase,
    GetChatUseCase getChatUseCase, {
    required String userId,
    required String currentUserId,
  })  : _getChatStreamUseCase = getChatStreamUseCase,
        _removeChatUseCase = removeChatUseCase,
        _sendAudioUseCase = sendAudioUseCase,
        _sendVideoUseCase = sendVideoUseCase,
        _sendTextUseCase = sendTextUseCase,
        _sendImageUseCase = sendImageUseCase,
        _sendFileUseCase = sendFileUseCase,
        _getChatsUseCase = getChatUseCase,
        _currentUserId = currentUserId,
        _userId = userId,
        _chatId = IdGenerator.getConversionId(userId, currentUserId),
        super(ChatState.initial()) {
    on<FetchMessagesEvent>(_onFetchMessages);
    on<SendFileEvent>(_onSendFile);
    on<SendAudioEvent>(_onSendAudio);
    on<SendTextEvent>(_onSendText);
    on<SendImageEvent>(_onSendImage);
    on<SendVideoEvent>(_onSendVideo);
    on<RemoveChatEvent>(_onRemoveChat);
    on<_StateEmitter>(
      (event, emit) async {
        try {
          await Future.delayed(const Duration(seconds: 1), () {
            if (!isClosed) emit(event.state);
          });
        } catch (e) {
          log(e.toString());
        }
      },
    );
    add(const FetchMessagesEvent(limit: 20));
    _listenForNewChats(limit: 5);
    _listenForConnectivity();
    Future<void> close() async {
      chatSubscription?.cancel();
      connectivitySubscription?.cancel();
      super.close();
    }
  }

  Future<void> _onFetchMessages(
      FetchMessagesEvent event, Emitter<ChatState> emit) async {
    if (allChatsLoaded || fetchingMore) return;
    fetchingMore = true;
    emit(state.copyWith(fetchingMore: true));
    await Future.delayed(const Duration(seconds: 2), () async {
      final result = await _getChatsUseCase(GetChatParms(
        chatId: _chatId,
        limit: event.limit,
        offset: _lastDocId,
      ));
      result.fold(
        (failure) {
          emit(state.copyWith(
            fetchingMore: false,
            error: failure.message,
          ));
        },
        (chats) {
          emit(state.copyWith(
            chats: {...state.chats, ...chats},
            fetchingMore: false,
          ));
          if (chats.isEmpty || chats.values.length < event.limit) {
            allChatsLoaded = true;
          } else {
            _lastDocId = state.chats.length;
          }
        },
      );
    });
    fetchingMore = false;
  }

  Future<void> _onSendFile(SendFileEvent event, Emitter<ChatState> emit) async {
    final fileType = _fileType(event.path);
    if (fileType.isImage) {
      add(SendImageEvent(event.path, chat: event.chat));
      return;
    } else if (fileType.isVideo) {
      add(SendVideoEvent(event.path, chat: event.chat));
      return;
    } else if (fileType.isAudio) {
      add(SendAudioEvent(event.path, chat: event.chat));
      return;
    } else {
      final chat = event.chat ??
          Chat(
            id: const Uuid().v4(),
            msg: event.path,
            toId: _userId,
            read: false,
            type: ChatType.file,
            fromId: _currentUserId,
            readTime: null,
            sentTime: DateTime.now().millisecondsSinceEpoch,
            metadata: ChatMetaData(title: event.path.split('/').last),
            status: MessageStatus.sending,
          );
      emit(state.copyWith(
        chats: {chat.sentTime: chat, ...state.chats},
      ));
      final res =
          await _sendFileUseCase(chat.copyWith(status: MessageStatus.sent));
      log(res.toString());
      res.fold(
        (failure) {
          emit(state.copyWith(
            chats: {
              ...state.chats,
              chat.sentTime: chat.copyWith(status: MessageStatus.failed),
            },
            pendingChats: {
              ...?state.pendingChats,
              chat.sentTime: chat.copyWith(status: MessageStatus.failed),
            },
          ));
        },
        (chat) {
          emit(state.copyWith(
            chats: {...state.chats, chat.sentTime: chat},
          ));
        },
      );
    }
  }

  Future<void> _onSendText(SendTextEvent event, Emitter<ChatState> emit) async {
    final chat = event.chat ??
        Chat(
          id: const Uuid().v4(),
          msg: event.text,
          toId: _userId,
          read: false,
          type: ChatType.text,
          fromId: _currentUserId,
          readTime: null,
          sentTime: DateTime.now().millisecondsSinceEpoch,
          metadata: null,
          status: MessageStatus.sending,
        );
    emit(state.copyWith(
      chats: {chat.sentTime: chat, ...state.chats},
    ));
    final res =
        await _sendTextUseCase(chat.copyWith(status: MessageStatus.sent));
    log(res.toString());

    res.fold(
      (failure) {
        emit(state.copyWith(
          chats: {
            ...state.chats,
            chat.sentTime: chat.copyWith(status: MessageStatus.failed),
          },
          pendingChats: {
            chat.sentTime: chat.copyWith(status: MessageStatus.failed),
            ...?state.pendingChats,
          },
        ));
      },
      (chat) {
        emit(state.copyWith(
          chats: {
            ...state.chats,
            chat.sentTime: chat,
          },
        ));
      },
    );
  }

  Future<void> _onSendImage(
      SendImageEvent event, Emitter<ChatState> emit) async {
    final double aspectRatio = await getImageAspectRatio(event.path);
    final title = event.path.split('/').last;
    final chat = event.chat ??
        Chat(
          id: const Uuid().v4(),
          msg: event.path,
          toId: _userId,
          read: false,
          type: ChatType.image,
          fromId: _currentUserId,
          readTime: null,
          sentTime: DateTime.now().millisecondsSinceEpoch,
          metadata: ChatMetaData(
            aspectRatio: aspectRatio,
            title: title,
          ),
          status: MessageStatus.sending,
        );

    emit(state.copyWith(
      chats: {chat.sentTime: chat, ...state.chats},
    ));

    final res =
        await _sendImageUseCase(chat.copyWith(status: MessageStatus.sent));

    res.fold(
      (failure) {
        emit(state.copyWith(
          chats: {
            ...state.chats,
            chat.sentTime: chat.copyWith(status: MessageStatus.failed),
          },
          pendingChats: {
            ...?state.pendingChats,
            chat.sentTime: chat.copyWith(status: MessageStatus.failed),
          },
        ));
      },
      (chat) {
        emit(state.copyWith(
          chats: {...state.chats, chat.sentTime: chat},
        ));
      },
    );
  }

  Future<void> _onSendVideo(
      SendVideoEvent event, Emitter<ChatState> emit) async {
    var chat = event.chat ??
        Chat(
          id: const Uuid().v4(),
          msg: event.path,
          toId: _userId,
          read: false,
          type: ChatType.video,
          fromId: _currentUserId,
          readTime: null,
          sentTime: DateTime.now().millisecondsSinceEpoch,
          status: MessageStatus.sending,
        );
    final String title = event.path.split('/').last;
    final thumbnail = await getVideoThumbnail(event.path);
    final double aspectRatio = await getImageAspectRatio(thumbnail);

    chat = chat.copyWith(
      metadata: ChatMetaData(
        aspectRatio: aspectRatio,
        title: title,
        thumbnail: getImageUrl(title, chat.chatId),
      ),
    );
    emit(state.copyWith(
      chats: {chat.sentTime: chat, ...state.chats},
    ));
    final res =
        await _sendVideoUseCase(chat.copyWith(status: MessageStatus.sent));
    log(res.toString());

    res.fold(
      (failure) {
        emit(state.copyWith(
          chats: {
            ...state.chats,
            chat.sentTime: chat.copyWith(status: MessageStatus.failed),
          },
          pendingChats: {
            ...?state.pendingChats,
            chat.sentTime: chat.copyWith(status: MessageStatus.failed),
          },
        ));
      },
      (chat) {
        emit(state.copyWith(
          chats: {...state.chats, chat.sentTime: chat},
        ));
      },
    );
  }

  FutureOr<void> _onSendAudio(
      SendAudioEvent event, Emitter<ChatState> emit) async {
    final chat = event.chat ??
        Chat(
          id: const Uuid().v4(),
          msg: event.path,
          toId: _userId,
          read: false,
          type: ChatType.audio,
          fromId: _currentUserId,
          readTime: null,
          sentTime: DateTime.now().millisecondsSinceEpoch,
          metadata: ChatMetaData(
              title: event.path.split('/').last, duration: event.duration!),
          status: MessageStatus.sending,
        );
    emit(state.copyWith(
      chats: {chat.sentTime: chat, ...state.chats},
    ));
    final res =
        await _sendAudioUseCase(chat.copyWith(status: MessageStatus.sent));
    res.fold(
      (failure) {
        emit(state.copyWith(
          chats: {
            ...state.chats,
            chat.sentTime: chat.copyWith(status: MessageStatus.failed),
          },
          pendingChats: {
            ...?state.pendingChats,
            chat.sentTime: chat.copyWith(status: MessageStatus.failed),
          },
        ));
      },
      (chat) {
        emit(state.copyWith(
          chats: {...state.chats, chat.sentTime: chat},
        ));
      },
    );
  }

  void _listenForNewChats({int? limit}) {
    try {
      final res =
          _getChatStreamUseCase(GetChatParms(chatId: _chatId, limit: limit));

      res.fold(
        (failure) {
          log('Failure in getting data:${failure.message}');
        },
        (success) {
          try {
            chatSubscription = success.listen(
              (chat) {
                if (isClosed) return;
                final newChat = <int, Chat>{};
                final updatedChats = <int, Chat>{};

                chat.forEach((key, value) {
                  if (state.chats[key] != null) {
                    updatedChats[key] = value;
                  } else {
                    newChat[key] = value;
                  }
                });

                // for (final entry in chat.entries) {
                //   final chat = entry.value;
                //   if (state.chats[entry.key] != null) {
                //     updatedChats[entry.key] = chat;
                //   } else {
                //     newChat[entry.key] = chat;
                //   }
                // }
                add(_StateEmitter(
                    state: state.copyWith(
                  chats: {...newChat, ...state.chats, ...updatedChats},
                )));
              },
            );
          } catch (e) {
            log('Error in getting data: $e');
          }
        },
      );
    } catch (e) {
      log('Listen for chat error: ${e.toString()}');
    }
  }

  void _listenForConnectivity() {
    try {
      connectivitySubscription =
          Connectivity().onConnectivityChanged.listen((e) {
        if (e.contains(ConnectivityResult.none)) {
          chatSubscription?.cancel();
          chatSubscription = null;
        } else if (chatSubscription == null) {
          _listenForNewChats();
          if (state.pendingChats?.isNotEmpty ?? false) {
            _retryPendingChats();
          }
        }
      });
    } catch (e) {
      log('Connectivity error: $e');
    }
  }

  ChatType _fileType(String name) {
    final fileExtension = name.split('.').last;
    if (imageExtensions.contains(fileExtension)) {
      return ChatType.image;
    } else if (videoExtension.contains(fileExtension)) {
      return ChatType.video;
    } else {
      return ChatType.file;
    }
  }

  Future<double> getImageAspectRatio(String compressedImage) {
    final aspectRatio = ImageMetadata.getImageAspectRatio(
        path: compressedImage, extension: compressedImage.split('.').last);
    return aspectRatio;
  }

  Future<String> getVideoThumbnail(String path) async {
    final receivePort = ReceivePort();
    await Isolate.spawn(_getVideoThumbnailIsolate, receivePort.sendPort);
    final sendPort = await receivePort.first as SendPort;
    final resultPort = ReceivePort();
    final rootToken = RootIsolateToken.instance!;
    sendPort.send([path, resultPort.sendPort, rootToken]);
    final thumbnail = await resultPort.first as String?;
    if (thumbnail == null) {
      throw Exception('Failed to get video thumbnail');
    }
    return thumbnail;
  }

  static void _getVideoThumbnailIsolate(SendPort sendPort) async {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    final List message = await receivePort.first;
    final String path = message[0];
    final SendPort responsePort = message[1];
    final rootToken = message[2];
    BackgroundIsolateBinaryMessenger.ensureInitialized(rootToken);
    try {
      final thumbnail = await VideoThumbnail.thumbnailFile(
        video: path,
        imageFormat: ImageFormat.JPEG,
        quality: 100,
      );
      responsePort.send(thumbnail);
    } catch (e) {
      responsePort.send(null);
    }
  }

  String getImageUrl(String title, String chatId) {
    return 'https: //mvjqpjnwibunwedtogmw.supabase.co/storage/v1/object/public/chat/$chatId/image/$title';
  }

  FutureOr<void> _onRemoveChat(
      RemoveChatEvent event, Emitter<ChatState> emit) async {
    emit(state.copyWith(
      chats: state.chats..remove(event.chat.sentTime),
    ));
    final res = await _removeChatUseCase(event.chat);
    res.fold(
      (failure) {
        emit(state.copyWith(
          chats: state.chats
            ..putIfAbsent(event.chat.sentTime, () => event.chat),
        ));
      },
      (chat) {},
    );
  }

  void _retryPendingChats() async {
    state.pendingChats!.forEach((id, chat) async {
      await Future.delayed(const Duration(seconds: 2));
      switch (chat.type) {
        case ChatType.audio:
          add(SendAudioEvent(chat.msg, chat: chat));
        case ChatType.file:
          add(SendFileEvent(chat.msg, chat: chat));
        case ChatType.video:
          add(SendVideoEvent(chat.msg, chat: chat));
        case ChatType.image:
          add(SendImageEvent(chat.msg, chat: chat));
        case ChatType.text:
          add(SendTextEvent(chat.msg, chat: chat));
      }
    });
  }
}
