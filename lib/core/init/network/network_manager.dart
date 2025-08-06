import 'dart:io';

import 'package:dio/dio.dart';
import 'package:smart_city/core/base/model/base_model.dart';
import 'package:smart_city/core/constants/enums/locale_keys_enum.dart';
import 'package:smart_city/core/init/cache/locale_manager.dart';

class NetworkManager {
  static NetworkManager? _instance;
  static NetworkManager get instance {
    _instance ??= NetworkManager._init();
    return _instance!;
  }

  NetworkManager._init() {
    final baseOptions = BaseOptions(
      baseUrl: "https://localhost:7276/api/",
      connectTimeout: const Duration(seconds: 3), // Reduced from 10 to 3 seconds
      receiveTimeout: const Duration(seconds: 3), // Reduced from 10 to 3 seconds
      sendTimeout: const Duration(seconds: 3), // Reduced from 10 to 3 seconds
      headers: {"val": LocaleManager.instance.getStringValue(PreferencesKeys.TOKEN) ?? ""},
    );

    dio = Dio(baseOptions);

    // Enhanced Retry interceptor with shorter delays
    dio.interceptors.add(
      RetryInterceptor(
        dio: dio,
        logPrint: print,
        retries: 1, // Reduced from 2 to 1 retry
        retryDelays: const [
          Duration(milliseconds: 500), // Reduced from 1 second to 500ms
        ],
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = LocaleManager.instance.getStringValue(PreferencesKeys.TOKEN) ?? "";
          if (token.isNotEmpty && token != "null" && token != "") {
            options.headers['Authorization'] = 'Bearer $token';
          }
          print("Request: ${options.method} ${options.path}");
          handler.next(options);
        },
        onResponse: (response, handler) {
          print("Response:[${response.statusCode}] =>${response.data}");
          handler.next(response);
        },
        onError: (error, handler) {
          print("Network Error: ${error.message}");
          print("Error Type: ${error.type}");
          print("Error Response: ${error.response?.data}");

          // Enhanced timeout error handling
          if (error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.receiveTimeout ||
              error.type == DioExceptionType.sendTimeout) {
            print("Timeout Error: Sunucu yanıt vermiyor. Lütfen internet bağlantınızı kontrol edin.");
          }

          handler.next(error);
        },
      ),
    );
  }
  late Dio dio;

  Future dioGet<T extends BaseModel>(String path, T model) async {
    try {
      final response = await dio.get(path);

      switch (response.statusCode) {
        case HttpStatus.ok:
          final responseBody = response.data;

          if (responseBody is List) {
            return responseBody.map((e) => model.fromJson(Map<String, dynamic>.from(e))).toList();
          } else if (responseBody is Map) {
            return model.fromJson(Map<String, dynamic>.from(responseBody));
          }
          return responseBody;

        default:
          throw Exception("Get request failed : ${response.statusCode}");
      }
    } on DioException catch (e) {
      print("DioException in dioGet: ${e.message}");
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw Exception("Sunucu yanıt vermiyor. Lütfen internet bağlantınızı kontrol edin.");
      }
      throw Exception("Ağ hatası: ${e.message}");
    } catch (e) {
      print("Unexpected error in dioGet: $e");
      throw Exception("Beklenmeyen hata: $e");
    }
  }

  Future dioPost<T extends BaseModel>(String path, T model, {Map<String, dynamic>? data}) async {
    try {
      final response = await dio.post(path, data: data);

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
        throw Exception("Sunucu yanıt vermiyor. Lütfen internet bağlantınızı kontrol edin.");
      }
      throw Exception("Ağ hatası: ${e.message}");
    } catch (e) {
      print("Unexpected error in dioPost: $e");
      throw Exception("Beklenmeyen hata: $e");
    }
  }
}

// Enhanced Retry Interceptor
class RetryInterceptor extends Interceptor {
  final Dio dio;
  final Function(String) logPrint;
  final int retries;
  final List<Duration> retryDelays;

  RetryInterceptor({
    required this.dio,
    required this.logPrint,
    this.retries = 1,
    this.retryDelays = const [Duration(milliseconds: 500)],
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
