import 'package:chat/core/common/model/media.dart';
import 'package:chat/src/chat/data/model/chat_metadata_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'media_model.g.dart';
part 'media_model.freezed.dart';

@freezed
class MediaModel extends Media with _$MediaModel {
  factory MediaModel({
    required final String url,
    required final MediaMetaDataModel metadata,
    required final MediaType type,
  }) = _MediaModel;
  factory MediaModel.fromJson(Map<String, dynamic> json) =>
      _$MediaModelFromJson(json);

  factory MediaModel.fromMedia(Media e) {
    return MediaModel(
      url: e.url,
      type: e.type,
      metadata: MediaMetaDataModel.fromMediaMetaData(e.metadata),
    );
  }
}

enum MediaType {
  image,
  video,
  file;

  bool get isImage => this == MediaType.image;
  bool get isVideo => this == MediaType.video;
  bool get isFile => this == MediaType.file;
}
