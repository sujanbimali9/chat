enum ChatType {
  text,
  media;

  bool get isText => this == ChatType.text;
  bool get isMedia => this == ChatType.media;
}
