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
import 'package:v_video_compressor/v_video_compressor.dart';

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
    ChatModel? chatModel;

    return await handleException(
      () async {
        chatModel = ChatModel.fromChat(chat);

        if (chatModel!.medias.isNotEmpty) {
          final processedMedia = await _processMediaMetadataParallel(
            chat.medias,
          );
          chatModel = chatModel!.copyWith(medias: processedMedia);
        }

        await _saveToLocalOnNoConnection(chatModel!);

        await _chatLocalDataSource.addChat(
          chatModel!.copyWith(status: MessageStatus.sending),
        );

        if (chatModel!.medias.isNotEmpty) {
          final uploadedMedia = await _uploadFilesParallel(
            chatModel!.medias,
            chat.chatId,
          );
          chatModel = chatModel!.copyWith(medias: uploadedMedia);
        }

        chatModel = chatModel!.copyWith(status: MessageStatus.sent);

        final result = await _chatRemoteDataSource.sendMessage(chatModel!);

        await _chatLocalDataSource.addChat(result);
        await _chatLocalDataSource.upsertConversation(result);

        return result;
      },
      context: 'sendChat',
      customErrorHandler: (e) {
        log(
          'SendMessage Error: $e, MessageType: ${chatModel?.type ?? "unknown"}',
        );
        return _handleSendChatError(chatModel ?? ChatModel.fromChat(chat));
      },
    );
  }

  Future<List<MediaModel>> _uploadFilesParallel(
    List<MediaModel> mediaModels,
    String chatId,
  ) async {
    final groupedMedia = _groupMediaByType(mediaModels);
    final uploadTasks = <Future<List<MediaModel>>>[];

    if (groupedMedia['images']!.isNotEmpty) {
      uploadTasks.add(
        _chatRemoteDataSource.sendImages(groupedMedia['images']!, chatId),
      );
    }

    if (groupedMedia['videos']!.isNotEmpty) {
      uploadTasks.add(
        _chatRemoteDataSource.sendVideos(groupedMedia['videos']!, chatId),
      );
    }

    if (groupedMedia['files']!.isNotEmpty) {
      uploadTasks.add(
        _chatRemoteDataSource.sendFiles(groupedMedia['files']!, chatId),
      );
    }

    if (uploadTasks.isEmpty) return [];

    final results = await Future.wait(uploadTasks);
    return results.expand((result) => result).toList();
  }

  Map<String, List<MediaModel>> _groupMediaByType(
    List<MediaModel> mediaModels,
  ) {
    final images = <MediaModel>[];
    final videos = <MediaModel>[];
    final files = <MediaModel>[];

    for (final media in mediaModels) {
      if (media.type.isImage) {
        images.add(media);
      } else if (media.type.isVideo) {
        videos.add(media);
      } else {
        files.add(media);
      }
    }

    return {'images': images, 'videos': videos, 'files': files};
  }

  Failure _handleSendChatError(ChatModel chatModel) {
    final failedChatModel = chatModel.copyWith(status: MessageStatus.failed);

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
  Future<Either<Failure, void>> removeChat(Chat chat) async {
    return await handleException(() async {
      final chatModel = ChatModel.fromChat(chat);
      final result = await _chatRemoteDataSource.removeChat(chatModel);
      await _chatLocalDataSource.removeChat(chatModel);
      return result;
    }, context: 'ChatRepositoryImp.removeChat');
  }

  @override
  Either<Failure, Stream<List<Chat>>> getChatsStream(String chatId) {
    try {
      final result = _chatLocalDataSource.getChatsStream(chatId);
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
        return await _chatLocalDataSource.getChats(
          chatId,
          limit: limit,
          lastMessageSentTime: lastMessageSentTime,
        );
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
      return result;
    }, context: 'ChatRepositoryImp.getPendingChat');
  }

  Future<void> _saveToLocalOnNoConnection(ChatModel chatModel) async {
    if (!_networkInfo.checkConnection()) {
      await _chatLocalDataSource.addChat(
        chatModel.copyWith(status: MessageStatus.failed),
      );
      await _chatLocalDataSource.upsertConversation(
        chatModel.copyWith(status: MessageStatus.failed),
      );
      throw const ServerException('No internet connection');
    }
  }

  Future<List<MediaModel>> _processMediaMetadataParallel(
    List<Media> medias,
  ) async {
    return Future.wait(medias.map(_processMediaWithMetadata));
  }

  Future<MediaModel> _processMediaWithMetadata(Media media) async {
    final fileType = _getFileType(media.url);
    final title = media.url.split('/').last;
    var metadata = media.metadata.copyWith(title: title);

    try {
      if (fileType.isImage) {
        final aspectRatio = await _getImageAspectRatio(media.url);
        metadata = metadata.copyWith(aspectRatio: aspectRatio);
      } else if (fileType.isVideo) {
        log('Generating thumbnail for video: ${media.url}');
        final thumbnail = await _getVideoThumbnail(media.url);
        log('Generated thumbnail at: $thumbnail');
        final aspectRatio = await _getImageAspectRatio(thumbnail);
        log('Video aspect ratio: $aspectRatio');
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

  MediaType _getFileType(String name) {
    final fileExtension = name.split('.').last;
    if (imageExtensions.contains(fileExtension)) {
      return MediaType.image;
    } else if (videoExtension.contains(fileExtension)) {
      return MediaType.video;
    } else {
      return MediaType.file;
    }
  }

  Future<double> _getImageAspectRatio(String imagePath) {
    return ImageMetadata.getImageAspectRatio(
      path: imagePath,
      extension: imagePath.split('.').last,
    );
  }

  Future<String> _getVideoThumbnail(String path) async {
    final thumbnail = await VVideoCompressor().getVideoThumbnail(
      path,
      VVideoThumbnailConfig.defaults(format: VThumbnailFormat.jpeg),
    );
    if (thumbnail == null) {
      throw Exception('Failed to generate video thumbnail');
    }
    return thumbnail.thumbnailPath;
  }
}
