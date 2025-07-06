import 'package:chat/core/common/model/media_metadata.dart';
import 'package:chat/src/chat/data/model/media_model.dart';
import 'package:equatable/equatable.dart';

class Media extends Equatable {
  final String url;
  final MediaType type;
  final MediaMetaData metaData;

  const Media({required this.url, required this.type, required this.metaData});

  @override
  List<Object?> get props => [url, type, metaData];

  Media copyWith({
    String? url,
    MediaType? type,
    MediaMetaData? metaData,
  }) {
    return Media(
      url: url ?? this.url,
      type: type ?? this.type,
      metaData: metaData ?? this.metaData,
    );
  }

  factory Media.fromMediaModel(MediaModel mediaModel) => Media(
        url: mediaModel.url,
        type: mediaModel.type,
        metaData: MediaMetaData.fromMediaMetaDataModel(mediaModel.metadata),
      );
}
