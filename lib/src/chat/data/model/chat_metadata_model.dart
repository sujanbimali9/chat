import 'package:chat/core/common/model/media_metadata.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_metadata_model.freezed.dart';
part 'chat_metadata_model.g.dart';

@freezed
class MediaMetaDataModel with _$MediaMetaDataModel {
  factory MediaMetaDataModel({
    final double? aspectRatio,
    final String? thumbnail,
    final double? height,
    final double? width,
    final int? duration,
    final String? title,
  }) = _ChatMetaDataModel;

  factory MediaMetaDataModel.fromJson(Map<String, dynamic> json) =>
      _$MediaMetaDataModelFromJson(json);

  factory MediaMetaDataModel.fromMediaMetaData(MediaMetaData chatMetaData) =>
      MediaMetaDataModel(
        aspectRatio: chatMetaData.aspectRatio,
        duration: chatMetaData.duration,
        height: chatMetaData.height,
        thumbnail: chatMetaData.thumbnail,
        title: chatMetaData.title,
        width: chatMetaData.width,
      );
}
