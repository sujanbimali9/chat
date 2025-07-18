import 'package:equatable/equatable.dart';

class ApiResponse<T, U> extends Equatable {
  final String? message;
  final List<T> data;
  final U pagination;
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
    Map<String, dynamic> map,
    T Function(dynamic) fromJson,
    U Function(Map<String, dynamic>) fromJsonPagination, {
    ApiDataSource? dataSource,
  }) {
    return ApiResponse(
      message: map['message'],
      data: (map['data'] as List).map<T>(fromJson).toList(),
      pagination: fromJsonPagination(map['pagination']),
      dataSource: dataSource ?? ApiDataSource.remote,
    );
  }
  ApiResponse<T, U> copyWith({
    String? message,
    List<T>? data,
    U? pagination,
    ApiDataSource? dataSource,
  }) {
    return ApiResponse(
      message: message ?? this.message,
      data: data ?? this.data,
      pagination: pagination ?? this.pagination,
      dataSource: dataSource ?? this.dataSource,
    );
  }

  ApiResponse<X, U> map<X>(X Function(T) f) {
    return ApiResponse(
      message: message,
      data: data.map(f).toList(),
      pagination: pagination,
      dataSource: dataSource,
    );
  }

  Map<String, dynamic> toJson(
    Object? Function(T) toJson,
    Object Function(U) paginationToJson,
  ) {
    return {
      'pagination': paginationToJson(pagination),
      'message': message,
      'data': data.map(toJson).toList(),
    };
  }
}

enum ApiDataSource { remote, local }
