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
import 'package:chat/src/chat/domain/usecase/update_read.dart';
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
  final UpdateReadUseCase _updateReadUseCase;
  final Connectivity _connectivity;
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
    Connectivity connectivity,
    SendTextUseCase sendTextUseCase,
    SendImageUseCase sendImageUseCase,
    SendFileUseCase sendFileUseCase,
    UpdateReadUseCase updateReadUseCase,
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
        _connectivity = connectivity,
        _updateReadUseCase = updateReadUseCase,
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
    on<UpdateReadEvent>(_updateRead);
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
    add(UpdateReadEvent(_chatId));
    add(const FetchMessagesEvent(limit: 20));
    _listenForNewChats(limit: 5);
    _listernForConnectivity();
  }

  Future<void> _onFetchMessages(
      FetchMessagesEvent event, Emitter<ChatState> emit) async {
    if (allChatsLoaded || fetchingMore) return;
    fetchingMore = true;
    emit(state.copyWith(fetchingMore: true));

    await Future.delayed(Duration(seconds: state.chats.isEmpty ? 0 : 2),
        () async {
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
      add(SendImageEvent(event.path));
      return;
    } else if (fileType.isVideo) {
      add(SendVideoEvent(event.path));
      return;
    } else if (fileType.isAudio) {
      add(SendAudioEvent(event.path));
      return;
    } else {
      final chat = Chat(
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
      res.fold(
        (failure) {
          handleSendError(emit, chat);
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
    final chat = Chat(
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

    res.fold(
      (failure) {
        handleSendError(emit, chat);
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
    final chat = Chat(
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
        handleSendError(emit, chat);
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
    var chat = Chat(
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
          aspectRatio: aspectRatio, title: title, thumbnail: thumbnail),
    );
    emit(state.copyWith(
      chats: {chat.sentTime: chat, ...state.chats},
    ));
    final res =
        await _sendVideoUseCase(chat.copyWith(status: MessageStatus.sent));
    res.fold(
      (failure) {
        handleSendError(emit, chat);
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
    final chat = Chat(
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
        handleSendError(emit, chat);
      },
      (chat) {
        emit(state.copyWith(
          chats: {...state.chats, chat.sentTime: chat},
        ));
      },
    );
  }

  void _listenForNewChats({int? limit}) {
    final res =
        _getChatStreamUseCase(GetChatParms(chatId: _chatId, limit: limit));

    res.fold(
      (failure) {
        log('Failure in getting data:${failure.message}');
      },
      (success) {
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
            add(_StateEmitter(
                state: state.copyWith(
              chats: {...newChat, ...state.chats, ...updatedChats},
            )));
          },
          onError: (value) {
            chatSubscription?.cancel();
            chatSubscription = null;
            log('Error in getting data $value');
          },
        );
      },
    );
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

  void handleSendError(Emitter<ChatState> emit, Chat chat) {
    emit(state.copyWith(
      chats: {
        ...state.chats,
        chat.sentTime: chat.copyWith(status: MessageStatus.failed),
      },
    ));
  }

  FutureOr<void> _updateRead(
      UpdateReadEvent event, Emitter<ChatState> emit) async {
    await _updateReadUseCase(event.chatId);
  }

  void _listernForConnectivity() {
    _connectivity.onConnectivityChanged.listen((event) {
      if (!event.contains(ConnectivityResult.none)) {
        chatSubscription?.cancel();
        _listenForNewChats();
      } else {
        chatSubscription?.cancel();
      }
    });
  }
}
