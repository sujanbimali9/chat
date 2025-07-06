import 'package:chat/core/common/model/pagination.dart';
import 'package:equatable/equatable.dart';

class ApiResponse<T> extends Equatable {
  final String? message;
  final List<T> data;
  final Pagination pagination;
  final ApiDataSource dataSource;

  const ApiResponse({
    this.message,
    required this.data,
    required this.pagination,
    required this.dataSource,
  });

  @override
  List<Object?> get props => [pagination, message, data, dataSource];

  factory ApiResponse.fromJson(
      Map<String, dynamic> map, T Function(Object?) fromJson,
      {ApiDataSource? dataSource}) {
    return ApiResponse(
      message: map['message'],
      data: (map['data'] as List).map<T>(fromJson).toList(),
      pagination: Pagination.fromJson(map['pagination']),
      dataSource: dataSource ?? ApiDataSource.remote,
    );
  }
  ApiResponse<T> copyWith({
    String? message,
    List<T>? data,
    Pagination? pagination,
    ApiDataSource? dataSource,
  }) {
    return ApiResponse(
      message: message ?? this.message,
      data: data ?? this.data,
      pagination: pagination ?? this.pagination,
      dataSource: dataSource ?? this.dataSource,
    );
  }

  ApiResponse<X> map<X>(X Function(T) f) {
    return ApiResponse(
      message: message,
      data: data.map(f).toList(),
      pagination: pagination,
      dataSource: dataSource,
    );
  }

  Map<String, dynamic> toJson(
    Object? Function(T) toJson,
  ) {
    return {
      'pagination': pagination.toJson(),
      'message': message,
      'data': data.map(toJson).toList(),
    };
  }
}

enum ApiDataSource {
  remote,
  local,
}
