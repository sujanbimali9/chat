import 'package:chat/core/common/model/media.dart';
import 'package:chat/src/chat/data/model/chat_metadata_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'media_model.g.dart';
part 'media_model.freezed.dart';

@freezed
class MediaModel with _$MediaModel {
  factory MediaModel({
    required final String url,
    required final MediaType type,
    required MediaMetaDataModel metadata,
  }) = _MediaModel;
  factory MediaModel.fromJson(Map<String, dynamic> json) =>
      _$MediaModelFromJson(json);

  factory MediaModel.fromMedia(Media media) => MediaModel(
        url: media.url,
        type: media.type,
        metadata: MediaMetaDataModel.fromMediaMetaData(media.metaData),
      );
}

enum MediaType {
  image,
  video,
  file;

  bool get isImage => this == MediaType.image;
  bool get isVideo => this == MediaType.video;
  bool get isFile => this == MediaType.file;
}
