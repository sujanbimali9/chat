enum ChatType {
  text,
  image,
  video,
  audio,
  file,
}

extension ChatTypeX on ChatType {
  bool get isText => this == ChatType.text;
  bool get isImage => this == ChatType.image;
  bool get isVideo => this == ChatType.video;
  bool get isAudio => this == ChatType.audio;
  bool get isFile => this == ChatType.file;
}

getChatType(String type) {
  switch (type) {
    case 'text':
      return ChatType.text;
    case 'image':
      return ChatType.image;
    case 'video':
      return ChatType.video;
    case 'audio':
      return ChatType.audio;
    case 'file':
      return ChatType.file;
    default:
      return ChatType.text;
  }
}
