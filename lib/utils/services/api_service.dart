import 'dart:developer';
import 'dart:typed_data';
import 'package:chat/core/event/global_event_bus.dart';
import 'package:chat/core/exception/exception.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ApiService {
  static ApiService? _instance;
  ApiService._(this._firebaseAuth) {
    const baseUrl = String.fromEnvironment(
      'BASE_URL',
      defaultValue: 'http://192.168.1.22:8000/',
    );
    _dio = Dio();
    _dio.options
      ..baseUrl = '$baseUrl/api/'
      ..connectTimeout = const Duration(seconds: 30)
      ..receiveTimeout = const Duration(seconds: 30)
      ..headers = {'Content-Type': 'application/json'};

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final user = _firebaseAuth.currentUser;
          if (user != null) {
            final token = await user.getIdToken();
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) {
          if (error.response?.statusCode == 401) {
            GlobalEventBus.emit(TokenExpiredEvent());
          }
          return handler.next(error);
        },
      ),
    );
  }

  static ApiService init(FirebaseAuth firebaseAuth) {
    _instance ??= ApiService._(firebaseAuth);
    return instance;
  }

  static ApiService get instance {
    if (_instance != null) return _instance!;
    throw Exception(
      'ApiService not initialized. Call ApiService.init() first.',
    );
  }

  late final Dio _dio;
  final FirebaseAuth _firebaseAuth;

  void _handleException(DioException e) {
    final statusCode = e.response?.statusCode ?? 0;
    final message =
        e.response?.data['error'] ?? e.message ?? 'An unknown error occurred';
    throw switch (statusCode) {
      400 => throw BadRequestException('Bad Request: $message'),
      401 => throw UnauthorizedException('Unauthorized: $message'),
      403 => throw ForbiddenException('Forbidden: $message'),
      404 => throw NotFoundException('Not Found: $message'),
      500 => throw ServerException('Server Error: $message'),
      _ => throw ServerException('$message'),
    };
  }

  Future<T> _handleError<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on DioException catch (e) {
      log('Dio Exception: ${e.message}', name: 'ApiService');
      _handleException(e);
      rethrow;
    }
  }

  Future<T> get<T>(String path, {Map<String, dynamic>? query}) async {
    return _handleError(() async {
      final response = await _dio.get(path, queryParameters: query);
      return response.data;
    });
  }

  Future<T> post<T>(String path, {Map<String, dynamic>? data}) async {
    return _handleError(() async {
      final response = await _dio.post(path, data: data);
      return response.data;
    });
  }

  Future<T> put<T>(String path, {Map<String, dynamic>? data}) async {
    return _handleError(() async {
      final response = await _dio.put(path, data: data);
      return response.data;
    });
  }

  Future<T> delete<T>(String path) async {
    return _handleError(() async {
      final response = await _dio.delete(path);
      return response.data;
    });
  }

  Future<T> patch<T>(String path, {Map<String, dynamic>? data}) async {
    return _handleError(() async {
      final response = await _dio.patch(path, data: data);
      return response.data;
    });
  }

  Future<T> upload<T>(
    String filePath, {
    required String storagePath,
    String? url,
    Map<String, dynamic>? data,
    void Function(int sent, int total)? progress,
  }) async {
    return _handleError(() async {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
        'storagePath': storagePath,
        ...?data,
      });
      final response = await _dio.post(
        url ?? 'upload',
        data: formData,
        onSendProgress: (sent, total) {
          if (progress != null) {
            progress(sent, total);
          }
        },
      );
      return response.data;
    });
  }

  Future<T> uploadData<T>(
    Uint8List fileData, {
    required String storagePath,
    String? url,
    Map<String, dynamic>? data,
    void Function(int sent, int total)? progress,
  }) async {
    return _handleError(() async {
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(fileData, filename: 'file'),
        'storagePath': storagePath,
        ...?data,
      });
      final response = await _dio.post(
        url ?? 'upload',
        data: formData,
        onSendProgress: (sent, total) {
          if (progress != null) {
            progress(sent, total);
          }
        },
      );
      return response.data;
    });
  }

  Future<T> uploadFiles<T>(
    List<String> filesPath, {
    required String storagePath,
    String? url,
    List<Map<String, dynamic>>? data,
    void Function(int sent, int total)? progress,
  }) async {
    return _handleError(() async {
      final multipart = filesPath.map((path) async {
        return MultipartFile.fromFile(path, filename: path);
      });
      final formData = FormData.fromMap({
        'file[]': await Future.wait(multipart),
        'storagePath': storagePath,
        'data': data,
      });

      final response = await _dio.post(
        url ?? 'uploads',
        data: formData,
        onSendProgress: (sent, total) {
          if (progress != null) {
            progress(sent, total);
          }
        },
      );
      return response.data;
    });
  }

  Future<T> uploadFilesData<T>(
    List<Uint8List> filesData, {
    required String storagePath,
    String? url,
    List<Map<String, dynamic>>? data,
    void Function(int sent, int total)? progress,
  }) async {
    return _handleError(() async {
      final formData = FormData.fromMap({
        'file[]': filesData
            .map((data) => MultipartFile.fromBytes(data, filename: 'file'))
            .toList(),
        'storagePath': storagePath,
        'data': data,
      });
      final response = await _dio.post(
        url ?? 'uploads',
        data: formData,
        onSendProgress: (sent, total) {
          if (progress != null) {
            progress(sent, total);
          }
        },
      );
      return response.data;
    });
  }

  Future<T> download<T>(
    String path, {
    void Function(int sent, int total)? progress,
  }) async {
    return _handleError(() async {
      final response = await _dio.download(
        path,
        'download',
        onReceiveProgress: (received, total) {
          if (progress != null) {
            progress(received, total);
          }
        },
      );
      return response.data;
    });
  }
}
