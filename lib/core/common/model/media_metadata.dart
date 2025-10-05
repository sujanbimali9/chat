class MediaMetaData {
  final double? aspectRatio;
  final String? thumbnail;
  final double? height;
  final double? width;
  final int? duration;
  final String? title;

  const MediaMetaData({
    this.aspectRatio,
    this.thumbnail,
    this.height,
    this.width,
    this.duration,
    this.title,
  });
}

extension MediaMetaDataX on MediaMetaData {
  MediaMetaData copyWith({
    double? aspectRatio,
    String? thumbnail,
    double? height,
    double? width,
    int? duration,
    String? title,
  }) {
    return MediaMetaData(
      aspectRatio: aspectRatio ?? this.aspectRatio,
      thumbnail: thumbnail ?? this.thumbnail,
      height: height ?? this.height,
      width: width ?? this.width,
      duration: duration ?? this.duration,
      title: title ?? this.title,
    );
  }
}
