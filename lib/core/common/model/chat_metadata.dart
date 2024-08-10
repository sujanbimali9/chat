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
}
