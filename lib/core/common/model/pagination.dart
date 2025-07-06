import 'package:equatable/equatable.dart';

class Pagination extends Equatable {
  final int offset;
  final int limit;
  final int total;
  const Pagination({
    required this.offset,
    required this.limit,
    required this.total,
  });

  @override
  List<Object?> get props => [offset, limit, total];

  Pagination copyWith({
    int? offet,
    int? limit,
    int? total,
  }) {
    return Pagination(
      offset: offet ?? offset,
      limit: limit ?? this.limit,
      total: total ?? this.total,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'offet': offset,
      'limit': limit,
      'total': total,
    };
  }

  factory Pagination.fromJson(Map<String, dynamic> map) {
    return Pagination(
      offset: map['offset'],
      limit: map['limit'],
      total: map['total'],
    );
  }
}
