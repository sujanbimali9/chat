import 'package:chat/core/common/model/chat.dart';
import 'package:chat/core/common/model/chat_metadata.dart';
import 'package:chat/core/enum/chat_type.dart';

class ChatModel extends Chat {
  ChatModel({
    required super.id,
    required super.msg,
    required super.toId,
    required super.read,
    required super.type,
    required super.fromId,
    required super.readTime,
    required super.sentTime,
    required ChatMetaDataModel? metadata,
    required super.status,
  }) : super(metadata: metadata);

  ChatModel.fromChat(Chat chat)
      : this(
          id: chat.id,
          msg: chat.msg,
          toId: chat.toId,
          read: chat.read,
          type: chat.type,
          fromId: chat.fromId,
          readTime: chat.readTime,
          sentTime: chat.sentTime,
          metadata: chat.metadata != null
              ? ChatMetaDataModel.fromChatMetaData(chat.metadata!)
              : null,
          status: chat.status,
        );

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'],
      msg: json['msg'],
      toId: json['to_id'],
      read: json['read'],
      type: getChatType(json['type']),
      fromId: json['from_id'],
      readTime: json['read_time'],
      sentTime: json['sent_time'],
      metadata: json['metadata'] != null
          ? ChatMetaDataModel.fromJson(json['metadata'])
          : null,
      status: getMessageStatus(json['status']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chat_id': chatId,
      'msg': msg,
      'to_id': toId,
      'read': read,
      'type': type.name,
      'from_id': fromId,
      'read_time': readTime,
      'sent_time': sentTime,
      'metadata': (metadata as ChatMetaDataModel?)?.toJson(),
      'status': status.name,
    };
  }

  @override
  ChatModel copyWith({
    String? id,
    String? msg,
    String? toId,
    bool? read,
    ChatType? type,
    String? fromId,
    int? readTime,
    int? sentTime,
    ChatMetaData? metadata,
    MessageStatus? status,
  }) {
    return ChatModel(
      id: id ?? this.id,
      msg: msg ?? this.msg,
      toId: toId ?? this.toId,
      read: read ?? this.read,
      type: type ?? this.type,
      fromId: fromId ?? this.fromId,
      readTime: readTime ?? this.readTime,
      sentTime: sentTime ?? this.sentTime,
      metadata: metadata != null
          ? ChatMetaDataModel.fromChatMetaData(metadata)
          : this.metadata as ChatMetaDataModel?,
      status: status ?? this.status,
    );
  }
}

class ChatMetaDataModel extends ChatMetaData {
  const ChatMetaDataModel({
    super.aspectRatio,
    super.duration,
    super.height,
    super.thumbnail,
    super.title,
    super.width,
  });

  factory ChatMetaDataModel.fromJson(Map<String, dynamic> json) {
    return ChatMetaDataModel(
      aspectRatio: json['aspect_ratio'],
      duration: json['duration'],
      height: json['height'],
      thumbnail: json['thumbnail'],
      title: json['title'],
      width: json['width'],
    );
  }
  factory ChatMetaDataModel.fromChatMetaData(ChatMetaData chatMetaData) {
    return ChatMetaDataModel(
      aspectRatio: chatMetaData.aspectRatio,
      duration: chatMetaData.duration,
      height: chatMetaData.height,
      thumbnail: chatMetaData.thumbnail,
      title: chatMetaData.title,
      width: chatMetaData.width,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'aspect_ratio': aspectRatio,
      'duration': duration,
      'height': height,
      'thumbnail': thumbnail,
      'title': title,
      'width': width,
    };
  }

  @override
  ChatMetaDataModel copyWith(
      {double? aspectRatio,
      int? duration,
      double? height,
      String? thumbnail,
      String? title,
      double? width}) {
    return ChatMetaDataModel(
      aspectRatio: aspectRatio ?? this.aspectRatio,
      duration: duration ?? this.duration,
      height: height ?? this.height,
      thumbnail: thumbnail ?? this.thumbnail,
      title: title ?? this.title,
      width: width ?? this.width,
    );
  }
}
