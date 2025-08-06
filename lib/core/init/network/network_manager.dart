import 'package:dio/dio.dart';
import 'package:smart_city/core/base/model/base_model.dart';
import 'dart:io';

class NetworkManager {
  static NetworkManager? _instance;
  static NetworkManager get instance {
    _instance ??= NetworkManager._init();
    return _instance!;
  }

  late final Dio dio;

  NetworkManager._init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://localhost:7001/api/',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Retry interceptor ekle
    dio.interceptors.add(
      RetryInterceptor(
        dio: dio,
        logPrint: (message) => print('NetworkManager: $message'),
        retries: 2,
        retryDelays: const [
          Duration(seconds: 2),
          Duration(seconds: 4),
        ],
      ),
    );

    // Error interceptor ekle
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          print('Network Error: ${error.message}');
          handler.next(error);
        },
      ),
    );
  }

  Future<T?> dioGet<T extends BaseModel>(String path, T model) async {
    try {
      final response = await dio.get(path).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw TimeoutException('Request timeout after 15 seconds');
        },
      );

      switch (response.statusCode) {
        case HttpStatus.ok:
          final responseBody = response.data;
          if (responseBody is List) {
            return responseBody.map((item) => model.fromJson(Map<String, dynamic>.from(item))).cast<T>().toList() as T;
          } else if (responseBody is Map) {
            return model.fromJson(Map<String, dynamic>.from(responseBody));
          }
          return responseBody;

        case HttpStatus.noContent:
          return null;

        default:
          throw Exception("Get request failed : ${response.statusCode}");
      }
    } on DioException catch (e) {
      print("DioException in dioGet: ${e.message}");
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw TimeoutException("Sunucu yanıt vermiyor. Lütfen internet bağlantınızı kontrol edin.");
      }
      throw Exception("Ağ hatası: ${e.message}");
    } on TimeoutException catch (e) {
      print("TimeoutException in dioGet: $e");
      throw TimeoutException("İstek zaman aşımına uğradı. Lütfen tekrar deneyin.");
    } catch (e) {
      print("Unexpected error in dioGet: $e");
      throw Exception("Beklenmeyen hata: $e");
    }
  }

  Future<T?> dioPost<T extends BaseModel>(String path, T model, {Map<String, dynamic>? data}) async {
    try {
      final response = await dio.post(path, data: data).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw TimeoutException('Request timeout after 15 seconds');
        },
      );

      switch (response.statusCode) {
        case HttpStatus.ok:
        case HttpStatus.created:
          final responseBody = response.data;
          if (responseBody is Map) {
            return model.fromJson(Map<String, dynamic>.from(responseBody));
          }
          return responseBody;

        default:
          throw Exception("Post request failed ${response.statusCode}");
      }
    } on DioException catch (e) {
      print("DioException in dioPost: ${e.message}");
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw TimeoutException("Sunucu yanıt vermiyor. Lütfen internet bağlantınızı kontrol edin.");
      }
      throw Exception("Ağ hatası: ${e.message}");
    } on TimeoutException catch (e) {
      print("TimeoutException in dioPost: $e");
      throw TimeoutException("İstek zaman aşımına uğradı. Lütfen tekrar deneyin.");
    } catch (e) {
      print("Unexpected error in dioPost: $e");
      throw Exception("Beklenmeyen hata: $e");
    }
  }
}

// Timeout Exception sınıfı
class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);
  
  @override
  String toString() => message;
}

// Retry Interceptor sınıfı
class RetryInterceptor extends Interceptor {
  final Dio dio;
  final Function(String) logPrint;
  final int retries;
  final List<Duration> retryDelays;

  RetryInterceptor({
    required this.dio,
    required this.logPrint,
    this.retries = 2,
    this.retryDelays = const [
      Duration(seconds: 2),
      Duration(seconds: 4),
    ],
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    var extra = err.requestOptions.extra;
    var retryCount = extra['retryCount'] ?? 0;

    if (_shouldRetry(err) && retryCount < retries) {
      logPrint('Retrying request (${retryCount + 1}/$retries)');
      
      await Future.delayed(retryDelays[retryCount]);
      
      extra['retryCount'] = retryCount + 1;
      
      try {
        final response = await dio.fetch(err.requestOptions);
        handler.resolve(response);
        return;
      } catch (e) {
        handler.next(err);
        return;
      }
    }
    
    handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
           err.type == DioExceptionType.receiveTimeout ||
           err.type == DioExceptionType.sendTimeout ||
           err.type == DioExceptionType.connectionError;
  }
}
