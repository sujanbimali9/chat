import 'dart:async';
import 'dart:developer';
import 'dart:isolate';
import 'package:chat/core/common/model/api_response.dart';
import 'package:chat/core/common/model/chat.dart';
import 'package:chat/core/common/model/media.dart';
import 'package:chat/core/common/model/pagination.dart';
import 'package:chat/core/exception/exception.dart';
import 'package:chat/core/failure/failure.dart';
import 'package:chat/src/chat/data/data_source/chat_remote_data_source.dart';
import 'package:chat/src/chat/data/data_source/chat_local_data_source.dart';
import 'package:chat/src/chat/data/model/chat_model.dart';
import 'package:chat/src/chat/data/model/media_model.dart';
import 'package:chat/src/chat/domain/repository/chat_repository.dart';
import 'package:chat/utils/generator/list/extensions.dart';
import 'package:chat/utils/generator/media/image_metadata.dart';
import 'package:chat/utils/helper/network_info.dart';
import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';

class ChatRepositoryImp implements ChatRepository {
  final ChatRemoteDataSource _chatRemoteDataSource;
  final ChatLocalDataSource _chatLocalDataSource;
  final NetworkInfo _networkInfo;

  ChatRepositoryImp(
    this._chatRemoteDataSource,
    this._chatLocalDataSource,
    this._networkInfo,
  );
  @override
  Future<Either<Failure, Chat>> sendChat(Chat chat) async {
    var chatModel = ChatModel.fromChat(chat);
    try {
      var mediaModel = <MediaModel>[];

      for (var media in chat.medias) {
        final fileType = _fileType(media.url);
        mediaModel.add(MediaModel.fromMedia(media.copyWith(type: fileType)));
      }
      var chatModel = ChatModel.fromChat(chat).copyWith(medias: mediaModel);
      await saveToLocalOnNoConnection(chatModel);
      await _chatLocalDataSource.addChat(
        chatModel.copyWith(status: MessageStatus.sending),
      );

      if (chat.medias.isNotEmpty) {
        mediaModel = await sendFiles(chat.medias, chat.chatId);
      }

      chatModel = chatModel.copyWith(
        medias: mediaModel,
        status: MessageStatus.sent,
      );

      final result = await _chatRemoteDataSource.sendMessage(chatModel);

      await _chatLocalDataSource.addChat(result);
      await _chatLocalDataSource.addLastChat(result);
      return right(Chat.fromChatModel(result));
    } on ServerException catch (e) {
      log(
        'SendMessage Error: ServerException, MesssageType: ${chatModel.type} - ${e.message}',
      );
      return saveOnError(chatModel);
    } catch (e) {
      log('SendMessage Error: $e , MesssageType: ${chatModel.type}');
      return left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, Chat>> saveOnError(ChatModel chatModel) async {
    final failedChatModel = chatModel.copyWith(status: MessageStatus.failed);
    try {
      await _chatLocalDataSource.addChat(failedChatModel);
      await _chatLocalDataSource.addLastChat(failedChatModel);
      return left(Failure('Failed to send message'));
    } on ServerException catch (e) {
      log('SendMessage Error: ${e.message}, MesssageType: ${chatModel.type}');
      return left(Failure(e.toString()));
    } catch (e) {
      log('SendMessage Error: $e , MesssageType: ${chatModel.type}');
      return left(Failure(e.toString()));
    }
  }

  Future<List<MediaModel>> sendImages(List<Media> medias, String chatId) async {
    final mediaModels = <MediaModel>[];
    for (final media in medias) {
      final title = media.url.split('/').last;
      final aspectRatio = await getImageAspectRatio(media.url);
      final mediaModel = MediaModel.fromMedia(
        media.copyWith(
          metaData: media.metaData.copyWith(
            title: title,
            aspectRatio: aspectRatio,
          ),
        ),
      );
      mediaModels.add(mediaModel);
    }

    return await _chatRemoteDataSource.sendImages(mediaModels, chatId);
  }

  Future<MediaModel> sendAudio(Media media, String chatId) async {
    final title = media.url.split('/').last;
    final mediaModel = MediaModel.fromMedia(
      media.copyWith(metaData: media.metaData.copyWith(title: title)),
    );

    return await _chatRemoteDataSource.sendAudio(mediaModel, chatId);
  }

  Future<List<MediaModel>> sendVideos(List<Media> medias, String chatId) async {
    final mediaModels = <MediaModel>[];
    final videoThumbnails = <String>[];
    final imageAspectRatiosFuture = <Future<double>>[];
    final titles = <String>[];
    for (final media in medias) {
      imageAspectRatiosFuture.add(
        getVideoThumbnail(media.url).then((value) {
          videoThumbnails.add(value);
          return getImageAspectRatio(value);
        }),
      );
      final title = media.url.split('/').last;
      titles.add(title);
    }
    final imageAspectRatios = await Future.wait(imageAspectRatiosFuture);
    for (int i = 0; i < medias.length; i++) {
      final mediaModel = MediaModel.fromMedia(
        medias[i].copyWith(
          metaData: medias[i].metaData.copyWith(
            thumbnail: videoThumbnails[i],
            aspectRatio: imageAspectRatios[i],
            title: titles[i],
          ),
        ),
      );
      mediaModels.add(mediaModel);
    }
    return await _chatRemoteDataSource.sendVideos(mediaModels, chatId);
  }

  Future<List<MediaModel>> sendFiles(List<Media> medias, chatId) async {
    final imageMedias = <Media>[];
    final videoMedias = <Media>[];
    final fileMedias = <MediaModel>[];
    final result = <MediaModel>[];

    for (final media in medias) {
      final fileType = _fileType(media.url);
      final title = media.url.split('/').last;
      final metaData = media.metaData.copyWith(title: title);
      final mediaItem = media.copyWith(type: fileType, metaData: metaData);
      final mediaModel = MediaModel.fromMedia(mediaItem);
      if (fileType.isImage) {
        imageMedias.add(mediaItem);
      } else if (fileType.isVideo) {
        videoMedias.add(mediaItem);
      } else {
        fileMedias.add(mediaModel);
      }
    }

    if (imageMedias.isNotEmpty) {
      final res = await sendImages(imageMedias, chatId);
      result.addAll(res);
    }
    if (videoMedias.isNotEmpty) {
      final res = await sendVideos(videoMedias, chatId);
      result.addAll(res);
    }

    if (fileMedias.isNotEmpty) {
      final res = await _chatRemoteDataSource.sendFiles(fileMedias, chatId);
      result.addAll(res);
    }

    return result;
  }

  @override
  Future<Either<Failure, void>> removeChat(final Chat chat) async {
    try {
      final chatModel = ChatModel.fromChat(chat);
      final result = await _chatRemoteDataSource.removeChat(chatModel);
      await _chatLocalDataSource.removeChat(chatModel);
      return right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Either<Failure, Stream<Chat>> getChatsStream(String chatId) {
    try {
      final result = _chatRemoteDataSource.getChatsStream(chatId);
      return right(result.map(Chat.fromChatModel));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ApiResponse<Chat, ChatPagination>>> getChats(
    String chatId, {
    required int limit,
    required int? lastMessageSentTime,
    required bool localOnly,
  }) async {
    try {
      if (localOnly) {
        final result = await _chatLocalDataSource.getChats(
          chatId,
          limit: limit,
          lastMessageSentTime: lastMessageSentTime,
        );
        return right(result.map(Chat.fromChatModel));
      }

      final result = await _chatRemoteDataSource.getChats(
        chatId,
        limit: limit,
        lastMessagesentTime: lastMessageSentTime,
      );
      await _chatLocalDataSource.addChatsAll(result.data);
      return right(result.map(Chat.fromChatModel));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Chat>>> getPendingChat() async {
    try {
      final result = await _chatLocalDataSource.getPendingChat();
      return right(result.map(Chat.fromChatModel).toList());
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  MediaType _fileType(String name) {
    final fileExtension = name.split('.').last;
    if (imageExtensions.contains(fileExtension)) {
      return MediaType.image;
    } else if (videoExtension.contains(fileExtension)) {
      return MediaType.video;
    } else {
      return MediaType.file;
    }
  }

  Future<double> getImageAspectRatio(String compressedImage) {
    final aspectRatio = ImageMetadata.getImageAspectRatio(
      path: compressedImage,
      extension: compressedImage.split('.').last,
    );
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
      responsePort.send(thumbnail.path);
    } catch (e) {
      responsePort.send(null);
    }
  }

  Future<void> saveToLocalOnNoConnection(ChatModel chatModel) async {
    if (!_networkInfo.checkConnection()) {
      await _chatLocalDataSource.addPending(
        chatModel.copyWith(status: MessageStatus.failed),
      );
      throw const ServerException('No internet connection');
    }
  }
}
