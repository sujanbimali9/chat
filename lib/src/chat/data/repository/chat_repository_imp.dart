import 'dart:async';
import 'dart:developer';
import 'package:chat/core/common/model/api_response.dart';
import 'package:chat/core/common/model/chat.dart';
import 'package:chat/core/common/model/media.dart';
import 'package:chat/core/common/model/media_metadata.dart';
import 'package:chat/core/common/model/pagination.dart';
import 'package:chat/core/exception/exception.dart';
import 'package:chat/core/failure/failure.dart';
import 'package:chat/core/mixins/exception_handler_mixin.dart';
import 'package:chat/utils/constant/app_constants.dart';
import 'package:chat/src/chat/data/data_source/chat_remote_data_source.dart';
import 'package:chat/src/chat/data/data_source/chat_local_data_source.dart';
import 'package:chat/src/chat/data/model/chat_model.dart';
import 'package:chat/src/chat/data/model/media_model.dart';
import 'package:chat/src/chat/domain/repository/chat_repository.dart';
import 'package:chat/utils/generator/list/extensions.dart';
import 'package:chat/utils/generator/media/image_metadata.dart';
import 'package:chat/utils/helper/network_info.dart';
import 'package:fpdart/fpdart.dart';
import 'package:chat/utils/helper/semaphore.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';

class ChatRepositoryImp with ExceptionHandlerMixin implements ChatRepository {
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
    return await handleException(
      () async {
        var chatModel = ChatModel.fromChat(chat);
        var mediaModel = <MediaModel>[];

        if (chat.medias.isNotEmpty) {
          mediaModel = await _processMediaMetadataParallel(chat.medias);
        }

        chatModel = ChatModel.fromChat(chat).copyWith(medias: mediaModel);

        await saveToLocalOnNoConnection(chatModel);

        await _chatLocalDataSource.addChat(
          chatModel.copyWith(status: MessageStatus.sending),
        );

        if (chat.medias.isNotEmpty) {
          mediaModel = await _uploadFilesParallel(mediaModel, chat.chatId);
          chatModel = chatModel.copyWith(medias: mediaModel);
        }

        chatModel = chatModel.copyWith(status: MessageStatus.sent);

        final result = await _chatRemoteDataSource.sendMessage(chatModel);

        await _chatLocalDataSource.addChat(result);
        await _chatLocalDataSource.upsertConversation(result);
        return result;
      },
      context: 'ChatRepositoryImp.sendChat',
      customErrorHandler: (e) {
        log(
          'SendMessage Error: $e, MessageType: ${ChatModel.fromChat(chat).type}',
        );
        return _handleSendChatError(ChatModel.fromChat(chat));
      },
    );
  }

  Future<List<MediaModel>> _processMediaMetadataParallel(
    List<Media> medias,
  ) async {
    final semaphore = Semaphore(AppConstants.maxMediaConcurrency);

    final futures = medias.map((media) async {
      await semaphore.acquire();
      try {
        return await _processMediaWithMetadata(media);
      } finally {
        semaphore.release();
      }
    });

    return await Future.wait(futures);
  }

  Future<MediaModel> _processMediaWithMetadata(Media media) async {
    final fileType = _fileType(media.url);
    final title = media.url.split('/').last;
    var metadata = media.metadata.copyWith(title: title);

    try {
      if (fileType.isImage) {
        final aspectRatio = await getImageAspectRatio(media.url);
        metadata = metadata.copyWith(aspectRatio: aspectRatio);
      } else if (fileType.isVideo) {
        final thumbnail = await getVideoThumbnail(media.url);
        final aspectRatio = await getImageAspectRatio(thumbnail);
        metadata = metadata.copyWith(
          thumbnail: thumbnail,
          aspectRatio: aspectRatio,
        );
      }
    } catch (e) {
      log(
        'Error processing media metadata: $e',
        name: 'ChatRepositoryImp._processMediaWithMetadata',
      );
    }

    return MediaModel.fromMedia(
      media.copyWith(type: fileType, metadata: metadata),
    );
  }

  Future<List<MediaModel>> _uploadFilesParallel(
    List<MediaModel> mediaModels,
    String chatId,
  ) async {
    final imageMedias = <MediaModel>[];
    final videoMedias = <MediaModel>[];
    final fileMedias = <MediaModel>[];

    for (final mediaModel in mediaModels) {
      if (mediaModel.type.isImage) {
        imageMedias.add(mediaModel);
      } else if (mediaModel.type.isVideo) {
        videoMedias.add(mediaModel);
      } else {
        fileMedias.add(mediaModel);
      }
    }

    final uploadTasks = <Future<List<MediaModel>>>[];

    if (imageMedias.isNotEmpty) {
      uploadTasks.add(_chatRemoteDataSource.sendImages(imageMedias, chatId));
    }
    if (videoMedias.isNotEmpty) {
      uploadTasks.add(_chatRemoteDataSource.sendVideos(videoMedias, chatId));
    }
    if (fileMedias.isNotEmpty) {
      uploadTasks.add(_chatRemoteDataSource.sendFiles(fileMedias, chatId));
    }

    if (uploadTasks.isEmpty) return [];

    final results = await Future.wait(uploadTasks);

    final allResults = <MediaModel>[];
    for (final result in results) {
      allResults.addAll(result);
    }

    return allResults;
  }

  Failure _handleSendChatError(ChatModel chatModel) {
    final failedChatModel = chatModel.copyWith(status: MessageStatus.failed);
    if (failedChatModel.medias.isNotEmpty) {
      return Failure('Cannot send message with media when offline');
    }

    _chatLocalDataSource.addChat(failedChatModel).catchError((e) {
      log(
        'Error saving failed chat locally: $e',
        name: 'ChatRepositoryImp._handleSendChatError',
      );
    });
    _chatLocalDataSource.upsertConversation(failedChatModel).catchError((e) {
      log(
        'Error updating conversation for failed chat: $e',
        name: 'ChatRepositoryImp._handleSendChatError',
      );
    });
    return Failure(ErrorMessages.messageSendFailed);
  }

  @override
  Future<Either<Failure, void>> removeChat(final Chat chat) async {
    return await handleException(() async {
      final chatModel = ChatModel.fromChat(chat);
      final result = await _chatRemoteDataSource.removeChat(chatModel);
      await _chatLocalDataSource.removeChat(chatModel);
      return result;
    }, context: 'ChatRepositoryImp.removeChat');
  }

  @override
  Either<Failure, Stream<Chat>> getChatsStream(String chatId) {
    try {
      final result = _chatRemoteDataSource.getChatsStream(chatId);
      return right(result);
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
    return await handleException(() async {
      if (localOnly) {
        final result = await _chatLocalDataSource.getChats(
          chatId,
          limit: limit,
          lastMessageSentTime: lastMessageSentTime,
        );
        return result;
      }

      final result = await _chatRemoteDataSource.getChats(
        chatId,
        limit: limit,
        lastMessagesentTime: lastMessageSentTime,
      );
      await _chatLocalDataSource.addChatsAll(result.data);
      return result;
    }, context: 'ChatRepositoryImp.getChats');
  }

  @override
  Future<Either<Failure, List<Chat>>> getPendingChat() async {
    return await handleException(() async {
      final result = await _chatLocalDataSource.getPendingChat();
      return result.toList();
    }, context: 'ChatRepositoryImp.getPendingChat');
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
    final thumbnail = await VideoThumbnail.thumbnailFile(
      video: path,
      imageFormat: ImageFormat.JPEG,
      quality: 100,
    );
    return thumbnail.path;
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
