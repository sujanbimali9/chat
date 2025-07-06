import 'dart:convert';

import 'package:chat/src/chat/data/model/media_model.dart';
import 'package:drift/drift.dart';

class MediaConverter extends TypeConverter<List<MediaModel>, String>
    with JsonTypeConverter<List<MediaModel>, String> {
  const MediaConverter();

  @override
  List<MediaModel> fromSql(String fromDb) {
    final data = jsonDecode(fromDb);
    return data.map<MediaModel>((e) => MediaModel.fromJson(e)).toList();
  }

  @override
  String toSql(List<MediaModel> value) {
    return jsonEncode(value.map((e) => e.toJson()).toList());
  }
}
