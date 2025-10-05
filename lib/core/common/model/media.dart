import 'package:chat/core/common/model/media_metadata.dart';
import 'package:chat/src/chat/data/model/media_model.dart';

class Media {
  final String url;
  final MediaType type;
  final MediaMetaData metadata;

  const Media({required this.url, required this.type, required this.metadata});
}

extension MediaExtension on Media {
  Media copyWith({String? url, MediaType? type, MediaMetaData? metadata}) {
    return Media(
      url: url ?? this.url,
      type: type ?? this.type,
      metadata: metadata ?? this.metadata,
    );
  }
}
