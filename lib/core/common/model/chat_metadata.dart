import 'package:equatable/equatable.dart';

class ChatMetaData extends Equatable {
  final double? aspectRatio;
  final String? thumbnail;
  final double? height;
  final double? width;
  final int? duration;
  final String? title;

  const ChatMetaData(
      {this.aspectRatio,
      this.thumbnail,
      this.height,
      this.width,
      this.duration,
      this.title});

  @override
  get props => [aspectRatio, thumbnail, height, width, duration, title];

  ChatMetaData copyWith({
    double? aspectRatio,
    String? thumbnail,
    double? height,
    double? width,
    int? duration,
    String? title,
  }) {
    return ChatMetaData(
      aspectRatio: aspectRatio ?? this.aspectRatio,
      thumbnail: thumbnail ?? this.thumbnail,
      height: height ?? this.height,
      width: width ?? this.width,
      duration: duration ?? this.duration,
      title: title ?? this.title,
    );
  }
}
